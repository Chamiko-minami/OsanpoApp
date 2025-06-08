//
//  OsanpoApp.swift
//  Osanpo
//
//  Created by 酒井みな実 on 2025/05/27.
//

import SwiftUI
import SwiftData

@main
struct OsanpoApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
                .onAppear {
                    NotificationManager.shared.requestAuthorization()
                    NotificationManager.shared.scheduleMonthlyReminderNotification()
                    
                    // テスト通知：5秒後に通知
                    NotificationManager.shared.scheduleTestNotification(secondsLater: 5)
                }
        }
        .modelContainer(for: [Place.self]) // ← これは絶対残す！（OK）
    }
}
