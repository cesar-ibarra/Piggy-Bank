//
//  L10n.swift
//  Piggy Bank
//
//  Created by Cesar Ibarra on 9/11/26.
//
//  Centralized, typed access to Localizable.strings (en / es).
//  Add new UI copy here first, then add the matching key to both
//  en.lproj/Localizable.strings and es.lproj/Localizable.strings.
//

import Foundation

enum L10n {

    enum Nav {
        static let piggyBanks = String(localized: "nav.piggyBanks")
        static let details = String(localized: "nav.details")
        static let newPiggyBank = String(localized: "nav.newPiggyBank")
    }

    enum List {
        static let emptyTitle = String(localized: "list.empty.title")
        static let emptyMessage = String(localized: "list.empty.message")
        static let completed = String(localized: "list.completed")

        static func remaining(_ amount: String) -> String {
            String(format: String(localized: "list.remaining"), amount)
        }

        static func savedOfGoal(_ saved: String, _ goal: String) -> String {
            String(format: String(localized: "list.savedOfGoal"), saved, goal)
        }
    }

    enum Form {
        static let sectionGoal = String(localized: "form.section.goal")
        static let sectionImage = String(localized: "form.section.image")
        static let goalName = String(localized: "form.goalName")
        static let goalAmount = String(localized: "form.goalAmount")
        static let selectImage = String(localized: "form.selectImage")
        static let changeImage = String(localized: "form.changeImage")
        static let cancel = String(localized: "form.cancel")
        static let save = String(localized: "form.save")
    }

    enum Detail {
        static let savingsHistory = String(localized: "detail.savingsHistory")
        static let addSavings = String(localized: "detail.addSavings")
        static let editEntry = String(localized: "detail.editEntry")
        static let editGoal = String(localized: "detail.editGoal")
        static let amount = String(localized: "detail.amount")
        static let date = String(localized: "detail.date")
        static let noEntries = String(localized: "detail.noEntries")

        static func currentSavings(_ saved: String, _ goal: String) -> String {
            String(format: String(localized: "detail.currentSavings"), saved, goal)
        }
    }

    enum GoalComplete {
        static let title = String(localized: "goalComplete.title")
        static let message = String(localized: "goalComplete.message")
        static let button = String(localized: "goalComplete.button")
    }

    enum Support {
        static let buyMeCoffee = String(localized: "support.buyMeCoffee")
    }

    enum Common {
        static let delete = String(localized: "common.delete")
        static let edit = String(localized: "common.edit")
    }
}
