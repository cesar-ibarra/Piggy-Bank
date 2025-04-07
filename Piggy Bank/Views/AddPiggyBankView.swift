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
                Section(header: Text("Savings Goal")) {
                    TextField("Name", text: $goalName)
                    TextField("Goal Amount ($)", text: $savingGoal)
                        .keyboardType(.decimalPad)
                }
                
                Section(header: Text("Image")) {
                    if let selectedImage = selectedImage {
                        Image(uiImage: selectedImage)
                            .resizable()
                            .scaledToFit()
                            .frame(height: 150)
                            .clipShape(RoundedRectangle(cornerRadius: 10))
                    } else {
                        Button("Select Image") {
                            showingImagePicker = true
                        }
                    }
                }
            }
            .navigationTitle("New Piggy Bank")
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Cancel") {
                        dismiss()
                    }
                }
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Save") {
                        savePiggyBank()
                    }
                    .disabled(goalName.isEmpty || savingGoal.isEmpty)
                }
            }
            .sheet(isPresented: $showingImagePicker) {
                ImagePicker(selectedImage: $selectedImage)
            }
        }
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
}
