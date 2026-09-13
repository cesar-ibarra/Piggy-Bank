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
    @Query(sort: \PiggyBank.createdAt, order: .reverse) private var piggyBanks: [PiggyBank]

    @State private var showingAddPiggyBank = false
    @State private var showingTipsView = false

    @StateObject var storeKit = StoreKitManager()

    var body: some View {
        NavigationStack {
            Group {
                if piggyBanks.isEmpty {
                    emptyState
                } else {
                    list
                }
            }
            .navigationTitle(L10n.Nav.piggyBanks)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button {
                        showingAddPiggyBank = true
                    } label: {
                        Image(systemName: "plus.circle.fill")
                            .font(.title2)
                    }
                }

                ToolbarItem(placement: .navigationBarLeading) {
                    Button {
                        showingTipsView = true
                    } label: {
                        Text(L10n.Support.buyMeCoffee)
                            .font(.subheadline)
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

    private var list: some View {
        List {
            ForEach(piggyBanks) { piggyBank in
                NavigationLink(destination: PiggyBankDetailView(piggyBank: piggyBank)) {
                    PiggyBankRowView(piggyBank: piggyBank)
                }
                .listRowSeparator(.hidden)
                .listRowBackground(Color.clear)
                .listRowInsets(EdgeInsets(top: 6, leading: 16, bottom: 6, trailing: 16))
                .swipeActions(edge: .trailing) {
                    Button(role: .destructive) {
                        delete(piggyBank)
                    } label: {
                        Label(L10n.Common.delete, systemImage: "trash")
                    }
                }
            }
        }
        .listStyle(.plain)
        .background(Color(.systemGroupedBackground))
        .scrollContentBackground(.hidden)
    }

    private var emptyState: some View {
        ContentUnavailableView(
            L10n.List.emptyTitle,
            systemImage: "banknote",
            description: Text(L10n.List.emptyMessage)
        )
    }

    private func delete(_ piggyBank: PiggyBank) {
        withAnimation {
            modelContext.delete(piggyBank)
        }
    }
}

#Preview {
    PiggyBankListView()
        .modelContainer(PersistenceController.preview)
}
