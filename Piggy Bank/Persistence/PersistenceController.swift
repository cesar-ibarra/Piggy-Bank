//
//  PersistenceController.swift
//  Piggy Bank
//
//  Created by Cesar Ibarra on 9/11/26.
//
//  Builds the SwiftData ModelContainer backed by CloudKit private database,
//  matching the "iCloud.Cloud.net.cesaribarra.my-Piggy-Bank" container
//  declared in Piggy Bank.entitlements.
//

import SwiftData
import CoreData
import Foundation

enum PersistenceController {

    static let shared: ModelContainer = {
        let schema = Schema([PiggyBank.self])

        let cloudConfiguration = ModelConfiguration(
            schema: schema,
            isStoredInMemoryOnly: false,
            cloudKitDatabase: .automatic
        )

        do {
            let container = try ModelContainer(for: schema, configurations: [cloudConfiguration])
            observeCloudKitSyncEvents()
            return container
        } catch {
            print("⚠️ CloudKit container failed to initialize (\(error)). Falling back to local-only storage.")

            let localConfiguration = ModelConfiguration(
                schema: schema,
                isStoredInMemoryOnly: false,
                cloudKitDatabase: .none
            )

            guard let fallback = try? ModelContainer(for: schema, configurations: [localConfiguration]) else {
                fatalError("Could not create ModelContainer, even in local-only mode: \(error)")
            }
            return fallback
        }
    }()

    static var preview: ModelContainer = {
        let schema = Schema([PiggyBank.self])
        let configuration = ModelConfiguration(schema: schema, isStoredInMemoryOnly: true)
        return try! ModelContainer(for: schema, configurations: [configuration])
    }()

    /// Logs every CloudKit import/export event so sync failures show up
    /// in the console instead of failing silently.
    private static func observeCloudKitSyncEvents() {
        NotificationCenter.default.addObserver(
            forName: NSPersistentCloudKitContainer.eventChangedNotification,
            object: nil,
            queue: .main
        ) { notification in
            guard let event = notification.userInfo?[NSPersistentCloudKitContainer.eventNotificationUserInfoKey]
                    as? NSPersistentCloudKitContainer.Event else { return }

            let type: String
            switch event.type {
            case .setup: type = "setup"
            case .import: type = "import"
            case .export: type = "export"
            @unknown default: type = "unknown"
            }

            if let error = event.error {
                print("❌ CloudKit \(type) failed: \(error.localizedDescription)")
            } else if event.endDate != nil {
                print("✅ CloudKit \(type) finished successfully")
            } else {
                print("⏳ CloudKit \(type) started...")
            }
        }
    }
}
