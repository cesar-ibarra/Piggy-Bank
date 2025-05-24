//
//  PurchasedValidated.swift
//  Piggy Bank
//
//  Created by Cesar Ibarra on 5/24/25.
//

import SwiftUI
import StoreKit

struct PurchasedValidated: View {
    @ObservedObject var storeKit : StoreKitManager
    @State var isPurchased: Bool = false
    var product: Product
    
    var body: some View {
        VStack {
            if isPurchased {
                Text(Image(systemName: "checkmark"))
                    .bold()
                    .padding(10)
            } else {
                Text(product.displayPrice)
                    .padding(10)
            }
        }
        .onChange(of: storeKit.purchasedCoffeeForMe) { oldValue, item in
            Task {
                isPurchased = (try? await storeKit.isPurchased(product)) ?? false
            }
        }
    }
}
