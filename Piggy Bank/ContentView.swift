//
//  ContentView.swift
//  Piggy Bank
//
//  Created by Cesar Ibarra on 1/26/25.
//

import SwiftUI
import SwiftData

struct ContentView: View {
    @Environment(\.modelContext) private var modelContext
    @Query private var piggyBanks: [PiggyBank]
    @State private var piggyBank: String = ""
    
    var body: some View {
        NavigationStack {
            List {
                ForEach(piggyBanks) { piggybank in
                    VStack {
                        Text(piggybank.goalName)
                            .font(.title.weight(.light))
                            .padding(.vertical, 2)
                            .foregroundStyle(piggybank.isCompleted == false ? Color.primary : Color.accentColor)
                            .strikethrough(piggybank.isCompleted)
                            .italic(piggybank.isCompleted)
                            .swipeActions {
                                Button(role: .destructive) {
                                    withAnimation {
                                        modelContext.delete(piggybank)
                                    }
                                } label: {
                                    Label("Delete", systemImage: "trash")
                                }
                            }
                    }
                }
            }
            .navigationTitle("Piggy Bank")
            .overlay {
                if piggyBanks.isEmpty {
                    ContentUnavailableView("Goals", systemImage: "banknote", description: Text("No goal yet. Add one to get started!"))
                }
            }
            // MARK: - BANNER
            AdMobBanner()
                .frame(width: 320, height: 50)
        }
    }
}

#Preview("List with sample data") {
    let sampleData: [PiggyBank] = [
        PiggyBank(goalName: "Airpods", savingGoal: 210, isCompleted: false),
        PiggyBank(goalName: "iPad", savingGoal: 899, isCompleted: false),
        PiggyBank(goalName: "Mac Mini", savingGoal: 499, isCompleted: false),
        PiggyBank(goalName: "Airpods Max", savingGoal: 599, isCompleted: false),
        PiggyBank(goalName: "iPad Keyboard", savingGoal: 299, isCompleted: false),
        PiggyBank(goalName: "Apple Watch", savingGoal: 799, isCompleted: false)
    ]
    
    let container = try! ModelContainer(for: PiggyBank.self, configurations: ModelConfiguration(isStoredInMemoryOnly: true))
    
    for item in sampleData {
        container.mainContext.insert(item)
    }
    
    return ContentView()
        .modelContainer(container)
}


#Preview("Empty List") {
    ContentView()
        .modelContainer(for: PiggyBank.self, inMemory: true)
}
