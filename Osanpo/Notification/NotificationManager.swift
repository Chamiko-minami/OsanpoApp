//
//  NotificationManager.swift
//  Osanpo
//
//  Created by ChatGPT on 2025/06/07.
//

import Foundation
import UserNotifications

class NotificationManager {
    static let shared = NotificationManager()

    private init() {}

    // 通知の許可をリクエスト
    func requestAuthorization() {
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .badge, .sound]) { granted, error in
            if let error = error {
                print("通知許可エラー: \(error.localizedDescription)")
            } else {
                print("通知許可: \(granted)")
            }
        }
    }

    // 毎月1日 朝9時に通知する
    func scheduleMonthlyReminderNotification() {
        var dateComponents = DateComponents()
        dateComponents.day = 1
        dateComponents.hour = 9
        dateComponents.minute = 0

        let content = UNMutableNotificationContent()
        content.title = "✨今月の行きたいところ✨"
        content.body = "今月の行きたいところを見てみよう👀💖"
        content.sound = .default

        let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: true)

        let request = UNNotificationRequest(identifier: "monthly_reminder", content: content, trigger: trigger)

        UNUserNotificationCenter.current().add(request) { error in
            if let error = error {
                print("毎月通知登録エラー: \(error.localizedDescription)")
            } else {
                print("毎月通知登録完了")
            }
        }
    }

    // テスト用：数秒後に通知を飛ばす（開発確認用）
    func scheduleTestNotification(secondsLater seconds: TimeInterval = 5) {
        let content = UNMutableNotificationContent()
        content.title = "🌟テスト通知🌟"
        content.body = "これはテスト通知です📱"
        content.sound = .default

        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: seconds, repeats: false)

        let request = UNNotificationRequest(identifier: UUID().uuidString, content: content, trigger: trigger)

        UNUserNotificationCenter.current().add(request) { error in
            if let error = error {
                print("テスト通知エラー: \(error.localizedDescription)")
            } else {
                print("テスト通知登録完了 (あと \(seconds) 秒後)")
            }
        }
    }
}
