//
//  Piggy_BankApp.swift
//  Piggy Bank
//
//  Created by Cesar Ibarra on 1/26/25.
//

import SwiftUI
import SwiftData

@main
struct Piggy_BankApp: App {
    var body: some Scene {
        WindowGroup {
//            ContentView()
            PiggyBankListView()
                .modelContainer(for: PiggyBank.self)
        }
    }
}
