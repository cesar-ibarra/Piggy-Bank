//
//  Helper.swift
//  Piggy Bank
//
//  Created by Cesar Ibarra on 5/8/25.
//

import Foundation
import SwiftUI

extension PiggyBankDetailView {
    func addCoin() {
        if let amount = Double(newCoin), amount > 0 {
            let newEntry = CoinEntry(amount: amount, date: Date())
            piggyBank.coins.append(newEntry)
            newCoin = ""

            if piggyBank.total >= piggyBank.savingGoal && !piggyBank.isCompleted {
                piggyBank.isCompleted = true
                showGoalCompleteAlert = true
            }
        }
    }

    func deleteCoin(at offsets: IndexSet) {
        for offset in offsets {
            let coinToDelete = sortedCoins[offset]
            if let realIndex = piggyBank.coins.firstIndex(where: { $0.date == coinToDelete.date }) {
                piggyBank.coins.remove(at: realIndex)
            }
        }
    }

    func startEditing(_ coin: CoinEntry) {
        editingCoin = coin
        editedAmount = String(coin.amount)
        showEditAlert = true
    }

    func saveEditedCoin() {
        if let newAmount = Double(editedAmount),
           let index = piggyBank.coins.firstIndex(where: { $0.date == editingCoin?.date }) {
            piggyBank.coins[index].amount = newAmount
            piggyBank.coins[index].date = editedDate
        }
    }
}
