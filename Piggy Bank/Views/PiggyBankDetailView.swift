//
//  PiggyBankDetailView.swift
//  Piggy Bank
//
//  Created by Cesar Ibarra on 2/18/25.
//

import SwiftUI
import StoreKit

struct PiggyBankDetailView: View {
    @Bindable var piggyBank: PiggyBank
    @State var newCoin: String = ""
    @State private var showAddAlert = false
    @State var editingCoin: CoinEntry?
    @State var editedAmount: String = ""
    @State var showEditAlert = false

    @State var showGoalCompleteAlert = false

    @State var editedDate: Date = Date()
    @State private var showEditSheet = false

    @State private var showImagePicker = false
    @State private var selectedImage: UIImage? = nil
    
    var sortedCoins: [CoinEntry] {
        piggyBank.coins.sorted(by: { $0.date > $1.date })
    }
    
    @StateObject var storeKit = StoreKitManager()
    
    var body: some View {
        VStack(spacing: 8) {
            ZStack(alignment: .bottomTrailing) {
                if let imageData = piggyBank.imageData, let uiImage = UIImage(data: imageData) {
                    Image(uiImage: uiImage)
                        .resizable()
                        .scaledToFit()
                        .frame(height: 100)
                        .clipShape(Circle())
                } else {
                    Image(systemName: "photo")
                        .resizable()
                        .scaledToFit()
                        .frame(height: 100)
                        .clipShape(Circle())
                }
                Button {
                    showImagePicker = true
                } label: {
                    Image(systemName: "pencil.circle.fill")
                        .foregroundColor(.white)
                        .padding(6)
                        .background(Color.black.opacity(0.6))
                        .clipShape(Circle())
                }
                .offset(x: -6, y: -6)
            }
            
            VStack(spacing: 4) { // Reduce espacio en los detalles
                ZStack {
                    Text(piggyBank.goalName)
                        .font(.title2)
                        .bold()
                        .multilineTextAlignment(.center)
                        .frame(maxWidth: .infinity)
                        .onTapGesture {
                            editedAmount = String(piggyBank.savingGoal)
                            showEditAlert = true
                        }

                    HStack {
                        Spacer()
                        Button {
                            editedAmount = String(piggyBank.savingGoal)
                            showEditAlert = true
                        } label: {
                            Image(systemName: "pencil")
                                .foregroundColor(.blue)
                                .padding(.trailing, 4)
                        }
                    }
                }
                
                ProgressView(value: piggyBank.percentage)
                    .progressViewStyle(LinearProgressViewStyle())
                    .frame(width: 200)
                
                let remaining = max(piggyBank.savingGoal - piggyBank.total, 0)

                if piggyBank.isCompleted {
                    Text("🎉 Goal achieved!")
                        .font(.caption)
                        .foregroundColor(.green)
                        .transition(.opacity)
                } else {
                    Text("💸 $\(remaining, specifier: "%.2f") left to reach your goal")
                        .font(.caption)
                        .foregroundColor(.secondary)
                }

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
                            editingCoin = coin
                            editedAmount = String(coin.amount)
                            editedDate = coin.date
                            showEditSheet = true
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
        .alert("Edit Goal", isPresented: $showEditAlert) {
            TextField("Goal name", text: $piggyBank.goalName)
            TextField("Saving goal", text: $editedAmount)
                .keyboardType(.decimalPad)
            Button("Cancel", role: .cancel) {}
            Button("Save") {
                if let newGoal = Double(editedAmount) {
                    piggyBank.savingGoal = newGoal
                }
            }
        }
        .sheet(isPresented: $showEditSheet) {
            NavigationStack {
                Form {
                    Section {
                        HStack {
                            Image(systemName: "dollarsign.circle")
                                .foregroundColor(.blue)
                            TextField("Amount", text: $editedAmount)
                                .keyboardType(.decimalPad)
                        }
                    }

                    Section {
                        HStack {
                            Image(systemName: "calendar")
                                .foregroundColor(.blue)
                            DatePicker("Date", selection: $editedDate, displayedComponents: .date)
                                .labelsHidden()
                        }
                    }
                }
                .navigationTitle("Edit Savings Entry")
                .navigationBarTitleDisplayMode(.inline)
                .toolbar {
                    ToolbarItem(placement: .cancellationAction) {
                        Button("Cancel", role: .cancel) {
                            showEditSheet = false
                        }
                    }
                    ToolbarItem(placement: .confirmationAction) {
                        Button("Save") {
                            saveEditedCoin()
                            showEditSheet = false
                        }
                        .disabled(editedAmount.isEmpty)
                    }
                }
            }
            .presentationDetents([.medium, .large])
            .presentationCornerRadius(20)
        }
        .alert("🎉 Goal Complete!", isPresented: $showGoalCompleteAlert) {
            Button("Awesome!", role: .cancel) {}
        } message: {
            Text("You’ve reached your savings goal. Well done!")
        }
        // MARK: - BANNER
        ForEach(storeKit.storeProducts) { product in
            ValidatePurchasedForAds(storeKit: storeKit, product: product)
        }
        
        // Image picker sheet and onChange for selected image
        .sheet(isPresented: $showImagePicker) {
            ImagePicker(selectedImage: $selectedImage)
        }
        .onChange(of: selectedImage) { oldValue, newValue in
            if let image = newValue {
                piggyBank.imageData = image.jpegData(compressionQuality: 0.8)
            }
        }
    }
}

//#Preview {
//    PiggyBankDetailView()
//}
