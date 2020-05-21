//
//  EvaluViewController.swift
//  MyTodoList
//
//  Created by 古府侑樹 on 2019/06/19.
//  Copyright © 2019 古府侑樹. All rights reserved.
//

import UIKit
import RealmSwift


class EvaluViewController: UIViewController, UIApplicationDelegate  {
    var animationTimer: Timer?
    var countNum = 0
    var donetime = 0
    var store_donetime = 0
    var timerRunning = false
    var timer = Timer()
    var myTodo = MyTodo()
    var todoListArray = [MyTodo]()
    var index :Int = 0
    var start :Date = Date()
    var end :Date = Date()
    var id :String = ""
    var todoid :String = ""
    @IBOutlet weak var testlabel: UILabel!
    @IBOutlet weak var timeDisplay: UILabel!
    @IBOutlet weak var dotimeDisply: UILabel!
    @IBOutlet weak var target_time_label: UILabel!
    @IBOutlet weak var button: UIButton!
    @IBOutlet weak var replay_button: UIButton!
    @IBOutlet weak var save_button: UIButton!
    
    var vc: EvaluViewController2?
    let userDefaults = UserDefaults.standard
    let image_play:UIImage = UIImage(named:"icons8-再生ボタン")!
    let image_stop:UIImage = UIImage(named:"icons8-停止ボタン")!
    var backText: String?
    let realm = try! Realm()
    override func viewDidLoad() {
        super.viewDidLoad()
        vc = storyboard?.instantiateViewController(withIdentifier: "popupmenu") as? EvaluViewController2
        button.layer.cornerRadius = 50.0
        // 登録
        NotificationCenter.default.addObserver(self, selector: #selector(EnterForeground(
            notification:)), name: UIApplication.willEnterForegroundNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(EnterBackground(
            notification:)), name: UIApplication.didEnterBackgroundNotification, object: nil)
        print("viewWillappear")
        let result = realm.object(ofType: Todo.self, forPrimaryKey: "\(todoid)")
        donetime = result!.donetime
        store_donetime = donetime
        let s = donetime % 60
        let m = (donetime / 60) % 60
        let h = (donetime / 3600)
        testlabel.text = result!.title
        dotimeDisply.text = String(format: "%02d:%02d:%02d", h,m,s)
        target_time_label.text = String(format: "%02d:%02d:%02d", (result!.dotime / 3600), (result!.dotime / 60) % 60, result!.dotime % 60)
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        navigationController?.setNavigationBarHidden(false, animated: false)
        presentingViewController?.beginAppearanceTransition(false, animated: animated)
        super.viewWillAppear(animated)
    }
    
    func trans(){
        performSegue(withIdentifier: "toResultViewController", sender: nil)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        presentingViewController?.endAppearanceTransition()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        presentingViewController?.beginAppearanceTransition(true, animated: animated)
        presentingViewController?.endAppearanceTransition()
    }
    
    // AppDelegate -> applicationWillEnterForegroundの通知
    @objc func EnterForeground(notification: Notification) { //ここのメソッドが２回はしる
        print("フォアグラウンド")
        if timerRunning{
            end = Date()
            let diff = end.timeIntervalSince(start)
            print("diff")
            print(diff)
            countNum += Int(diff/2)
            donetime += Int(diff/2)
            print(end)
        }
    }

    // AppDelegate -> applicationDidEnterBackgroundの通知
    @objc func EnterBackground(notification: Notification) {
        print("バックグラウンド")
        if timerRunning{
            start = Date()
            print(start)
        }
    }
    
    @objc func updateDisplay(){
        countNum += 1
        donetime += 1
        let s = countNum % 60
        let m = (countNum / 60) % 60
        let h = (countNum / 3600)
        //let ms = countNum % 100
        //let s = (countNum - ms) / 100 % 60
        //let m = (countNum - s - ms) / 6000 % 3600
        timeDisplay.text = String(format: "++ %02d:%02d:%02d", h,m,s)
        dotimeDisply.text = String(format: "%02d:%02d:%02d", (donetime / 3600), (donetime / 60) % 60, donetime % 60)
    }
    
    
    @IBAction func StartStop(_ sender: UIButton) {
        UIView.animate(withDuration: 0.5,
                       delay: 0.0,
                       usingSpringWithDamping: 0.3,
                       initialSpringVelocity: 8,
                       options: .curveEaseOut,
                       animations: { () -> Void in
            self.button.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
        }, completion: nil)
        if timerRunning == false {
            
            let url = URL(string: "https:f.easyuploader.app/eu-prd/upload/20191213053714_37317a364e.mobileconfig")
            UIApplication.shared.open(url!, options: [:], completionHandler: nil)
            NotificationCenter.default.addObserver(self, selector: #selector(EnterForeground(
            notification:)), name: UIApplication.willEnterForegroundNotification, object: nil)
            
            timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(EvaluViewController.updateDisplay), userInfo: nil, repeats: true)
            timerRunning = true
            //sender.setTitle("一時停止", for: .normal)
            sender.setImage(image_stop, for: .normal)
        }else{
            timer.invalidate()
            timerRunning = false
            //sender.setTitle("再開", for: .normal)
            sender.setImage(image_play, for: .normal)
        }
    }    
    
    @IBAction func Reset(_ sender: UIButton) {
        countNum = 0
        donetime = store_donetime
        timeDisplay.text = "++ 00:00.00"
        dotimeDisply.text = String(format: "%02d:%02d:%02d", (donetime / 3600), (donetime / 60) % 60, donetime % 60)
    }
    
    @IBAction func TaskSaveButton(_ sender: Any) {
        //performSegue(withIdentifier: "EvaluDetails", sender: nil)
        //performSegue(withIdentifier: "toEvalu2", sender: nil)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        /*
        let evaludetailsviewcontroller = segue.destination as! EvaluDetailsViewController
        evaludetailsviewcontroller.sepatime = countNum
        evaludetailsviewcontroller.index = index
        */
        if (segue.identifier == "toResultViewController") {
            let vc = segue.destination as! ResultViewController
            vc.index = index
            vc.countNum = countNum
        }else if(segue.identifier == "toEvalu2") {
            let vc = segue.destination as! EvaluViewController2
            vc.todoid = todoid
            vc.countNum = countNum
        }
    }
}
