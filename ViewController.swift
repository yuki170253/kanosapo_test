//
//  ViewController.swift
//  test2
//
//  Created by 三浦翔 on 2019/09/28.
//  Copyright © 2019 Swift-Biginners. All rights reserved.
//  
import UIKit
import Foundation

import EventKit
import RealmSwift

class ViewController: UIViewController, UIScrollViewDelegate {
    var todoListArray = [MyTodo]()
    
    @IBOutlet weak var dummyAll: NSLayoutConstraint!
    @IBOutlet weak var dummyManu: NSLayoutConstraint!
    @IBOutlet weak var dummyTarget: NSLayoutConstraint!
    
    
    @IBOutlet weak var day: UINavigationItem!
    @IBOutlet weak var AnimationView: UIView!
    @IBOutlet weak var MyScrollView: UIScrollView!
    @IBOutlet weak var ContentView: UIView!
    
    @IBOutlet weak var StampView: UIView!
    @IBOutlet weak var ManuView: UIView!
    @IBOutlet weak var TargetView: UIView!
    
    @IBOutlet weak var AlldayView: UIView!
    
    var startTransform:CGAffineTransform!
    var large = false
    
    override func viewWillAppear(_ animated: Bool) {
        navigationController?.setNavigationBarHidden(false, animated: false)
        super.viewWillAppear(animated)
    }
    
    @IBOutlet weak var apperAlldayButton: UIButton!
    
    @IBAction func EnlargeScreen(_ sender: UITapGestureRecognizer) {
        if (sender.state == UIGestureRecognizer.State.ended) {
            
            var currentTransform = ContentView.transform
            var doubleTapStartCenter = ContentView.center
            
            var transform: CGAffineTransform! = nil
            var scale: CGFloat = 1.5 // ダブルタップでは現在のスケールの2倍にする
            
            
            // 現在の拡大率を取得する
            let currentScale = sqrt(abs(ContentView.transform.a * ContentView.transform.d - ContentView.transform.b * ContentView.transform.c))
            let tapPoint = sender.location(in: self.view)
            
            var newCenter: CGPoint = CGPoint(
                x: self.view.frame.size.width / 2,
                y: doubleTapStartCenter.y - ((tapPoint.y - doubleTapStartCenter.y) * scale - (tapPoint.y - doubleTapStartCenter.y)))
            
            // 拡大済みのサイズがmaxScaleを超えていた場合は、初期サイズに戻す
            //if (MyScrollView.zoomScale > MyScrollView.maximumZoomScale) {
            if(large == true){
                scale = 1
                
                transform = .identity
                newCenter.y = self.view.frame.size.height / 2 + MyScrollView.contentOffset.y
                doubleTapStartCenter.y = newCenter.y
                
                large = false
            } else {
                transform = currentTransform.concatenating(CGAffineTransform(scaleX: 1, y: scale))
                
                newCenter.y = doubleTapStartCenter.y - ((tapPoint.y - doubleTapStartCenter.y) * scale - (tapPoint.y - doubleTapStartCenter.y)) - MyScrollView.contentOffset.y/2
                
                large = true
            }
            
            // ズーム（イン/アウト）と中心点の移動
            UIView.animate(withDuration: 0.3, delay: 0.0, options: UIView.AnimationOptions.curveEaseOut, animations: {() -> Void in
                if(self.large == false){
                    //self.MyScrollView.contentSize.height = 1720
                    //                    self.ContentView.frame.size.height /= scale
                    self.ContentView.center.y = CGFloat(840)
                    
                }else {
                    self.ContentView.center = newCenter
                    //self.MyScrollView.contentSize.height = self.MyScrollView.contentSize.height * scale
                    //                    self.ContentView.frame.size.height *= scale
                    
                }
                self.ContentView.transform = transform
                
            }, completion: {(finished: Bool) -> Void in
            })
        }
    }
    
