//
//  AddPiggyBankView.swift
//  Piggy Bank
//
//  Created by Cesar Ibarra on 2/18/25.
//

import SwiftUI

struct AddPiggyBankView: View {
    @Environment(\.dismiss) private var dismiss
    @Environment(\.modelContext) private var modelContext

    @State private var goalName = ""
    @State private var savingGoal = ""
    @State private var selectedImage: UIImage?
    @State private var showingImagePicker = false

    var body: some View {
        NavigationStack {
            Form {
                Section {
                    imagePickerButton
                        .frame(maxWidth: .infinity)
                        .listRowBackground(Color.clear)
                } header: {
                    Text(L10n.Form.sectionImage)
                }

                Section(L10n.Form.sectionGoal) {
                    TextField(L10n.Form.goalName, text: $goalName)
                    HStack {
                        Text(Locale.current.currencySymbol ?? "$")
                            .foregroundStyle(.secondary)
                        TextField(L10n.Form.goalAmount, text: $savingGoal)
                            .keyboardType(.decimalPad)
                    }
                }
            }
            .navigationTitle(L10n.Nav.newPiggyBank)
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button(L10n.Form.cancel) {
                        dismiss()
                    }
                }
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(L10n.Form.save) {
                        savePiggyBank()
                    }
                    .fontWeight(.semibold)
                    .disabled(goalName.isEmpty || Double(savingGoal) == nil)
                }
            }
            .sheet(isPresented: $showingImagePicker) {
                ImagePicker(selectedImage: $selectedImage)
            }
        }
    }

    private var imagePickerButton: some View {
        Button {
            showingImagePicker = true
        } label: {
            ZStack(alignment: .bottomTrailing) {
                if let selectedImage {
                    Image(uiImage: selectedImage)
                        .resizable()
                        .scaledToFill()
                        .frame(width: 110, height: 110)
                        .clipShape(Circle())
                } else {
                    ZStack {
                        Circle().fill(Color.accentColor.opacity(0.15))
                        Image(systemName: "camera.fill")
                            .font(.system(size: 30))
                            .foregroundStyle(Color.accentColor)
                    }
                    .frame(width: 110, height: 110)
                }

                Image(systemName: "pencil.circle.fill")
                    .font(.title3)
                    .foregroundStyle(.white, Color.accentColor)
                    .background(Circle().fill(.white))
            }
        }
        .buttonStyle(.plain)
    }

    private func savePiggyBank() {
        guard let savingGoalValue = Double(savingGoal) else { return }

        let imageData = selectedImage?.jpegData(compressionQuality: 0.8)
        let newPiggyBank = PiggyBank(goalName: goalName, savingGoal: savingGoalValue, isCompleted: false, imageData: imageData)

        modelContext.insert(newPiggyBank)
        dismiss()
    }
}

#Preview {
    AddPiggyBankView()
        .modelContainer(PersistenceController.preview)
}
