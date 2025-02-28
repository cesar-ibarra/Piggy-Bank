//
//  PiggyBankModel.swift
//  Piggy Bank
//
//  Created by Cesar Ibarra on 1/26/25.
//

import SwiftData
import Foundation

struct CoinEntry: Codable {
    var amount: Double
    var date: Date
}

@Model
class PiggyBank {
    @Attribute(.unique) var goalName: String
    var savingGoal: Double
    var coins: [CoinEntry] = []
    var isCompleted: Bool
    var createdAt: Date
    var imageData: Data?

    @Transient
    var total: Double {
        return coins.reduce(0) { $0 + $1.amount }
    }
    
    @Transient
    var percentage: Double {
        return savingGoal > 0 ? total / savingGoal : 0.0
    }
    
    init(goalName: String, savingGoal: Double, isCompleted: Bool, imageData: Data? = nil) {
        self.goalName = goalName
        self.savingGoal = savingGoal
        self.isCompleted = isCompleted
        self.createdAt = Date()
        self.imageData = imageData
    }
}
