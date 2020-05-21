//
//  AppDelegate.swift
//  MyTodoList
//
//  Created by 古府侑樹 on 2019/06/07.
//  Copyright © 2019 古府侑樹. All rights reserved.
//

import UIKit
import RealmSwift

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate, UNUserNotificationCenterDelegate {

    var window: UIWindow?
    
    var delegateResults: Results<Calendar24>?
    
    //var backgroundTaskID : UIBackgroundTaskIdentifier = UIBackgroundTaskIdentifier(rawValue: 0)

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        requestAuthorization()
//        let f = DateFormatter()
//        f.timeStyle = .none
//        f.dateStyle = .full
//        f.locale = Locale(identifier: "ja_JP")
//        let realm = try! Realm()
//        try! realm.write {
//            print("addされました。")
//            let todo = Todo()
//            let todo2 = Todo()
//            let todo3 = Todo()
//            todo.title = "課題"
//            todo2.title = "勉強"
//            todo3.title = "筋トレ"
//            todo.date = Date()
//            todo2.date = Date()
//            todo.datestring = f.string(from: Date())
//            todo2.datestring = f.string(from: Date())
//            todo.dotime = 3600
//            todo2.dotime = 3600
//            todo3.dotime = 3600
//            realm.add(todo)
//            realm.add(todo2)
//            realm.add(todo3)
//        }
        
        // Override point for customization after application launch.
        //　ナビゲーションバーの背景色
        UINavigationBar.appearance().barTintColor = UIColor(red: 246/255, green: 194/255, blue: 214/255, alpha: 255/255)
        // ナビゲーションバーのアイテムの色　（戻る　＜　とか　読み込みゲージとか）
        UINavigationBar.appearance().tintColor = UIColor.black
        // ナビゲーションバーのテキストを変更する
        UINavigationBar.appearance().titleTextAttributes = [
        // 文字の色
            .foregroundColor: UIColor.black
        ]
        return true
    }

    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
        /*
        self.backgroundTaskID = application.beginBackgroundTask(){
            [weak self] in
            application.endBackgroundTask((self?.backgroundTaskID)!)
            self?.backgroundTaskID = UIBackgroundTaskIdentifier.invalid
        }
        */
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
       var trigger: UNNotificationTrigger
        let content = UNMutableNotificationContent()
        var notificationTime = DateComponents()
        if(delegateResults != nil){
            for item in delegateResults!{
                let components = Calendar.current.dateComponents(in: TimeZone.current, from: item.start)
                notificationTime.hour = components.hour
                notificationTime.minute = components.minute! - 10
                trigger = UNCalendarNotificationTrigger(dateMatching: notificationTime, repeats: false)
                content.title = item.todo.first!.title
                content.body = "もうすぐタスクの時間だよ！"
                content.sound = UNNotificationSound.default
                var request = UNNotificationRequest(identifier: item.calendarid, content: content, trigger: trigger)
                UNUserNotificationCenter.current().add(request, withCompletionHandler: nil)
            }
        }
        //NotificationCenter.default.post(name: UIApplication.didEnterBackgroundNotification, object: nil)
        print("applicationDidEnterBackground")
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
        NotificationCenter.default.post(name: UIApplication.willEnterForegroundNotification, object: nil)
        print("applicationWillEnterForeground")
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
        
        //application.endBackgroundTask(self.backgroundTaskID)
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }
    
    private func requestAuthorization() {

        let center = UNUserNotificationCenter.current()
        center.requestAuthorization(options: [.badge, .sound, .alert]) { [weak self] (granted, error) in

            if error != nil {
                print(error!)
                return
            }

            if granted {
                center.delegate = self
            } else {

                DispatchQueue.main.async {
                    guard let vc = self?.window?.rootViewController else {
                        return
                    }
                    //vc.showAlert(title: "未許可", message: "許可がないため通知ができません")
                }
            }
        }
    }
}

