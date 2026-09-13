//
//  Helper.swift
//  Piggy Bank
//
//  Created by Cesar Ibarra on 5/8/25.
//

import Foundation
import SwiftUI

extension PiggyBankDetailView {

    /// Adds `newCoin` (typed amount) as a new savings entry, then checks
    /// whether the goal was just completed.
    func addCoin() {
        guard let amount = Double(newCoin), amount > 0 else { return }

        let newEntry = CoinEntry(amount: amount, date: Date())
        piggyBank.coins.append(newEntry)
        newCoin = ""

        if piggyBank.total >= piggyBank.savingGoal && !piggyBank.isCompleted {
            piggyBank.isCompleted = true
            showGoalCompleteAlert = true
        }
    }

    /// Removes a single savings entry, matched by its (unique-enough) date.
    func deleteCoin(_ coin: CoinEntry) {
        if let index = piggyBank.coins.firstIndex(where: { $0.date == coin.date }) {
            piggyBank.coins.remove(at: index)
        }
    }

    func startEditing(_ coin: CoinEntry) {
        editingCoin = coin
        editedAmount = String(coin.amount)
        editedDate = coin.date
        showEditSheet = true
    }

    /// Commits `editedAmount` / `editedDate` back onto the entry being edited.
    func saveEditedCoin() {
        if let newAmount = Double(editedAmount),
           let index = piggyBank.coins.firstIndex(where: { $0.date == editingCoin?.date }) {
            piggyBank.coins[index].amount = newAmount
            piggyBank.coins[index].date = editedDate
        }
    }

    /// Commits a name/amount edit onto the goal itself.
    func saveEditedGoal(name: String, amount: String) {
        guard !name.isEmpty, let newGoal = Double(amount) else { return }
        piggyBank.goalName = name
        piggyBank.savingGoal = newGoal
    }
}
