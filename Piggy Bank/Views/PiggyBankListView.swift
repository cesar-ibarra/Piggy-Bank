//
//  PiggyBankListView.swift
//  Piggy Bank
//
//  Created by Cesar Ibarra on 2/18/25.
//

import SwiftUI
import SwiftData
import StoreKit

struct PiggyBankListView: View {
    @Environment(\.modelContext) private var modelContext
    @Query private var piggyBanks: [PiggyBank]
    
    @State private var showingAddPiggyBank = false
    @State private var showingTipsView = false
    
    @StateObject var storeKit = StoreKitManager()
    
    var body: some View {
        NavigationStack {
            List {
                ForEach(piggyBanks) { piggyBank in
                    NavigationLink(destination: PiggyBankDetailView(piggyBank: piggyBank)) {
                        HStack {
                            if let imageData = piggyBank.imageData, let uiImage = UIImage(data: imageData) {
                                Image(uiImage: uiImage)
                                    .resizable()
                                    .scaledToFill()
                                    .frame(width: 50, height: 50)
                                    .clipShape(Circle())
                            } else {
                                Image(systemName: "banknote.fill")
                                    .resizable()
                                    .scaledToFit()
                                    .frame(width: 50, height: 50)
                                    .foregroundColor(.blue)
                            }
                            
                            VStack(alignment: .leading, spacing: 4) {
                                Text(piggyBank.goalName)
                                    .font(.headline)
                                    .foregroundStyle(piggyBank.isCompleted ? .green : .primary)
                                
                                ProgressView(value: min(piggyBank.percentage, 1.0))
                                    .progressViewStyle(LinearProgressViewStyle())
                                    .tint(piggyBank.isCompleted ? .green : .blue)
                                
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
                                
                                Text("Savings: $\(piggyBank.total, specifier: "%.2f") / $\(piggyBank.savingGoal, specifier: "%.2f")")
                                    .font(.caption)
                            }
                        }
                    }
                }
                .onDelete(perform: deletePiggyBank)
            }
            .overlay {
                if piggyBanks.isEmpty {
                    ContentUnavailableView("Goals", systemImage: "banknote", description: Text("No goal yet. Add one to get started!"))
                }
            }
            .navigationTitle("Piggy Banks")
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button {
                        showingAddPiggyBank = true
                    } label: {
                        Image(systemName: "plus")
                    }
                }
                
                ToolbarItem(placement: .navigationBarLeading) {
                    Button {
                        showingTipsView = true
                    } label: {
                        Image(systemName: "heart.fill")
                    }
                }
            }
            .sheet(isPresented: $showingAddPiggyBank) {
                AddPiggyBankView()
            }
            .overlay {
                if showingTipsView {
                    Color.black.opacity(0.8)
                        .ignoresSafeArea()
                        .transition(.opacity)
                        .onTapGesture {
                            showingTipsView.toggle()
                        }
                    TipsView {
                        showingTipsView.toggle()
                    }
                    .transition(.move(edge: .bottom).combined(with: .opacity))
                }
            }
            .animation(.spring(), value: showingTipsView)
            
            // MARK: - BANNER
            ForEach(storeKit.storeProducts) { product in
                ValidatePurchasedForAds(storeKit: storeKit, product: product)
            }
        }
    }
    
    private func deletePiggyBank(at offsets: IndexSet) {
        for index in offsets {
            modelContext.delete(piggyBanks[index])
        }
    }
}

#Preview {
    PiggyBankListView()
        .modelContainer(for: PiggyBank.self, inMemory: true)
}
