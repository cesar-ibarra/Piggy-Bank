//
//  ValidatePurchasedForAds.swift
//  Piggy Bank
//
//  Created by Cesar Ibarra on 5/24/25.
//

import SwiftUI
import StoreKit

struct ValidatePurchasedForAds: View {
    @ObservedObject var storeKit : StoreKitManager
    @State var isPurchased: Bool = false
    var product: Product
    
    var body: some View {
        VStack {
            if !isPurchased {
                // MARK: - BANNER
                BannerAd(unitID: "ca-app-pub-9405221176366476/3942118588")
                    .frame(width: 320, height: 100)
                    .padding()
            }
        }
        .onChange(of: storeKit.purchasedCoffeeForMe) { oldValue, item in
            Task {
                isPurchased = (try? await storeKit.isPurchased(product)) ?? false
            }
        }
    }
}
