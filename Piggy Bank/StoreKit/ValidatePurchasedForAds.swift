//
//  ValidatePurchasedForAds.swift
//  Piggy Bank
//
//  Created by Cesar Ibarra on 5/24/25.
//
//  Reads purchase state directly from the published property instead of
//  mirroring it into a separate @State — avoids missed .onChange timing.
//

import SwiftUI
import StoreKit

struct ValidatePurchasedForAds: View {
    @ObservedObject var storeKit: StoreKitManager
    var product: Product

    private var isPurchased: Bool {
        storeKit.purchasedCoffeeForMe.contains(product)
    }

    var body: some View {
        if !isPurchased {
            // MARK: - BANNER
            BannerAd(unitID: "ca-app-pub-9405221176366476/3942118588")
                .frame(width: 320, height: 100)
                .padding()
        }
    }
}
