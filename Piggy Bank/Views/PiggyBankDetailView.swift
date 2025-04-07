//
//  PiggyBankDetailView.swift
//  Piggy Bank
//
//  Created by Cesar Ibarra on 2/18/25.
//

import SwiftUI

struct PiggyBankDetailView: View {
    @Bindable var piggyBank: PiggyBank
    @State private var newCoin: String = ""
    @State private var showAddAlert = false
    @State private var editingCoin: CoinEntry?
    @State private var editedAmount: String = ""
    @State private var showEditAlert = false
    
    @State private var showGoalCompleteAlert = false
    
    var sortedCoins: [CoinEntry] {
        piggyBank.coins.sorted(by: { $0.date > $1.date })
    }
    
    var body: some View {
        VStack(spacing: 8) {
            if let imageData = piggyBank.imageData, let uiImage = UIImage(data: imageData) {
                Image(uiImage: uiImage)
                    .resizable()
                    .scaledToFit()
                    .frame(height: 100) // Reduce el tamaño de la imagen
                    .clipShape(Circle())
            }
            
            VStack(spacing: 4) { // Reduce espacio en los detalles
                HStack {
                    Text(piggyBank.goalName)
                        .font(.title2)
                        .bold()
                    
                    if piggyBank.isCompleted {
                        Text("Completed")
                            .font(.caption)
                            .padding(.horizontal, 8)
                            .padding(.vertical, 4)
                            .background(Color.green.opacity(0.2))
                            .foregroundColor(.black)
                            .clipShape(Capsule())
                            .transition(.opacity.combined(with: .scale))
                            .animation(.spring(), value: piggyBank.isCompleted)
                    }
                }
                
                ProgressView(value: piggyBank.percentage)
                    .progressViewStyle(LinearProgressViewStyle())
                    .frame(width: 200)
                
                Text("Current Savings: $\(piggyBank.total, specifier: "%.2f") / $\(piggyBank.savingGoal, specifier: "%.2f")")
                    .font(.subheadline)
                    .foregroundColor(.gray)
            }
            .padding(.bottom, 4) // Reduce el espacio antes de Savings History
            
            Divider()
            
            Text("Savings History")
                .font(.headline)
                .padding(.vertical, 6) // Asegura un buen espacio para la lista
            
            List {
                ForEach(sortedCoins, id: \.date) { coin in
                    HStack {
                        Text("$\(coin.amount, specifier: "%.2f")")
                            .font(.body)
                        Spacer()
                        Text(coin.date.formatted(date: .abbreviated, time: .omitted))
                            .font(.caption)
                            .foregroundColor(.gray)
                    }
                    .contentShape(Rectangle())
                    .onTapGesture {
                        if !piggyBank.isCompleted {
                            startEditing(coin)
                        }
                    }
                }
                .onDelete(perform: piggyBank.isCompleted ? nil : deleteCoin)
            }
            .listStyle(PlainListStyle()) // Más espacio para la lista
        }
        .padding()
        .navigationTitle("Details")
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                Button(action: { showAddAlert = true }) {
                    Image(systemName: "plus")
                        .font(.title2)
                }
                .disabled(piggyBank.isCompleted) // Desactiva el botón si ya está completado
            }
        }
        .alert("Add Amount", isPresented: $showAddAlert) {
            TextField("Enter amount", text: $newCoin)
                .keyboardType(.decimalPad)
            Button("Cancel", role: .cancel) {}
            Button("Save") {
                addCoin()
            }
        }
        .alert("Edit Amount", isPresented: $showEditAlert) {
            TextField("Enter new amount", text: $editedAmount)
                .keyboardType(.decimalPad)
            Button("Cancel", role: .cancel) {}
            Button("Save") {
                saveEditedCoin()
            }
        }
        .alert("🎉 Goal Complete!", isPresented: $showGoalCompleteAlert) {
            Button("Awesome!", role: .cancel) {}
        } message: {
            Text("You’ve reached your savings goal. Well done!")
        }
        // MARK: - BANNER
        AdMobBanner()
            .frame(width: 320, height: 100)
    }
    
    private func addCoin() {
        if let amount = Double(newCoin), amount > 0 {
            let newEntry = CoinEntry(amount: amount, date: Date())
            piggyBank.coins.append(newEntry)
            newCoin = ""
            
            if piggyBank.total >= piggyBank.savingGoal && !piggyBank.isCompleted {
                piggyBank.isCompleted = true
                showGoalCompleteAlert = true
            }
        }
    }
    
    private func deleteCoin(at offsets: IndexSet) {
        for offset in offsets {
            let coinToDelete = sortedCoins[offset]
            if let realIndex = piggyBank.coins.firstIndex(where: { $0.date == coinToDelete.date }) {
                piggyBank.coins.remove(at: realIndex)
            }
        }
    }
    
    private func startEditing(_ coin: CoinEntry) {
        editingCoin = coin
        editedAmount = String(coin.amount)
        showEditAlert = true
    }
    
    private func saveEditedCoin() {
        if let newAmount = Double(editedAmount), newAmount > 0, let index = piggyBank.coins.firstIndex(where: { $0.date == editingCoin?.date }) {
            piggyBank.coins[index].amount = newAmount
        }
    }
}

//#Preview {
//    PiggyBankDetailView()
//}