    func zoomRectForScale(scale:CGFloat, center: CGPoint) -> CGRect{
        let size = CGSize(
            width: MyScrollView.frame.size.width / scale,
            height: MyScrollView.frame.size.height / scale
        )
        return CGRect(
            origin: CGPoint(
                x: center.x - size.width / 2.0,
                y: center.y - size.height / 2.0
            ),
            size: size
        )
    }
    
    
    @IBAction func calshow(_ sender: Any) {
        print("calshow")
        
        for item in ContentView.subviews{
            if(type(of: item) == SampleView.self){
                print(item)
            }
        }
        userDefaultData()
        addEvent()
        let url = URL(string: "calshow:")!
        UIApplication.shared.open(url, options: [:], completionHandler: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(EnterForeground(
            notification:)), name: UIApplication.willEnterForegroundNotification, object: nil)
    }
    @objc func EnterForeground(notification: Notification) { //ここのメソッドが２回はしる
        print("フォアグラウンド")
        MyScrollView.contentOffset.y = 0
        Initialization()
    }
    
    
    @IBAction func apperManu(_ sender: Any) {
        print("apperButton")
        print(TargetView.subviews.count)
        dummyManu.constant = CGFloat(50 + (25 * (StampView.subviews.count + TargetView.subviews.count)))
        ManuView.alpha = 0.0
        StampView.alpha = 0.0
        TargetView.alpha = 0.0
        dummyTarget.constant = CGFloat(5 + ((TargetView.subviews.count) * 25))
        print("dummyTarget")
        print(dummyTarget.constant)
        
        if(StampView.subviews.count + TargetView.subviews.count > 0){
            UIView.animate(withDuration: 0.3, delay: 0.0, options: [.curveEaseIn], animations: {
                self.ManuView.alpha = 1.0
                self.TargetView.alpha = 1.0
                self.StampView.alpha = 1.0
            }, completion: nil)
        }else{
            // アラート作成
            let alert = UIAlertController(title: "タスクがありません", message: "タスクを追加してください", preferredStyle: .alert)
            // アラート表示
            self.present(alert, animated: true, completion: {
                // アラートを閉じる
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.5, execute: {
                    alert.dismiss(animated: true, completion: nil)
                })
            })
        }
    }
    
    
    @IBAction func disapperManu(_ sender: Any) {
        ManuView.alpha = 1.0
        StampView.alpha = 1.0
        TargetView.alpha = 1.0
        UIView.animate(withDuration: 0.3, delay: 0.0, options: [.curveEaseIn], animations: {
            self.ManuView.alpha = 0.0
            self.TargetView.alpha = 0.0
            self.StampView.alpha = 0.0
        }, completion: nil)
    }
    
    @IBAction func apperAllday(_ sender: Any) {
        var cnt = Int(0)
        print(dummyAll.constant)
        if(!dummyAllFlag){
            dummyAll.constant = 25 + CGFloat((AlldayView.subviews.count / 4) * 25)
            for hide in AlldayView.subviews{
                hide.alpha = 1.0
            }
            apperAlldayButton.transform = CGAffineTransform(rotationAngle: CGFloat(M_PI));
        }else{
            dummyAll.constant = 50
            for hide in AlldayView.subviews{
                if(cnt > 9){
                    hide.alpha = 0.0
                }
                cnt += 1
            }
            apperAlldayButton.transform = .identity;
        }
        dummyAllFlag = !dummyAllFlag
    }
    
    var location = CGPoint(x: 0, y: 0)
    var aTouch = UITouch()
    var sTouch = CGPoint(x: 0, y: 0)
    var AllTouch = CGPoint(x: 0, y: 0)
    var ManuTouch = CGPoint(x: 0, y: 0)
    var menuPos = CGPoint(x: 0, y: 0)
    var userY = CGFloat()
    var flag = Int()  // 0: Manu  1:Allday
    var currentPoint: CGPoint!
    var rand = Int()
    var cntAll = Int(0)
    var cntManu = Int(0)
    var TestView = UIView()
    var isRefreshing = false
    var animeFlag = Int()
    var ActivityIndicator: UIActivityIndicatorView!
    var Datas = [MyTodo]()
    var DataM = [MyTodo]()
    var sortDataM = [MyTodo]()
    var DataA = [MyTodo]()
    var DataStamp = [MyTodo]()
    
    var calendarArray = [MyTodo]()
    var calendarArray2 = [MyTodo]()
    var calendarArray_before = [MyTodo]()
    
    var NOW = NSDate()
    
    let eventStore = EKEventStore()
    let calendar = Calendar.current
    var eventArray = [EKEvent]()
    var viewtag = Int(101)
    var AllStart = Int(1001)
    var ManuStart = Int(10001)
    var StampStart = Int(100001)
    var cntS = Int()
    var cntT = Int()
    
    var autoScrollTimer = Timer()
    var dummyAllFlag = false
    
    var nowtimeMark = UIImageView(image:UIImage(named:"triangle")!)
    var nowtimeBar = CALayer()
    
    let topBorder = CALayer()
    var todo = Todo()
    var cal = Calendar24()
    let realm = try! Realm()
    
    func checkAuth(){
        let status = EKEventStore.authorizationStatus(for: EKEntityType.event)
        if status == .authorized { // もし権限がすでにあったら
            print("アクセスできます！！")
        }else if status == .notDetermined {
            // アクセス権限のアラートを送る。
            eventStore.requestAccess(to: EKEntityType.event) { (granted, error) in
                if granted { // 許可されたら
                    print("アクセス可能になりました。")
                }else { // 拒否されたら
                    print("アクセスが拒否されました。")
                }
            }
        }
    }
    
    func getCalendar(){
        print("getCalendar")
        var componentsOneDayDelay = DateComponents()
        componentsOneDayDelay.hour = 24 // 今の時刻から1年進めるので1を代入
        let startDate = Date()
        let endDate = calendar.date(byAdding: componentsOneDayDelay, to: Date())!
        let predicate = eventStore.predicateForEvents(withStart: startDate, end: endDate, calendars: nil)
        
        eventArray = eventStore.events(matching: predicate)
        print(eventArray)
    }
    
    func addEvent() {
        print("addEvent")
        // イベントの情報を準備
        var componentsOneDayDelay = DateComponents()
        componentsOneDayDelay.hour = 24 // 今の時刻から1年進めるので1を代入
        
        let defaultCalendar = eventStore.defaultCalendarForNewEvents
        
        var addEvents = [MyTodo]()
        var eventArray2 = eventArray
        let date = NSDate() as Date
        let dateFormater = DateFormatter()
        
        dateFormater.locale = Locale(identifier: "ja_JP")
        dateFormater.dateFormat = "yyyy/MM/dd"
        dateFormater.timeZone = TimeZone(identifier: "Asia/Tokyo")
        
        for item in DataA{
            item.start = dateFormater.string(from: date)+" "+"00:00"
            item.end = dateFormater.string(from: date)+" "+"23:59"
            addEvents.append(item)
        }
        
        // イベントを作成して情報をセット
        for item in addEvents{
            let end = Calendar.current.date(byAdding: .minute, value: -20, to: convert_date_details(string: item.end))!
            let event = EKEvent(eventStore: eventStore)
            event.title = item.todoTitle
            event.startDate = convert_date_details(string: item.start)
            event.endDate = convert_date_details(string: item.end)
            event.isAllDay = item.all_day
            event.calendar = defaultCalendar
            eventArray2.append(event)
        }
        for view in ContentView.subviews{
            if(type(of: view) == SampleView.self && view.tag < 999999999){
                let event = EKEvent(eventStore: eventStore)
                let startTime = getTaskTime(view: view)
                let end = Calendar.current.date(byAdding: .minute, value: Int(view.frame.height) - 20, to: startTime)!
                var title = String()
                for item in view.subviews{
                    if(type(of: item) == UILabel.self){
                        if((item as! UILabel).tag == 26){
                            title = (item as! UILabel).text!
                            print(item)
                        }
                    }
                }
                event.title = title
                print("コンテントビューのタイトル")
                print(event.title)
                event.startDate = startTime
                event.endDate = end
                event.isAllDay = false
                event.calendar = defaultCalendar
                eventArray2.append(event)
            }
        }
//        let cal = realm.objects(Calendar24.self)
//        for item in cal{
//            let event = EKEvent(eventStore: eventStore)
//            let end = Calendar.current.date(byAdding: .second, value: item.c_dotime, to: item.start)
//            event.title = item.todo.first!.title
//            event.startDate = item.start
//            event.endDate = end
//            event.isAllDay = false
//            event.calendar = defaultCalendar
//            eventArray2.append(event)
//        }
//        print(eventArray2)
        //イベントの登録
        print("----登録----")
        for item in eventArray2{
            do {
                print(item.title)
                print(item.startDate)
                print(item.endDate)
                try eventStore.save(item, span: .thisEvent, commit: true)
            } catch let error {
                print("同期失敗")
                print(error)
            }
        }
        //削除
        print("----削除----")
        for _ in 0...1{
            for item in eventArray{
                do {
                    print(item.title)
                    print(item.startDate)
                    print(item.endDate)
                    try eventStore.remove(item, span: .thisEvent)
                } catch let error {
                    print("削除失敗")
                }
            }
        }
    }
    
    override func viewDidLoad() {
        print("viewDidLoad")
        super.viewDidLoad()
        dummyManu.constant = 0
        dummyAll.constant = 50
        dummyTarget.constant = 0
        scrollViewFrame()
        checkAuth()
        NOW = NSDate()
        ContentView.clipsToBounds = true
        setLabel()
        ActivityIndicator = UIActivityIndicatorView()
        ActivityIndicator.frame = CGRect(x: (AnimationView.frame.width / 2) - 25, y: 20, width: 50, height: 50)
        ActivityIndicator.color = UIColor.darkGray
        ActivityIndicator.hidesWhenStopped = true
        self.AnimationView.addSubview(ActivityIndicator)
        Initialization()
        topBorder.frame = CGRect(x: 0, y: 0, width: 125, height: 1.0)
        topBorder.backgroundColor = UIColor.black.cgColor
        TargetView.layer.addSublayer(topBorder)
    }
    
    
    func scrollViewFrame(){
        print("scrollViewFrame")
        
        MyScrollView.delegate = self
        MyScrollView.alwaysBounceVertical = true
        _ = CGRect(x: 0, y: 115, width: view.frame.width, height:  667)
        //コンテンツのサイズを指定する
        let contentRect = ContentView.bounds
        MyScrollView.contentSize = CGSize(width: contentRect.width, height: 1720)
    }
    
    func Initialization(){
        print("Initialization")
        day.titleView = getnowTime()
        
        getCalendar()
        dataSet()
        sortData()
        craftCalendar()
        craftAllday(View: AlldayView)
        craftManu(View: ManuView)
        if(AlldayView.subviews.count - 2 <= 4){
            dummyAll.constant = 50 / 2
        }else{
            dummyAll.constant = 50
        }
        if(AlldayView.subviews.count - 2 <= 8){
            apperAlldayButton.alpha = 0.0
        }else{
            apperAlldayButton.alpha = 1.0
        }
    }
    
    func remove_calendarArray(){
            print("remove_calendarArray")
            let Now = NSDate() as Date
            var indexs = [Int]()
            var x = 0
            
            for item in calendarArray{
                if(item.end != ""){
                    print(item.todoTitle)
                    print((Calendar.current.dateComponents([.second], from: Now, to: convert_date_details(string: item.start)).second!))
                    print(item.end)
                    if((Calendar.current.dateComponents([.second], from: Now, to: convert_date_details(string: item.end)).second!) < 0){
                        print("append")
                        indexs.append(x)
                    }
                }
                x += 1
            }
            if(indexs.count != 0){
                for i in indexs.reversed(){
                    print("calendarArray.remove_index:"+String(i))
                    calendarArray.remove(at: i)
                }
            }
        }
    
    func dataSet(){
        print("dataSet")
        Datas.removeAll()
        DataM.removeAll()
        DataA.removeAll()
        DataStamp.removeAll()
        let dateFormater = DateFormatter()
        
        dateFormater.locale = Locale(identifier: "ja_JP")
        dateFormater.dateFormat = "yyyy/MM/dd"
        dateFormater.timeZone = TimeZone(identifier: "Asia/Tokyo")
        for item in eventArray{
            let Data = MyTodo()
            
            let targetTime = Calendar.current.dateComponents([.minute], from: item.startDate, to: item.endDate).minute!
            
            Data.todoTitle = item.title
            Data.todoDone = false
            Data.date = dateFormater.string(from: item.startDate)
            Data.donetime = 0
            Data.dotime = targetTime
            Data.genre = "その他"
            Data.stamp = false
            Data.all_day = item.isAllDay
            Data.task_flag = false
            if(item.isAllDay){
                Data.start = ""
                Data.end = ""
                Data.flag = false
                Data.In_flag = false
                Data.default_allday = true
            }else{
                Data.start = convert_string_details(date: item.startDate)
                Data.end = convert_string_details(date: item.endDate)
                Data.flag = true
                Data.In_flag = true
            }
            Data.repetition = false
            Data.week = nil
            Data.sepatime = []
            Data.evaluation = []
            Data.beforeTag = -1
            Data.afterTag = -1
            Data.task_flag = false
           
            if(item.isAllDay){
                print("DataAへ追加")
                print(Data.todoTitle)
                DataA.append(Data)
            }else{
                print("Datasへ追加")
                print(Data.todoTitle)
                Datas.append(Data)
            }
        }
        
        print("Datasの要素")
        for item in Datas{
            print("title:",item.todoTitle)
            print("start:",item.start)
            print("In_flag:",item.In_flag)
            print("randomID:",item.randomID)
            print("default_allday:",item.default_allday)
            print("-----------------------")
        }
    }
    
    func craftCalendar(){
        print("craftCalendar")
        for view in ContentView.subviews{
            if type(of: view) == SampleView.self {
                view.removeFromSuperview()
            }
        }
        let now = Date()
        let no1point = 30
        let no23point = 1410
        let hour = (no23point - no1point)/23
        let minute:Double
        minute = Double(hour)/Double(60)
        
        let cal = realm.objects(Calendar24.self)
        for item in cal {
            let end = Calendar.current.date(byAdding: .second, value: item.c_dotime, to: item.start)!
            let diffNow = Calendar.current.dateComponents([.minute], from: now as Date, to: item.start).minute!
            let diffMin = Calendar.current.dateComponents([.minute], from:  item.start, to: end).minute!
            userY = CGFloat(Double(no1point) + minute * Double(diffNow) + Double(Calendar.current.component(.minute, from: now)) * minute)
            for i in 0..<92 {
                if(Double(userY) > Double(no1point) + Double(hour*i/4) && Double(userY) <= Double(no1point) + Double(hour/8) + Double(hour*i/4)){
                    userY = CGFloat(Double(no1point) + Double(hour*i/4))
                }else if(Double(userY) <= Double(no1point) + Double(hour*(i+1)/4) && Double(userY) > Double(no1point) + Double(hour/8) + Double(hour*i/4)){
                    userY = CGFloat(Double(no1point) + Double(hour*(i+1)/4))
                }
            }
            let height = CGFloat(minute * Double(diffMin))
            let x:CGFloat = 60
            var y:CGFloat = userY
            if(currentPoint != nil){
                y += currentPoint.y
            }
            //UIViewController.viewの幅と高さを取得
            let width:CGFloat = 300
            
            let frame:CGRect = CGRect(x: x, y: y, width: width, height: height + 20)
            //カスタマイズViewを生成
            let titleLabel: UILabel = UILabel(frame: CGRect(x: 0,y: 0,width: 300,height: 15))
//            titleLabel.text = " " + item.todo.first!.title
            titleLabel.text = item.todo.first!.title
            print(titleLabel)
            
            let tasktime = item.c_dotime/60
            let tasktimeLabel: UILabel = UILabel(frame: CGRect(x: 100,y: 20,width: 100,height: 20))
            let timetext = String(format: "%02dh %02dm", Int(tasktime/60), Int(round(Double(tasktime) - Double(60*Int(tasktime/60)))))
            tasktimeLabel.text = timetext
            print(timetext)
            titleLabel.textColor = UIColor.white
            titleLabel.font = UIFont.boldSystemFont(ofSize: 13)
            titleLabel.layer.masksToBounds = true
            titleLabel.layer.cornerRadius = 4
//            var color = UIColor(red: CGFloat(item.color[0]), green: CGFloat(item.color[1]), blue: CGFloat(item.color[2]), alpha: CGFloat(item.color[3]))
            var color = UIColor.black
            titleLabel.backgroundColor = color
            tasktimeLabel.textColor = UIColor.white
            
            var imageView = UIImageView(image:UIImage(named:"x")!)
            
            let ReturnButton :UIButton = UIButton(frame: CGRect(x: width - 15,y: 0,width: 15,height: 15))
            ReturnButton.setImage(UIImage(named:"close_black"), for: .normal)
            //ReturnButton.backgroundColor = UIColor.red
            ReturnButton.addTarget(self, action: #selector(ReturnToMenu(_:)), for: UIControl.Event.touchUpInside)
            
            //myView.addSubview(tasktimeLabel)
            let calendarView:SampleView = SampleView(frame: frame)
            //calendarView.alpha = 0.3
//            if(item.task_flag){
//            let timetext = String(format: "%02dh %02dm", Int(item.todo.first!.dotime/3600), Int(round(Double(item.todo.first!.dotime/60) - Double(60*Int(item.todo.first!.dotime/3600)))))
//                calendarView.dotimeLabel.text = "目標時間：" + timetext
//            }
            
            calendarView.content.backgroundColor = color
            calendarView.leftBorder.backgroundColor = color
            calendarView.fakeView.backgroundColor = color
            calendarView.title.backgroundColor = color
            titleLabel.tag = 26
            calendarView.addSubview(titleLabel)
            calendarView.addSubview(ReturnButton)
            calendarView.tag = Int(item.calendarid)!
            ContentView.addSubview(calendarView)
            print(calendarView)
        }
        for item in Datas{
            if(item.start != ""){
                print("----------Datas_craft---------")
                print(item.todoTitle)
                print(item.start)
                print(item.end)
                print(item.flag)
                print(item.beforeTag)
                print(item.afterTag)
                print(item.In_flag)
                print(item.randomID)
                print(item.default_allday)
                let diffNow = Calendar.current.dateComponents([.minute], from: now as Date, to: convert_date_details(string: item.start)).minute!
                let diffMin = Calendar.current.dateComponents([.minute], from: convert_date_details(string: item.start), to: convert_date_details(string: item.end)).minute!
                userY = CGFloat(Double(no1point) + minute * Double(diffNow) + Double(Calendar.current.component(.minute, from: now)) * minute)
                for i in 0..<92 {
                    if(Double(userY) > Double(no1point) + Double(hour*i/4) && Double(userY) <= Double(no1point) + Double(hour/8) + Double(hour*i/4)){
                        userY = CGFloat(Double(no1point) + Double(hour*i/4))
                    }else if(Double(userY) <= Double(no1point) + Double(hour*(i+1)/4) && Double(userY) > Double(no1point) + Double(hour/8) + Double(hour*i/4)){
                        userY = CGFloat(Double(no1point) + Double(hour*(i+1)/4))
                    }
                }
                let height = CGFloat(minute * Double(diffMin))
                let x:CGFloat = 60
                var y:CGFloat = userY
                if(currentPoint != nil){
                    y += currentPoint.y
                }
                //UIViewController.viewの幅と高さを取得
                let width:CGFloat = 300
                
                let frame:CGRect = CGRect(x: x, y: y, width: width, height: height + 20)
                //カスタマイズViewを生成
                let titleLabel: UILabel = UILabel(frame: CGRect(x: 0,y: 0,width: 300,height: 15))
//                titleLabel.text = " " + item.todoTitle!
                titleLabel.text = item.todoTitle!
                let tasktime = item.dotime/60
                let tasktimeLabel: UILabel = UILabel(frame: CGRect(x: 100,y: 20,width: 100,height: 20))
                let timetext = String(format: "%02dh %02dm", Int(tasktime/60), Int(round(Double(tasktime) - Double(60*Int(tasktime/60)))))
                tasktimeLabel.text = timetext
                titleLabel.textColor = UIColor.white
                titleLabel.font = UIFont.boldSystemFont(ofSize: 13)
                titleLabel.layer.masksToBounds = true
                titleLabel.layer.cornerRadius = 4
                var color = UIColor(red: CGFloat(item.color[0]), green: CGFloat(item.color[1]), blue: CGFloat(item.color[2]), alpha: CGFloat(item.color[3]))
                titleLabel.backgroundColor = color
                tasktimeLabel.textColor = UIColor.white
                
                var imageView = UIImageView(image:UIImage(named:"x")!)
                
                let ReturnButton :UIButton = UIButton(frame: CGRect(x: width - 15,y: 0,width: 15,height: 15))
                ReturnButton.setImage(UIImage(named:"close_black"), for: .normal)
                //ReturnButton.backgroundColor = UIColor.red
                ReturnButton.addTarget(self, action: #selector(ReturnToMenu(_:)), for: UIControl.Event.touchUpInside)
                
                //myView.addSubview(tasktimeLabel)
                let calendarView:SampleView = SampleView(frame: frame)
                //calendarView.alpha = 0.3
                if(item.task_flag){
                    let timetext = String(format: "%02dh %02dm", Int(item.dotime/3600), Int(round(Double(item.dotime/60) - Double(60*Int(item.dotime/3600)))))
                    calendarView.dotimeLabel.text = "目標時間：" + timetext
                }
                
                calendarView.content.backgroundColor = color
                calendarView.leftBorder.backgroundColor = color
                calendarView.fakeView.backgroundColor = color
                calendarView.title.backgroundColor = color
                titleLabel.tag = 26
                calendarView.addSubview(titleLabel)
                calendarView.addSubview(ReturnButton)
                item.afterTag = viewtag
                calendarView.tag = viewtag
                viewtag += 1
                item.flag = true
                item.In_flag = true
                ContentView.addSubview(calendarView)
            }
        }
    }
    
    func reloadLabel(){
        
        print("reloadLabel")
        let calendar = Calendar.current
        let date = Date()
        let hour = calendar.component(.hour, from: date)
        var label = UILabel()
        for i in 0..<24{
            label = ContentView.viewWithTag(i+1) as! UILabel
            label.text = String((hour+i) % 24) + ":00"
            ContentView.addSubview(label)
        }
        
    }
    
    func setLabel(){
        print("setLabel")
        let calendar = Calendar.current
        let date = Date()
        let hour = calendar.component(.hour, from: date)
        for i in 0..<24{
            let Label = UILabel(frame: CGRect(x: 10, y: 10 + (i * 60), width: 100, height: 40))
            Label.backgroundColor = UIColor.clear
            Label.font = UIFont(name: "Tsukushi A Round Gothic", size: 11)
            //Label.font = UIFont.systemFont(ofSize: 11)
            Label.text = String((hour+i) % 24) + ":00"
            Label.tag = i+1
            ContentView.addSubview(Label)
            //時間軸の直線
            let topBorder = CALayer()
            topBorder.frame = CGRect(x: 60, y: 30 + (i * 60), width: 300, height: 1)
            topBorder.backgroundColor = UIColor.lightGray.cgColor
            //作成したViewに上線を追加
            ContentView.layer.addSublayer(topBorder)
        }
    }
    
    
    func sortData(){
        DataA = DataA.sorted { $0.beforeTag < $1.beforeTag }
        DataM = DataM.sorted { $0.beforeTag < $1.beforeTag }
        DataStamp = DataStamp.sorted { $0.beforeTag < $1.beforeTag }
    }
    
    func craftManu(View: UIView){
        
        print("craftManu")
        let f = DateFormatter()
        f.timeStyle = .none
        f.dateStyle = .full
        f.locale = Locale(identifier: "ja_JP")
        let Now = NSDate() as Date
        let date = f.string(from: Now)
        
        //削除
        for view in StampView.subviews{
            if(type(of: view) == UIView.self){
                view.removeFromSuperview()
            }
        }
        for view in TargetView.subviews{
            if(type(of: view) == UIView.self){
                view.removeFromSuperview()
            }
        }
        
        var tag = 0
        var S_tag = StampStart
        var M_tag = ManuStart
        
        let result_m = realm.objects(Todo.self).filter("datestring == '指定なし'")
        let result_s = realm.objects(Todo.self).filter("datestring == %@", date)
        
        print(result_m)
        print(result_s)
        for item in result_m{
            let longPress = UILongPressGestureRecognizer(target: self, action: #selector(LongPressed(_:)))
            // タップの数（デフォルト0）
            longPress.numberOfTapsRequired = 0
            // 指の数（デフォルト1本）
            longPress.numberOfTouchesRequired = 1
            // 時間（デフォルト0.5秒）
            longPress.minimumPressDuration = 0.5
            // 許容範囲（デフォルト1px）
            longPress.allowableMovement = 150
            //longPress.delegate = self as! UIGestureRecognizerDelegate
            // tableViewにrecognizerを設定
            let taskTitle: UILabel = UILabel(frame: CGRect(x: 0,y: 1,width: 115,height: 15))
            var TestView = UIView()

            TestView = UIView.init(frame: CGRect.init(x: 5, y: 5 + ((StampView.subviews.count) * 25), width: 115, height: 20))
            TestView.tag = Int(item.todoid)!
            
            taskTitle.text = item.title
            taskTitle.textColor = UIColor.black
            //フォントサイズ
            TestView.layer.cornerRadius = 2
            taskTitle.textAlignment = NSTextAlignment.center
            taskTitle.font = UIFont(name: "Tsukushi A Round Gothic", size: 12)
            TestView.backgroundColor = UIColor.white
            TestView.addSubview(taskTitle)
            TestView.addGestureRecognizer(longPress)
            
            StampView.addSubview(TestView)
        }
        print("タスクView作成")
        for item in result_s{
            print(item.base)
            if(item.base != ""){
                continue
            }
            print("a")
            let longPress = UILongPressGestureRecognizer(target: self, action: #selector(LongPressed(_:)))
            // タップの数（デフォルト0）
            longPress.numberOfTapsRequired = 0
            // 指の数（デフォルト1本）
            longPress.numberOfTouchesRequired = 1
            // 時間（デフォルト0.5秒）
            longPress.minimumPressDuration = 0.5
            // 許容範囲（デフォルト1px）
            longPress.allowableMovement = 150
            //longPress.delegate = self as! UIGestureRecognizerDelegate
            // tableViewにrecognizerを設定
            let taskTitle: UILabel = UILabel(frame: CGRect(x: 0,y: 1,width: 115,height: 15))
            var TestView = UIView()

            TestView = UIView.init(frame: CGRect.init(x: 5, y: 5 + ((TargetView.subviews.count) * 25), width: 115, height: 20))
            TestView.tag = tag
            taskTitle.text = item.title
            
            TestView.tag = Int(item.todoid)!
            taskTitle.textColor = UIColor.black
            //フォントサイズ
            TestView.layer.cornerRadius = 2
            taskTitle.textAlignment = NSTextAlignment.center
            taskTitle.font = UIFont(name: "Tsukushi A Round Gothic", size: 12)
            TestView.backgroundColor = UIColor.white
            TestView.addSubview(taskTitle)
            TestView.addGestureRecognizer(longPress)
            
            TargetView.addSubview(TestView)
        }
    }
    //    終日作成
    func craftAllday(View: UIView){
        print("craftAllday")
        print(DataA)
        //削除
        for view in AlldayView.subviews{
            if(type(of: view) == UIView.self){
                view.removeFromSuperview()
            }
        }
        var tag = AllStart
        var cnt = Int(0)
        var y = Int(-1)
        for item in DataA{
            if(!item.flag){
                if(cnt % 4 == 0){
                    cnt = 0
                    y += 1
                }
                print("craftAll")
                let TestView = UIView.init(frame: CGRect.init(x: 5 + (cnt * 85), y: 3 + (y * 24), width: 80, height: 20))
                
                let taskTitle: UILabel = UILabel(frame: CGRect(x: 0,y: 0,width: 80,height: 20))
                taskTitle.text = item.todoTitle
                TestView.layer.cornerRadius = 2
                taskTitle.textAlignment = NSTextAlignment.center
                taskTitle.font = UIFont(name: "Tsukushi A Round Gothic", size: 11)
                //taskTitle.font = UIFont.systemFont(ofSize: 11)
                
                taskTitle.textColor = UIColor.white
                TestView.tag = tag
                item.beforeTag = tag
                TestView.backgroundColor = UIColor(red: CGFloat(item.color[0]), green: CGFloat(item.color[1]), blue: CGFloat(item.color[2]), alpha: CGFloat(item.color[3]))
                if(tag - AllStart > 7){
                    TestView.alpha = 0.0
                }
                View.addSubview(TestView)
                TestView.addSubview(taskTitle)
                
                let longPress = UILongPressGestureRecognizer(target: self, action: #selector(LongPressed(_:)))
                // タップの数（デフォルト0）
                longPress.numberOfTapsRequired = 0
                // 指の数（デフォルト1本）
                longPress.numberOfTouchesRequired = 1
                // 時間（デフォルト0.5秒）
                longPress.minimumPressDuration = 0.5
                // 許容範囲（デフォルト1px）
                longPress.allowableMovement = 150
                //longPress.delegate = self as! UIGestureRecognizerDelegate
                
                // tableViewにrecognizerを設定
                TestView.addGestureRecognizer(longPress)
                tag += 1
                cnt += 1
            }
        }
    }
    
    func userDefaultData(){
        print("userDefaultData")
        
        calendarArray.removeAll()
        calendarArray2.removeAll()
        calendarArray = Datas
        
        let date = NSDate() as Date
        let dateFormater = DateFormatter()
        
        dateFormater.locale = Locale(identifier: "ja_JP")
        dateFormater.dateFormat = "yyyy/MM/dd"
        dateFormater.timeZone = TimeZone(identifier: "Asia/Tokyo")
        print("userDefaultData-Content.subviews")
        
        let calendars = realm.objects(Calendar24.self)
        for view in ContentView.subviews{
            if(type(of: view) == SampleView.self){
                print(view.tag)
                let startTime = getTaskTime(view: view)
                let dotime = Int((view.frame.height-20) * 60)
                let end = convert_string_details(date: Calendar.current.date(byAdding: .second, value: dotime, to: startTime)!)
                if(view.tag > 100000000){
                    print("a")
                    
                    try! realm.write{
                        let day = startTime
                        let end = Calendar.current.date(byAdding: .second, value: dotime, to: day)!
                        var item = realm.object(ofType: Calendar24.self, forPrimaryKey: String(view.tag))
                        item!.start = startTime
                        item!.c_dotime = dotime
                        item!.end = end
                    }
                }
            }
        }
    }

    func traceView(userY: CGFloat, height: CGFloat, tag: Int){
        let result_t = realm.object(ofType: Todo.self, forPrimaryKey: String(tag))
        print(result_t)
        print(type(of: result_t))
        let no1point = 30
        let no23point = 1410
        let hour = (no23point - no1point)/23
        //print(hour,now)
        let minute:Double
        minute = Double(hour)/Double(60)
        
        print(tag)
        
        print("traceView")
        //UIViewController.viewの座標取得
        let x:CGFloat = 60
        var y:CGFloat = userY
        if(currentPoint != nil){
            y += currentPoint.y
        }
        //UIViewController.viewの幅と高さを取得
        let width:CGFloat = 300
        let height:CGFloat = height
        
        //上記より画面ぴったりサイズのフレームを生成する
        
        //15分刻み
        for i in 0..<92 {
            if(Double(y) > Double(no1point) + Double(hour*i/4) && Double(y) <= Double(no1point) + Double(hour/8) + Double(hour*i/4)){
                y = CGFloat(round(Double(no1point) + Double(hour*i/4)))
            }else if(Double(y) <= Double(no1point) + Double(hour*(i+1)/4) && Double(y) > Double(no1point) + Double(hour/8) + Double(hour*i/4)){
                y = CGFloat(round(Double(no1point) + Double(hour*(i+1)/4)))
            }
        }
        
        let frame:CGRect = CGRect(x: x, y: y, width: width, height: height + 20)
        
        //カスタマイズViewを生成
        let titleLabel: UILabel = UILabel(frame: CGRect(x: 0,y: 0,width: width,height: 15))
        let tasktimeLabel: UILabel = UILabel(frame: CGRect(x: 100,y: 20,width: 100,height: 20))
        
//        let tasktime_hour = Int(tasktime / 60)
//        let tasktime_minute = Int(tasktime % 60)
        
        let myView: SampleView = SampleView(frame: frame)
        
        let startTime = getTaskTime(view: myView)
        var title = result_t!.title
        var tasktime = result_t!.dotime
        let timetext = String(format: "%02dh %02dm", Int(tasktime/60), Int(round(Double(tasktime) - Double(60*Int(tasktime/60)))))
        tasktimeLabel.text = timetext
        
        titleLabel.textColor = UIColor.white
        //        var font = UIFont(name: "Tsukushi A Round Gothic", size: 10)
        //        titleLabel.font = font?.bold
        titleLabel.font = UIFont.boldSystemFont(ofSize: 13)
        titleLabel.layer.masksToBounds = true
        titleLabel.layer.cornerRadius = 4
        titleLabel.backgroundColor = UIColor.black
        tasktimeLabel.textColor = UIColor.white
        tasktimeLabel.tag = 100
        
        print("startTime-traceView")
        var color = UIColor()
        
//        let todo = realm.object(ofType: Todo.self, forPrimaryKey: String(tag))
        let new_todo = Todo()
        let todo = realm.objects(Todo.self)
        var save_id = String()
        var add_flag = false
        for item in todo{
            if(item.base == result_t!.todoid){
                add_flag = true
            }
        }
        print(add_flag)
        try! realm.write{
            if(result_t!.datestring == "指定なし" && add_flag == false){
                let f = DateFormatter()
                f.timeStyle = .none
                f.dateStyle = .full
                f.locale = Locale(identifier: "ja_JP")
                //            result_t!.InFlag = true
                //            print(todo!.title)
                new_todo.todoid = randomString(length: 10)
                
                save_id = new_todo.todoid
                
                new_todo.title = String(result_t!.title)
                new_todo.todoDone = false
                new_todo.donetime = 0
                new_todo.dotime = result_t!.dotime
                new_todo.date = startTime
                new_todo.datestring = f.string(from: startTime)
                new_todo.InFlag = true
                new_todo.base = result_t!.todoid
                self.realm.add(new_todo)
            }else{
                
//                result_t?.InFlag = true
                save_id = result_t!.todoid
            }
        }
        for item in todo {
            if(item.base == save_id){
                save_id = item.todoid
            }
        }
//        let todo = realm.objects(Todo.self)
        
        let cal = Calendar24()
        let new_cal = realm.object(ofType: Todo.self, forPrimaryKey: save_id)
        try! realm.write{
            cal.calendarid = randomString(length: 10)
            cal.todoDone = false
            cal.start = startTime
            cal.default_allday = false
            cal.c_dotime = result_t!.dotime
//            result_t!.calendars.append(cal)
            new_cal?.InFlag = true
            new_cal!.calendars.append(cal)
        }
        
        let ReturnButton :UIButton = UIButton(frame: CGRect(x: width - 15,y: 0,width: 15,height: 15))
        ReturnButton.setImage(UIImage(named:"close_black"), for: .normal)
        //ReturnButton.backgroundColor = UIColor.red
        ReturnButton.addTarget(self, action: #selector(ReturnToMenu(_:)), for: UIControl.Event.touchUpInside)
        
        myView.addSubview(tasktimeLabel)
        
        myView.tag = Int(cal.calendarid)!
        myView.content.backgroundColor = UIColor.blue
        myView.leftBorder.backgroundColor = UIColor.blue
        myView.fakeView.backgroundColor = UIColor.blue
        myView.title.backgroundColor = UIColor.blue
//        myView.content.backgroundColor = color
//        myView.leftBorder.backgroundColor = color
//        myView.fakeView.backgroundColor = color
//        myView.title.backgroundColor = color
        
        titleLabel.text = " " + title
        titleLabel.tag = 26
        myView.addSubview(titleLabel)
        myView.addSubview(ReturnButton)
        
        //カスタマイズViewを追加
        ContentView.addSubview(myView)
        viewtag += 1
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        print("viewWillDisappear")
        userDefaultData()
        addEvent()
    }
    
    
    @objc func ReturnToMenu(_ sender: UIButton) {
        print("ボタンの情報: \(sender)")
        let alert: UIAlertController = UIAlertController(title: "このスケジュールを削除しますか？", message: "元々が終日の予定であるものは終日に戻ります", preferredStyle:  UIAlertController.Style.alert)
        
        // ② Actionの設定
        // Action初期化時にタイトル, スタイル, 押された時に実行されるハンドラを指定する
        // 第3引数のUIAlertActionStyleでボタンのスタイルを指定する
        // OKボタン
        let defaultAction: UIAlertAction = UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler:{
            
            // ボタンが押された時の処理を書く（クロージャ実装）
            (action: UIAlertAction!) -> Void in
            print("OK")
            let TestView = UIView()
            var index = 0
            var cnt = 0
            let cal = self.realm.objects(Calendar24.self)
            for item in cal{
                if(Int(item.calendarid) == sender.superview!.tag){
                    print("realm削除")
                    let result_c = self.realm.object(ofType: Calendar24.self, forPrimaryKey: item.calendarid)
                    let result_t = self.realm.object(ofType: Todo.self, forPrimaryKey: item.todo.first?.todoid)
                    try! self.realm.write{
                        print(result_c)
                        self.realm.delete(result_c!)
                        print(result_t!.calendars.count)

                        if(result_t!.calendars.count == 0){
                            result_t?.InFlag = false
                            if(result_t!.base != ""){
                                self.realm.delete(result_t!)
                            }
                        }
                    }
                }
            }
            for item in self.DataA{
                if(item.afterTag == sender.superview!.tag){
                    print("終日へ戻る")
                    print(item.todoTitle)
                    item.flag = false
                    item.In_flag = false
                    item.all_day = true
                    for view in self.AlldayView.subviews{
                        if(type(of: view) == UIView.self){
                            cnt += 1
                        }
                    }
                    var y = Int(0)
                    for i in 0...cnt{
                        if(i == 0){
                            continue
                        }
                        if(i % 4 == 0){
                            y += 1
                        }
                    }
                    TestView.frame = CGRect.init(x: 5 + (cnt % 4) * 85, y: 3 + (y * 24), width: 80, height: 20)
                    
                    let taskTitle: UILabel = UILabel(frame: CGRect(x: 5,y: 0,width: 80,height: 15))
                    taskTitle.text = item.todoTitle
                    
                    taskTitle.font = UIFont.systemFont(ofSize: 11)
                    TestView.backgroundColor = UIColor(red: CGFloat(item.color[0]), green: CGFloat(item.color[1]), blue: CGFloat(item.color[2]), alpha: CGFloat(item.color[3]))
                    taskTitle.textColor = UIColor.white
                    TestView.tag = item.beforeTag
                    if(item.beforeTag - self.AllStart > 7){
                        TestView.alpha = 0.0
                    }
                    TestView.layer.cornerRadius = 2
                    taskTitle.textAlignment = NSTextAlignment.center
                    taskTitle.font = UIFont(name: "Tsukushi A Round Gothic", size: 11)
                    TestView.addSubview(taskTitle)
                    TestView.tag = item.beforeTag
                    let longPress = UILongPressGestureRecognizer(target: self, action: #selector(self.LongPressed(_:)))
                    // タップの数（デフォルト0）
                    longPress.numberOfTapsRequired = 0
                    // 指の数（デフォルト1本）
                    longPress.numberOfTouchesRequired = 1
                    // 時間（デフォルト0.5秒）
                    longPress.minimumPressDuration = 0.5
                    // 許容範囲（デフォルト1px）
                    longPress.allowableMovement = 150
                    //longPress.delegate = self as! UIGestureRecognizerDelegate
                    
                    // tableViewにrecognizerを設定
                    TestView.addGestureRecognizer(longPress)
                    self.DataA.append(item)
                    self.AlldayView.addSubview(TestView)
                }
                index += 1
            }
            index = 0
            for item in self.Datas{
                if(item.afterTag == sender.superview!.tag){
                    print("Datas削除")
//                    self.Datas.remove(at: index)
                    if(item.default_allday){
                        item.start = ""
                        item.end = ""
                        item.dotime = 0
                        item.flag = false
                        item.In_flag = false
                        item.all_day = true
                        for view in self.AlldayView.subviews{
                            if(type(of: view) == UIView.self){
                                cnt += 1
                            }
                        }
                        var y = Int(0)
                        for i in 0...cnt{
                            if(i == 0){
                                continue
                            }
                            if(i % 4 == 0){
                                y += 1
                            }
                        }
                        TestView.frame = CGRect.init(x: 5 + (cnt % 4) * 85, y: 3 + (y * 24), width: 80, height: 20)
                        
                        let taskTitle: UILabel = UILabel(frame: CGRect(x: 0,y: 0,width: 80,height: 15))
                        taskTitle.text = item.todoTitle
                        
                        taskTitle.font = UIFont.systemFont(ofSize: 11)
                        TestView.backgroundColor = UIColor(red: CGFloat(item.color[0]), green: CGFloat(item.color[1]), blue: CGFloat(item.color[2]), alpha: CGFloat(item.color[3]))
                        TestView.layer.cornerRadius = 2
                                           taskTitle.textAlignment = NSTextAlignment.center
                                           taskTitle.font = UIFont(name: "Tsukushi A Round Gothic", size: 11)
                        taskTitle.textColor = UIColor.white
                        TestView.tag = item.beforeTag
                        
                        
                        if(item.beforeTag - self.AllStart > 7){
                            TestView.alpha = 0.0
                        }
                        TestView.addSubview(taskTitle)
                        TestView.tag = item.beforeTag
                        let longPress = UILongPressGestureRecognizer(target: self, action: #selector(self.LongPressed(_:)))
                        // タップの数（デフォルト0）
                        longPress.numberOfTapsRequired = 0
                        // 指の数（デフォルト1本）
                        longPress.numberOfTouchesRequired = 1
                        // 時間（デフォルト0.5秒）
                        longPress.minimumPressDuration = 0.5
                        // 許容範囲（デフォルト1px）
                        longPress.allowableMovement = 150
                        //longPress.delegate = self as! UIGestureRecognizerDelegate
                        
                        // tableViewにrecognizerを設定
                        TestView.addGestureRecognizer(longPress)
                        self.DataA.append(item)
                        self.AlldayView.addSubview(TestView)
                    }
                }
                index += 1
            }
            sender.superview?.removeFromSuperview()
        })
        // キャンセルボタン
        let cancelAction: UIAlertAction = UIAlertAction(title: "キャンセル", style: UIAlertAction.Style.cancel, handler:{
            // ボタンが押された時の処理を書く（クロージャ実装）
            (action: UIAlertAction!) -> Void in
            print("Cancel")
        })
        
        // ③ UIAlertControllerにActionを追加
        alert.addAction(cancelAction)
        alert.addAction(defaultAction)
        
        // ④ Alertを表示
        present(alert, animated: true, completion: nil)
        
    }
    
    
    func animation(){
        ActivityIndicator.startAnimating()
        DispatchQueue.global(qos: .default).async {
            Thread.sleep(forTimeInterval: 5)
            DispatchQueue.main.async {
                self.ActivityIndicator.stopAnimating()
            }
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        print("touches")
        aTouch = touches.first!
        sTouch = aTouch.location(in: self.view)
        print("sTouch")
        print(sTouch)
    }
    
    //リフレッシュ
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        print("scrollViewDidScroll")
        currentPoint = MyScrollView.contentOffset;
        if(currentPoint.y < -100 && animeFlag == 0){
            isRefreshing = true
            UIView.animate(withDuration: 0.3, animations: {
                // frame分 scrollViewの位置を下げる
                var newInsets = self.MyScrollView!.contentInset
                newInsets.top += self.AnimationView.frame.size.height
                self.MyScrollView!.contentInset = newInsets
            })
            //print(getnowTime())
            //refreshCtl.addTarget(self, action: #selector(ViewController.refresh(sender:)), for: .valueChanged)
            animeFlag = 1
            animation()
        }
        print(scrollFlag)
        print(location.y)
        //        if(scrollFlag && location.y <= self.view!.frame.size.height - 20 && location.y >= 115){
        //            print("flag")
        //            scrollFlag = false
        //            stopAutoScrollIfNeeded()
        //        }
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        print("scrollViewDidEndDecelerating")
        animeFlag = 0
        let now = NSDate()
        let date1 = Calendar.current.dateComponents([.hour], from: now as Date, to: NOW as Date).hour!
        print(NOW)
        print(date1)
        //ActivityIndicator.stopAnimating()
        if(isRefreshing == true){
            UIView.animate(withDuration: 0.3, delay:0.0, options: .curveEaseOut ,animations: {
                // frame分 scrollViewの位置を上げる（元の位置に戻す）
                var newInsets = self.MyScrollView!.contentInset
                newInsets.top -= self.AnimationView.frame.size.height
                self.MyScrollView!.contentInset = newInsets
            }, completion: {_ in
                //finished
            })
            //craftCalendar()
            reloadView()
            reloadLabel()
            day.titleView = getnowTime()
            isRefreshing = false
        }
    }
    
    func reloadView(){
        let date = Date()
        let hour = calendar.component(.hour, from: date)
        print(hour)
        let firstLabel = (ContentView.viewWithTag(1) as! UILabel).text
        var firstLabel_hour = firstLabel!.components(separatedBy: ":")
        print(firstLabel_hour)
        var dif = (Int(hour) - Int(firstLabel_hour[0])!) * 60
        if(String(firstLabel_hour[0]) != String(hour)){
            print("一時間過ぎた")
            for view in ContentView.subviews{
                if type(of: view) == SampleView.self{
                    print(view)
                    if(view.frame.origin.y <= CGFloat(30)){
                        view.removeFromSuperview()
                    }else{
                        view.frame.origin.y -= CGFloat(dif)
                    }
                }
            }
        }else {
            print("一時間過ぎてない")
            for view in ContentView.subviews{
                if(type(of: view) == UILabel.self){
                    print(view)
                }
                print("---------")
                if(type(of: view) == SampleView.self){
                    for item in view.subviews{
                        if(type(of: item) == UILabel.self){
                            print(item)
                        }
                    }
                }
            }
        }
    }
    
    var no1point = 30
    var no23point = 1410
    func getTaskTime(view: UIView) -> (Date){
        let hour = (no23point - no1point)/23
        let minute:Double
        minute = Double(hour)/Double(60)
        
        let format = DateFormatter()
        
        let calendar = Calendar.current
        let date = NSDate() as Date
        let m = calendar.component(.minute, from: date)
        
        let starttime = Int(round(Double(Double(view.frame.origin.y) - Double(no1point)) / minute)) - m
        let startDate = Calendar.current.date(byAdding: .minute, value: starttime, to: date)!
        
        format.dateFormat = "HH:mm"
        format.timeZone   = TimeZone(identifier: "Asia/Tokyo")
        
        print("スタートタイム")
        print(format.string(from: startDate))
        return startDate
    }
    
    func getnowTime()->UILabel{
        
        let now = NSDate()
        let calendar = Calendar(identifier: .gregorian)
        let m = calendar.component(.minute, from: now as Date)
        let weeks = ["日","月","火","水","木","金","土"]
        nowtimeBar.frame = CGRect(x: 50, y: m % 60 + no1point, width: 310, height: 1)
        nowtimeBar.backgroundColor = UIColor.red.cgColor
        nowtimeMark.frame.size = CGSize(width: 11, height: 15)
        nowtimeMark.center = CGPoint(x: 50, y: m % 60 + no1point)
        ContentView.addSubview(nowtimeMark)
        ContentView.layer.addSublayer(nowtimeBar)
        let component = calendar.component(.weekday, from: now as Date)
        let weekday = component - 1
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "en")
        formatter.dateFormat = "yyyy  MM/dd"
        //formatter.dateFormat = "yyyy/MM/dd HH:mm:ss"
        let nowTime = formatter.string(from: now as Date) + "  (" + weeks[weekday] + ")"
        let nowTimeLabel = UILabel()
        let attrText = NSMutableAttributedString(string: nowTime)
        attrText.addAttribute(.font,
                              value: UIFont.boldSystemFont(ofSize: 25),
                              range: NSMakeRange(6, 5))
        // attributedTextとしてUILabelに追加します.
        nowTimeLabel.attributedText = attrText
        nowTimeLabel.textAlignment = NSTextAlignment.center
        nowTimeLabel.baselineAdjustment = UIBaselineAdjustment.alignCenters
        return nowTimeLabel
    }
    
    var centerPoint = CGPoint()
    var scrollFlag = false
    var moveView1 = CGPoint()
    var moveView2 = CGPoint()
    
    //長押し
    @objc func LongPressed(_ sender: UILongPressGestureRecognizer) {

        let todo = Todo()
        let cal = Calendar24()
        let result_t = realm.object(ofType: Todo.self, forPrimaryKey: String(sender.view!.tag))
        
        let x = sender.self.view!.frame.origin.x
        let y = sender.self.view!.frame.origin.y
        let w = sender.self.view!.frame.size.width
        let h = sender.self.view!.frame.size.height
        let center = sender.self.view!.center
        
        var index = Int()
        var manuflag = Bool()
        
        if(sender.state == UIGestureRecognizer.State.began) {
            print("subview", AlldayView.subviews)
            if(TargetView.subviews.firstIndex(of: sender.view!) != nil){
                index = TargetView.subviews.firstIndex(of: sender.view!)!
                TargetView.exchangeSubview(at: index, withSubviewAt: TargetView.subviews.count - 1)
                ManuView.exchangeSubview(at: ManuView.subviews.count - 3, withSubviewAt: ManuView.subviews.firstIndex(of: TargetView)!)
                manuflag = false
            }else if(StampView.subviews.firstIndex(of: sender.view!) != nil){
                ManuView.exchangeSubview(at: ManuView.subviews.count - 3, withSubviewAt: ManuView.subviews.firstIndex(of: StampView)!)
                //ManuView.exchangeSubview(at: ManuView.subviews.firstIndex(of: TargetView)!, withSubviewAt: 0)
                index = StampView.subviews.firstIndex(of: sender.view!)!
                StampView.exchangeSubview(at: index, withSubviewAt: StampView.subviews.count - 1)
                manuflag = true
            }else if(AlldayView.subviews.firstIndex(of: sender.view!) != nil){
                index = AlldayView.subviews.firstIndex(of: sender.view!)!
                AlldayView.exchangeSubview(at: index, withSubviewAt: AlldayView.subviews.count - 1)
            }
            for view in ManuView.subviews {
                if type(of: view) !=  UIView.self {
                    view.alpha = 0.0
                }
            }
            topBorder.removeFromSuperlayer()
            
            moveView1 = sender.self.view!.frame.origin
            
            let no1point = 30
            let no23point = 1410
            let hour = (no23point - no1point)/23
            let minute:Double
            minute = Double(hour)/Double(60)
            
            print("長押し開始")
            print(center)
            centerPoint = center
            let selectView = ManuView.viewWithTag(sender.self.view!.tag)
            
            if(selectView != nil){
                let dotime = Double(result_t!.dotime) / 60
                UIView.animate(withDuration: 0.3, delay: 0.0, options: .curveEaseOut, animations: {
                    sender.self.view!.frame = CGRect(x: x, y: y, width: sender.self.view!.frame.width, height: CGFloat(Double(dotime) * minute))
                    sender.self.view!.center = center
                }, completion: nil)
            }else{
                UIView.animate(withDuration: 0.3, delay: 0.0, options: .curveEaseOut, animations: {
                    sender.self.view!.frame = CGRect(x: x, y: y, width: sender.self.view!.frame.width, height: sender.self.view!.frame.height * 3 )
                    sender.self.view!.center = center
                }, completion: nil)
            }
            // 影の方向（width=右方向、height=下方向、CGSize.zero=方向指定なし）
            sender.self.view!.layer.shadowOffset = CGSize(width: 0.0, height: 2.0)
            // 影の色
            sender.self.view!.layer.shadowColor = UIColor.black.cgColor
            // 影の濃さ
            sender.self.view!.layer.shadowOpacity = 0.6
            // 影をぼかし
            sender.self.view!.layer.shadowRadius = 4
        }else if(sender.state == UIGestureRecognizer.State.changed){
            location = aTouch.location(in: self.view)
            userY = location.y - (sender.self.view!.frame.height/2)
            //print(location)
            let prevLocation = aTouch.previousLocation(in: self.view)
            // ドラッグで移動したx, y距離をとる.
            let deltaX: CGFloat = location.x - prevLocation.x
            let deltaY: CGFloat = location.y - prevLocation.y
            sender.self.view!.center.x += deltaX
            sender.self.view!.center.y += deltaY
            
            if(!scrollFlag){
                if(location.y > self.view!.frame.size.height - 80 && location.x < 250){
                    print("under")
                    scrollFlag = true
                    startAutoScroll(duration: 0.05, direction: .under)
                    
                }else if(location.y < 65 + dummyAll.constant && location.y > AlldayView.frame.origin.y + dummyAll.constant){
                    print("upper")
                    scrollFlag = true
                    startAutoScroll(duration: 0.05, direction: .upper)
                }
            }
            if(location.y <= self.view!.frame.size.height - 20 && location.y >= 65 + dummyAll.constant || location.x >= 250){
                //print("flag")
                scrollFlag = false
                stopAutoScrollIfNeeded()
            }
        }else if(sender.state == UIGestureRecognizer.State.ended){
            print("長押し終了")
            if(TargetView.subviews.firstIndex(of: sender.view!) != nil){
                index = TargetView.subviews.firstIndex(of: sender.view!)!
                TargetView.exchangeSubview(at: index, withSubviewAt: TargetView.subviews.count - 1)
                ManuView.exchangeSubview(at: ManuView.subviews.count - 3, withSubviewAt: ManuView.subviews.firstIndex(of: TargetView)!)
                manuflag = false
            }else if(StampView.subviews.firstIndex(of: sender.view!) != nil){
                ManuView.exchangeSubview(at: ManuView.subviews.count - 3, withSubviewAt: ManuView.subviews.firstIndex(of: StampView)!)
                //ManuView.exchangeSubview(at: ManuView.subviews.firstIndex(of: TargetView)!, withSubviewAt: 0)
                index = StampView.subviews.firstIndex(of: sender.view!)!
                StampView.exchangeSubview(at: index, withSubviewAt: StampView.subviews.count - 1)
                manuflag = true
            }else if(AlldayView.subviews.firstIndex(of: sender.view!) != nil){
                index = AlldayView.subviews.firstIndex(of: sender.view!)!
                AlldayView.exchangeSubview(at: index, withSubviewAt: AlldayView.subviews.count - 1)
            }
            sender.self.view!.layer.shadowOpacity = 0.0
            for view in ManuView.subviews {
                if type(of: view) !=  UIView.self {
                    view.alpha = 1.0
                }
            }
            TargetView.layer.addSublayer(topBorder)
            if(location.x >= 250 && location.y >= 552 - dummyManu.constant){
                UIView.animate(withDuration: 0.3, delay: 0.0, options: .curveEaseOut, animations: {
                    sender.self.view!.frame = CGRect(x: x, y: y, width: w,height: 20)
                    sender.self.view!.center = self.centerPoint
                }, completion: nil)
                
            }else if(location.y >= AlldayView.frame.origin.y && location.y <= AlldayView.frame.origin.y + dummyAll.constant){
                UIView.animate(withDuration: 0.3, delay: 0.0, options: .curveEaseOut, animations: {
                    sender.self.view!.frame = CGRect(x: x, y: y, width: w,height: 20)
                    sender.self.view!.center = self.centerPoint
                }, completion: nil)
                
            }else{
                print("moveManu")
                let savetag = sender.self.view!.tag
                var delete = ManuView.viewWithTag(savetag)
                if(delete != nil){
                    
                    
                    traceView(userY: userY - CGFloat(65 + dummyAll.constant), height: sender.self.view!.frame.height, tag: savetag)
                    
                    print("moveView1")
                    print(moveView1)
                    //view作成
                    let taskTitle: UILabel = UILabel(frame: CGRect(x: 0,y: 0,width: 115,height: 15))
                    let TestView = UIView()
                    if(result_t!.datestring == "指定なし"){
                        print("指定なし")
                        TestView.frame = CGRect(x: 5, y: moveView1.y, width: 115, height: 20)
                    }else{
                        print("日付あり")
                        print(TargetView.subviews.count)
                        TestView.frame = CGRect(x: 5, y: moveView1.y, width: 115, height: 20)
                    }
                    
                    TestView.layer.cornerRadius = 2
                    
                    taskTitle.textColor = UIColor.black
                    //フォントサイズ
                    taskTitle.textAlignment = NSTextAlignment.center
                    taskTitle.font = UIFont(name: "Tsukushi A Round Gothic", size: 12)
                    //taskTitle.font = UIFont.systemFont(ofSize: 12)
                    
                    TestView.backgroundColor = UIColor.white
                    TestView.tag = Int(result_t!.todoid)!
                    
                    taskTitle.text = result_t!.title
                    TestView.addSubview(taskTitle)
                    //                            print(DataStamp[DataStamp.count].beforeTag)
                    let longPress = UILongPressGestureRecognizer(target: self, action: #selector(self.LongPressed(_:)))
                    // タップの数（デフォルト0）
                    longPress.numberOfTapsRequired = 0
                    // 指の数（デフォルト1本）
                    longPress.numberOfTouchesRequired = 1
                    // 時間（デフォルト0.5秒）
                    longPress.minimumPressDuration = 0.5
                    // 許容範囲（デフォルト1px）
                    longPress.allowableMovement = 150
                    //longPress.delegate = self as! UIGestureRecognizerDelegate
                    
                    // tableViewにrecognizerを設定
                    TestView.addGestureRecognizer(longPress)
                    if(result_t!.datestring == "指定なし"){
                        print("StampView")
                        StampView.addSubview(TestView)
                        print(TestView)
                    }else{
                        print("TargetView")
                        TargetView.addSubview(TestView)
                        print(TestView)
                    }
                    delete!.removeFromSuperview()
                }else{
                    delete = AlldayView.viewWithTag(savetag)
                    var cnt = AllStart
                    for View in AlldayView.subviews{
                        if(cnt != AlldayView.subviews.count + AllStart){
                            if(savetag < View.tag){
                                moveView2 = AlldayView.viewWithTag(View.tag)!.frame.origin
                                UIView.animate(withDuration: 0.5, delay: 0.0, options: .curveEaseIn, animations: {
                                    self.AlldayView.viewWithTag(View.tag)!.frame.origin = CGPoint(x: self.moveView1.x, y: self.moveView1.y)
                                    //self.AlldayView.viewWithTag(View.tag)!.center = self.centerPoint
                                }, completion: nil)
                                AlldayView.viewWithTag(View.tag)!.frame.origin = moveView1
                                moveView1 = moveView2
                                cnt += 1
                            }
                        }
                    }
                    print("トレースビュー")
                    print(savetag)
                    traceView(userY: userY - CGFloat(65 + dummyAll.constant), height: sender.self.view!.frame.height, tag: savetag)
                    delete!.removeFromSuperview()
                    if(dummyAllFlag){
                        dummyAll.constant = 25 + CGFloat((AlldayView.subviews.count / 4) * 25)
                    }
                    cnt = Int(0)
                    for View in AlldayView.subviews{
                        if(cnt <= 8){
                            View.alpha = 1.0
                        }
                        cnt += 1
                    }
                }
            }
            
            
            scrollFlag = false
            stopAutoScrollIfNeeded()
        }
    }
    
    
    
    
    
    func startAutoScroll(duration: TimeInterval, direction: ScrollDirectionType) {
        // 表示されているTableViewのOffsetを取得
        var currentOffsetY = MyScrollView.contentOffset.y
        // 自動スクロールを終了させるかどうか
        var shouldFinish = false
        autoScrollTimer = Timer.scheduledTimer(withTimeInterval: duration, repeats: true, block: { [weak self] (_) in
            guard let self = self else { return }
            // 10ずつY軸のoffsetを変更していく
            switch direction {
            case .upper:
                currentOffsetY = (currentOffsetY - 10 < 0) ? 0 : currentOffsetY - 10
                shouldFinish = currentOffsetY == 0
            case .under:
                let highLimit = self.MyScrollView.contentSize.height - self.MyScrollView.bounds.size.height
                currentOffsetY = (currentOffsetY + 10 > highLimit) ? highLimit : currentOffsetY + 10
                shouldFinish = currentOffsetY == highLimit
            default: break
            }
            DispatchQueue.main.async {
                UIView.animate(withDuration: duration * 2, animations: {
                    self.MyScrollView.setContentOffset(CGPoint(x: 0, y: currentOffsetY), animated: false)
                }, completion: { _ in
                    if shouldFinish { self.stopAutoScrollIfNeeded()}
                })
            }
        })
    }
    
    // 自動スクロールを停止する
    func stopAutoScrollIfNeeded() {
        //print("------------------------------------------------------")
        if (autoScrollTimer.isValid) {
            print("#######3333333333333333333333333333333333333333333")
            MyScrollView.layer.removeAllAnimations()
            autoScrollTimer.invalidate()
        }
    }
    
    enum ScrollDirectionType {
        case upper, under, left, right
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func gestureRecognizer(gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWithGestureRecognizer otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return true
    }
    
}
extension UIScrollView {
    override open func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.next?.touchesBegan(touches, with: event)
    }
}

extension UIFont {
    var bold: UIFont { return withWeight(.bold) }
    var semibold: UIFont { return withWeight(.semibold) }
    
    private func withWeight(_ weight: UIFont.Weight) -> UIFont {
        var attributes = fontDescriptor.fontAttributes
        var traits = (attributes[.traits] as? [UIFontDescriptor.TraitKey: Any]) ?? [:]
        
        traits[.weight] = weight
        
        attributes[.name] = nil
        attributes[.traits] = traits
        attributes[.family] = familyName
        
        let descriptor = UIFontDescriptor(fontAttributes: attributes)
        
        return UIFont(descriptor: descriptor, size: pointSize)
    }
}
