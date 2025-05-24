//
//  Piggy_BankApp.swift
//  Piggy Bank
//
//  Created by Cesar Ibarra on 1/26/25.
//

import SwiftUI
import SwiftData
import GoogleMobileAds

@main
struct Piggy_BankApp: App {
    
    init() {
        MobileAds.shared.start(completionHandler: nil)
    }
    
    var body: some Scene {
        WindowGroup {
//            ContentView()
            PiggyBankListView()
                .modelContainer(for: PiggyBank.self)
        }
    }
}
