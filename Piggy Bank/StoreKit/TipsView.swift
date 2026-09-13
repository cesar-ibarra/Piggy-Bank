//
//  TipsView.swift
//  Piggy Bank
//
//  Created by Cesar Ibarra on 5/24/25.
//
//  Presented as a popover anchored to the "Support the App" toolbar icon —
//  kept compact and minimal since it no longer needs to fill the screen.
//  Shares the same StoreKitManager instance as PiggyBankListView so the
//  toolbar icon and this view never disagree about purchase state.
//

import SwiftUI

struct TipsView: View {
    @ObservedObject var storeKit: StoreKitManager

    private var isPurchased: Bool {
        !storeKit.purchasedCoffeeForMe.isEmpty
    }

    var body: some View {
        Group {
            if !isPurchased {
                content
            } else {
                ThanksView()
            }
        }
        .frame(width: 280)
    }

    private var content: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text(L10n.Support.title)
                .font(.headline)

            Text(L10n.Support.message)
                .font(.subheadline)
                .foregroundStyle(.secondary)

            ForEach(storeKit.storeProducts) { product in
                Button {
                    Task {
                        try? await storeKit.purchase(product)
                    }
                } label: {
                    HStack {
                        VStack(alignment: .leading, spacing: 2) {
                            Text(product.displayName)
                                .font(.subheadline.weight(.semibold))
                            Text(product.description)
                                .font(.caption)
                                .foregroundStyle(.secondary)
                        }

                        Spacer()

                        PurchasedValidated(storeKit: storeKit, product: product)
                    }
                    .padding(10)
                    .background(Color("cell-background"), in: RoundedRectangle(cornerRadius: 12, style: .continuous))
                }
                .buttonStyle(.plain)
            }

            Button {
                Task {
                    try? await storeKit.restorePurchases()
                }
            } label: {
                Text(L10n.Support.restore)
                    .font(.footnote)
                    .foregroundStyle(.secondary)
                    .frame(maxWidth: .infinity, alignment: .center)
            }
            .buttonStyle(.plain)
        }
        .padding(16)
    }
}

#Preview {
    TipsView(storeKit: StoreKitManager())
}
