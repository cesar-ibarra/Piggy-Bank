//
//  PiggyBankDetailView.swift
//  Piggy Bank
//
//  Created by Cesar Ibarra on 2/18/25.
//

import SwiftUI
import StoreKit

struct PiggyBankDetailView: View {
    @Bindable var piggyBank: PiggyBank

    // Add savings sheet
    @State private var showAddSheet = false
    @State var newCoin: String = ""

    // Edit entry sheet
    @State var editingCoin: CoinEntry?
    @State var editedAmount: String = ""
    @State var editedDate: Date = Date()
    @State var showEditSheet = false

    // Edit goal sheet
    @State private var showEditGoalSheet = false
    @State private var editedGoalName: String = ""
    @State private var editedGoalAmount: String = ""

    @State var showGoalCompleteAlert = false

    @State private var showImagePicker = false
    @State private var selectedImage: UIImage? = nil

    private let quickAmounts: [Double] = [5, 10, 20, 50]

    var sortedCoins: [CoinEntry] {
        piggyBank.coins.sorted(by: { $0.date > $1.date })
    }

    @StateObject var storeKit = StoreKitManager()

    var body: some View {
        ScrollView {
            VStack(spacing: 20) {
                header
                Divider()
                historySection
            }
            .padding()
        }
        .background(Color(.systemGroupedBackground))
        .navigationTitle(L10n.Nav.details)
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                Button {
                    showAddSheet = true
                } label: {
                    Image(systemName: "plus.circle.fill")
                        .font(.title2)
                }
                .disabled(piggyBank.isCompleted)
            }
        }
        .sheet(isPresented: $showAddSheet) {
            addSavingsSheet
        }
        .sheet(isPresented: $showEditGoalSheet) {
            editGoalSheet
        }
        .sheet(isPresented: $showEditSheet) {
            editEntrySheet
        }
        .sheet(isPresented: $showImagePicker) {
            ImagePicker(selectedImage: $selectedImage)
        }
        .onChange(of: selectedImage) { _, newValue in
            if let image = newValue {
                piggyBank.imageData = image.jpegData(compressionQuality: 0.8)
            }
        }
        .alert(L10n.GoalComplete.title, isPresented: $showGoalCompleteAlert) {
            Button(L10n.GoalComplete.button, role: .cancel) {}
        } message: {
            Text(L10n.GoalComplete.message)
        }
        // MARK: - BANNER
        ForEach(storeKit.storeProducts) { product in
            ValidatePurchasedForAds(storeKit: storeKit, product: product)
        }
    }

    // MARK: - Header

    private var header: some View {
        VStack(spacing: 16) {
            ZStack(alignment: .bottomTrailing) {
                avatar
                Button {
                    showImagePicker = true
                } label: {
                    Image(systemName: "pencil.circle.fill")
                        .font(.title3)
                        .foregroundStyle(.white, Color.accentColor)
                        .background(Circle().fill(.white))
                }
                .offset(x: 4, y: 4)
            }

            Button {
                editedGoalName = piggyBank.goalName
                editedGoalAmount = String(format: "%.2f", piggyBank.savingGoal)
                showEditGoalSheet = true
            } label: {
                HStack(spacing: 6) {
                    Text(piggyBank.goalName)
                        .font(.title2.bold())
                        .foregroundStyle(piggyBank.isCompleted ? .green : .primary)
                    Image(systemName: "pencil")
                        .font(.caption)
                        .foregroundStyle(.secondary)
                }
            }
            .buttonStyle(.plain)

            VStack(spacing: 8) {
                ProgressView(value: min(piggyBank.percentage, 1.0))
                    .progressViewStyle(.linear)
                    .tint(piggyBank.isCompleted ? .green : .accentColor)
                    .scaleEffect(x: 1, y: 1.6, anchor: .center)

                Text(L10n.Detail.currentSavings(piggyBank.total.currencyFormatted, piggyBank.savingGoal.currencyFormatted))
                    .font(.subheadline.bold())

                if !piggyBank.isCompleted {
                    let remaining = max(piggyBank.savingGoal - piggyBank.total, 0)
                    Text(L10n.List.remaining(remaining.currencyFormatted))
                        .font(.caption)
                        .foregroundStyle(.secondary)
                } else {
                    Text(L10n.List.completed)
                        .font(.caption.bold())
                        .foregroundStyle(.green)
                }
            }
            .padding(.horizontal)
        }
    }

    @ViewBuilder
    private var avatar: some View {
        if let imageData = piggyBank.imageData, let uiImage = UIImage(data: imageData) {
            Image(uiImage: uiImage)
                .resizable()
                .scaledToFill()
                .frame(width: 96, height: 96)
                .clipShape(Circle())
        } else {
            ZStack {
                Circle().fill(Color.accentColor.opacity(0.15))
                Image(systemName: "photo")
                    .font(.system(size: 32))
                    .foregroundStyle(Color.accentColor)
            }
            .frame(width: 96, height: 96)
        }
    }

    // MARK: - History

    private var historySection: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text(L10n.Detail.savingsHistory)
                .font(.headline)

            if sortedCoins.isEmpty {
                Text(L10n.Detail.noEntries)
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
                    .frame(maxWidth: .infinity, alignment: .center)
                    .padding(.vertical, 24)
            } else {
                VStack(spacing: 8) {
                    ForEach(sortedCoins, id: \.date) { coin in
                        coinRow(coin)
                    }
                }
            }
        }
    }

    private func coinRow(_ coin: CoinEntry) -> some View {
        HStack {
            ZStack {
                Circle().fill(Color.accentColor.opacity(0.12))
                Image(systemName: "dollarsign")
                    .font(.subheadline.bold())
                    .foregroundStyle(Color.accentColor)
            }
            .frame(width: 36, height: 36)

            VStack(alignment: .leading, spacing: 2) {
                Text(coin.amount.currencyFormatted)
                    .font(.body.weight(.semibold))
                Text(coin.date.formatted(date: .abbreviated, time: .omitted))
                    .font(.caption)
                    .foregroundStyle(.secondary)
            }

            Spacer()
        }
        .padding(10)
        .background(
            RoundedRectangle(cornerRadius: 14, style: .continuous)
                .fill(Color("cell-background"))
        )
        .contentShape(Rectangle())
        .onTapGesture {
            guard !piggyBank.isCompleted else { return }
            startEditing(coin)
        }
        .contextMenu {
            if !piggyBank.isCompleted {
                Button {
                    startEditing(coin)
                } label: {
                    Label(L10n.Common.edit, systemImage: "pencil")
                }
                Button(role: .destructive) {
                    withAnimation {
                        deleteCoin(coin)
                    }
                } label: {
                    Label(L10n.Common.delete, systemImage: "trash")
                }
            }
        }
    }

    // MARK: - Sheets

    private var addSavingsSheet: some View {
        NavigationStack {
            Form {
                Section {
                    HStack {
                        Image(systemName: "dollarsign.circle.fill")
                            .foregroundStyle(Color.accentColor)
                        TextField(L10n.Detail.amount, text: $newCoin)
                            .keyboardType(.decimalPad)
                    }
                }

                Section {
                    HStack {
                        ForEach(quickAmounts, id: \.self) { amount in
                            Button {
                                newCoin = String(format: "%.0f", amount)
                            } label: {
                                Text(amount.currencyFormatted)
                                    .font(.footnote.weight(.semibold))
                                    .padding(.vertical, 8)
                                    .frame(maxWidth: .infinity)
                                    .background(Color.accentColor.opacity(0.12))
                                    .clipShape(Capsule())
                            }
                            .buttonStyle(.plain)
                        }
                    }
                    .listRowInsets(EdgeInsets())
                    .padding(.horizontal)
                    .padding(.vertical, 4)
                }
            }
            .navigationTitle(L10n.Detail.addSavings)
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button(L10n.Form.cancel) {
                        newCoin = ""
                        showAddSheet = false
                    }
                }
                ToolbarItem(placement: .confirmationAction) {
                    Button(L10n.Form.save) {
                        addCoin()
                        showAddSheet = false
                    }
                    .disabled(Double(newCoin) == nil)
                }
            }
        }
        .presentationDetents([.medium])
        .presentationCornerRadius(20)
    }

    private var editGoalSheet: some View {
        NavigationStack {
            Form {
                Section(L10n.Form.sectionGoal) {
                    TextField(L10n.Form.goalName, text: $editedGoalName)
                    TextField(L10n.Form.goalAmount, text: $editedGoalAmount)
                        .keyboardType(.decimalPad)
                }
            }
            .navigationTitle(L10n.Detail.editGoal)
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button(L10n.Form.cancel) { showEditGoalSheet = false }
                }
                ToolbarItem(placement: .confirmationAction) {
                    Button(L10n.Form.save) {
                        saveEditedGoal(name: editedGoalName, amount: editedGoalAmount)
                        showEditGoalSheet = false
                    }
                    .disabled(editedGoalName.isEmpty || Double(editedGoalAmount) == nil)
                }
            }
        }
        .presentationDetents([.medium])
        .presentationCornerRadius(20)
    }

    private var editEntrySheet: some View {
        NavigationStack {
            Form {
                Section {
                    HStack {
                        Image(systemName: "dollarsign.circle")
                            .foregroundColor(.accentColor)
                        TextField(L10n.Detail.amount, text: $editedAmount)
                            .keyboardType(.decimalPad)
                    }
                }

                Section {
                    HStack {
                        Image(systemName: "calendar")
                            .foregroundColor(.accentColor)
                        DatePicker(L10n.Detail.date, selection: $editedDate, displayedComponents: .date)
                            .labelsHidden()
                    }
                }

                Section {
                    Button(role: .destructive) {
                        if let coin = editingCoin {
                            withAnimation {
                                deleteCoin(coin)
                            }
                        }
                        showEditSheet = false
                    } label: {
                        Label(L10n.Common.delete, systemImage: "trash")
                    }
                }
            }
            .navigationTitle(L10n.Detail.editEntry)
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button(L10n.Form.cancel) {
                        showEditSheet = false
                    }
                }
                ToolbarItem(placement: .confirmationAction) {
                    Button(L10n.Form.save) {
                        saveEditedCoin()
                        showEditSheet = false
                    }
                    .disabled(editedAmount.isEmpty)
                }
            }
        }
        .presentationDetents([.medium, .large])
        .presentationCornerRadius(20)
    }
}

#Preview {
    let bank = PiggyBank(goalName: "New MacBook", savingGoal: 1500)
    bank.coins = [
        CoinEntry(amount: 620, date: .now),
        CoinEntry(amount: 100, date: .now.addingTimeInterval(-86400))
    ]

    return NavigationStack {
        PiggyBankDetailView(piggyBank: bank)
    }
    .modelContainer(PersistenceController.preview)
}
