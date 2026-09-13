//
//  PurchasedValidated.swift
//  Piggy Bank
//
//  Created by Cesar Ibarra on 5/24/25.
//
//  Reads purchase state directly from the published property instead of
//  mirroring it into a separate @State — avoids missed .onChange timing.
//

import SwiftUI
import StoreKit

struct PurchasedValidated: View {
    @ObservedObject var storeKit: StoreKitManager
    var product: Product

    private var isPurchased: Bool {
        storeKit.purchasedCoffeeForMe.contains(product)
    }

    var body: some View {
        Group {
            if isPurchased {
                Text(Image(systemName: "checkmark"))
                    .bold()
            } else {
                Text(product.displayPrice)
            }
        }
        .padding(10)
    }
}
