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

    var body: some View {
        VStack(spacing: 8) { // Reduce espacio vertical
            if let imageData = piggyBank.imageData, let uiImage = UIImage(data: imageData) {
                Image(uiImage: uiImage)
                    .resizable()
                    .scaledToFit()
                    .frame(height: 100) // Reduce el tamaño de la imagen
                    .clipShape(Circle())
            }

            VStack(spacing: 4) { // Reduce espacio en los detalles
                Text(piggyBank.goalName)
                    .font(.title2)
                    .bold()

                ProgressView(value: piggyBank.percentage)
                    .progressViewStyle(LinearProgressViewStyle())
                    .frame(width: 200) // Hace la barra de progreso más compacta

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
                ForEach(piggyBank.coins.sorted(by: { $0.date > $1.date }), id: \.date) { coin in
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
                        startEditing(coin)
                    }
                }
                .onDelete(perform: deleteCoin)
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
    }

    private func addCoin() {
        if let amount = Double(newCoin), amount > 0 {
            let newEntry = CoinEntry(amount: amount, date: Date())
            piggyBank.coins.append(newEntry)
            newCoin = ""
        }
    }

    private func deleteCoin(at offsets: IndexSet) {
        for index in offsets {
            piggyBank.coins.remove(at: index)
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
