//
//  PiggyBankRowView.swift
//  Piggy Bank
//
//  Card-style row for a single piggy bank in the list screen.
//

import SwiftUI

struct PiggyBankRowView: View {
    let piggyBank: PiggyBank

    private var remaining: Double {
        max(piggyBank.savingGoal - piggyBank.total, 0)
    }

    var body: some View {
        HStack(spacing: 14) {
            avatar

            VStack(alignment: .leading, spacing: 6) {
                Text(piggyBank.goalName)
                    .font(.headline)
                    .foregroundStyle(piggyBank.isCompleted ? .green : .primary)
                    .lineLimit(1)

                ProgressView(value: min(piggyBank.percentage, 1.0))
                    .progressViewStyle(.linear)
                    .tint(piggyBank.isCompleted ? .green : .accentColor)

                Text(statusText)
                    .font(.caption)
                    .foregroundStyle(piggyBank.isCompleted ? .green : .secondary)
                    .lineLimit(1)
            }

            Spacer(minLength: 0)
        }
        .padding(12)
        .background(
            RoundedRectangle(cornerRadius: 16, style: .continuous)
                .fill(Color("cell-background"))
                .shadow(color: .black.opacity(0.06), radius: 6, x: 0, y: 2)
        )
    }

    private var statusText: String {
        piggyBank.isCompleted
            ? L10n.List.completed
            : L10n.List.remaining(remaining.currencyFormatted)
    }

    @ViewBuilder
    private var avatar: some View {
        if let imageData = piggyBank.imageData, let uiImage = UIImage(data: imageData) {
            Image(uiImage: uiImage)
                .resizable()
                .scaledToFill()
                .frame(width: 52, height: 52)
                .clipShape(Circle())
        } else {
            ZStack {
                Circle()
                    .fill(Color.accentColor.opacity(0.15))
                Image(systemName: "banknote.fill")
                    .font(.system(size: 20))
                    .foregroundStyle(Color.accentColor)
            }
            .frame(width: 52, height: 52)
        }
    }
}

#Preview {
    let bank = PiggyBank(goalName: "New MacBook", savingGoal: 1500)
    bank.coins = [CoinEntry(amount: 620, date: .now)]

    return VStack(spacing: 12) {
        PiggyBankRowView(piggyBank: bank)
    }
    .padding()
}
