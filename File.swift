//
//  SampleView.swift
//  nextCalendar
//
//  Created by 牧内秀介 on 2019/09/27.
//  Copyright © 2019 Swift-Biginners. All rights reserved.
//

import Foundation
import UIKit

class SampleView :UIView{
    var no1point = 30
    var no23point = 1410
    
    var aTouch = UITouch()
    
    let radius: CGFloat = 10.0
    
    var imageView = UIImageView(image:UIImage(named:"chevron-down")!)
    
    let circle = UIView.init(frame: CGRect.init(x: 0, y: 0, width: 15, height: 15))
    
    let taskTime: UILabel = UILabel(frame: CGRect(x: 100,y: 0,width: 50,height: 10))
    let startTime: UILabel = UILabel(frame: CGRect(x: 0,y: 30,width: 100,height: 10))
    let endTime: UILabel = UILabel(frame: CGRect(x: 50,y: 30,width: 100,height: 10))
    
    let content = UIView.init(frame: CGRect.init(x: 0, y: 0, width: 200, height: 15))
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        //self.backgroundColor = UIColor.blue
//        let myLabel: UILabel = UILabel(frame: CGRect(x: 0,y: 0,width: 50,height: 20))
//        taskTime.text = "Title"
//        myLabel.text = "Title"
//        myLabel.textColor = UIColor.white
        taskTime.textColor = UIColor.white
        startTime.textColor = UIColor.white
//        endTime.textColor = UIColor.white
        
        imageView.frame = CGRect(x:self.frame.size.width/2, y: self.frame.size.height, width:30, height:30)
        imageView.center = CGPoint(x: self.frame.size.width/2, y: self.frame.size.height - 10)
        taskTime.font.withSize(10.0)
        self.content.addSubview(taskTime)
        self.content.addSubview(startTime)
        
//        self.addSubview(endTime)
//        self.addSubview(myLabel)
        
        content.frame.size.height = self.frame.size.height - 20
        content.backgroundColor = UIColor.blue
        
        circle.layer.cornerRadius = circle.frame.size.width / 2.0
        circle.center = CGPoint(x: self.frame.size.width/2, y: self.content.frame.size.height)
        circle.backgroundColor = UIColor.white
        circle.clipsToBounds = true
        circle.layer.borderColor = UIColor.black.cgColor
        circle.layer.borderWidth = 2
        
        //self.addSubview(imageView)
        
        
        //self.layer.borderColor = UIColor.black.cgColor
        //self.layer.borderWidth = 2
        self.addSubview(content)
        
        self.addSubview(circle)
        
        getTaskTime()

        //panジェスチャーのインスタンスを作成する
        let gesture = UIPanGestureRecognizer(target: self, action: #selector(panGesture(_:)))
//        let circlePan = UIPanGestureRecognizer(target: self, action: #selector(self.circlePanGesture(_:)))
//        //ジェスチャーを追加する
        self.addGestureRecognizer(gesture)
//        self.circle.addGestureRecognizer(circlePan)
       
    }
    
//    @objc func circlePanGesture(_ gestureRecognizer: UIPanGestureRecognizer) {
//        print("cp")
//        if(gestureRecognizer.state == .changed){
//            var move = gestureRecognizer.translation(in: gestureRecognizer.view!)
//            self.frame.size.height += move.y
//            circle.center = CGPoint(x: self.frame.size.width/2, y: self.frame.size.height)
//            gestureRecognizer.setTranslation(CGPoint.zero, in: gestureRecognizer.view!)
//        }
//    }
    
    
    @objc func panGesture(_ gestureRecognizer: UIPanGestureRecognizer) {
        let hour = (no23point - no1point)/23
        let minute:Double
        var point: CGPoint
        var p: CGPoint
        var movedCenterPoint: CGPoint
        var movedPoint: CGPoint
        var movedUnderPoint: CGPoint
        var changedheight: Double
        
        var separate:Double = Double(hour/4)

        minute = Double(hour)/Double(60)
        
//        if(gestureRecognizer.state == .began){
//            p = gestureRecognizer.location(in: self)
//            if(p.y >= circle.center.y - circle.frame.size.height/2 && p.y <= circle.center.y + circle.frame.size.height/2){
//                if(p.x >= circle.center.x - circle.frame.size.width/2  && p.x <= circle.center.x + circle.frame.size.width/2){
//                    print("circleIn")
//
//                    flag = 1
//                }else{
//                   flag = 0
//                }
//            }else {
//                flag = 0
//            }
//        }
            
        if(flag == 1){
            //移動量を取得する
            var move = gestureRecognizer.translation(in: self)
            movedCenterPoint = CGPoint(x: gestureRecognizer.view!.center.x + move.x, y: gestureRecognizer.view!.center.y + move.y)
            movedUnderPoint = CGPoint(x: movedCenterPoint.x - self.frame.size.width/2 ,y: movedCenterPoint.y + self.frame.size.height/2)
            if(gestureRecognizer.state == .ended){
                for i in 0..<92 {
                    if(Double(movedUnderPoint.y) > Double(no1point) + Double(hour*i/4) && Double(movedUnderPoint.y) <= Double(no1point) + Double(hour/8) + Double(hour*i/4)){
                        changedheight = Double(hour*i/4)
//                        if(i % 2 != 0){
//                            changedheight += 0.5
//                        }
                        print("center",movedCenterPoint.y,i)
                        print(self.frame.origin)
                    }else if(Double(movedUnderPoint.y) <= Double(no1point) + Double(hour*(i+1)/4) && Double(movedUnderPoint.y) > Double(no1point) + Double(hour/8) + Double(hour*i/4)){
                        changedheight = Double(hour*(i+1)/4)
                        
//                        if(i % 2 == 0){
//                            changedheight += 0.5
//                        }
                        print("center",movedCenterPoint.y)
                        print(self.frame.origin)
                    }
                }
                //self.frame.size.height = self.frame.size.height + CGFloat(changedheight)
            }
            
            self.frame.size.height += move.y
            self.content.frame.size.height += move.y
            if(Double(self.content.frame.size.height) <= 10 * minute && move.y < 0){
                //move.y = 0
                self.frame.size.height = CGFloat(10 * minute + 20)
                self.content.frame.size.height = CGFloat(10 * minute)
                
            }
            
            circle.center = CGPoint(x: self.frame.size.width/2, y: self.content.frame.size.height)
            imageView.center = CGPoint(x: self.frame.size.width/2, y: self.frame.size.height - 10)
            //移動量をリセットする
            gestureRecognizer.setTranslation(CGPoint.zero, in: self)
        }else if(flag == 0){
            point = gestureRecognizer.translation(in: self)
            movedCenterPoint = CGPoint(x: gestureRecognizer.view!.center.x + point.x, y: gestureRecognizer.view!.center.y + point.y)
            movedPoint = CGPoint(x: movedCenterPoint.x - self.frame.size.width/2 ,y: movedCenterPoint.y - self.frame.size.height/2)
            if(gestureRecognizer.state == .changed){
                if(movedCenterPoint.y > (self.superview?.superview?.superview!.frame.size.height)! - 80 && movedCenterPoint.x < 250){
                        print("under")
                        //scrollFlag = true
                        startAutoScroll(duration: 0.05, direction: .under)
//                }else if(location.y < self.superview?.superview?  && location.y > AlldayView.frame.origin.y + dummyAll.constant){
//
//                        print("upper")
//                        //scrollFlag = true
//                        startAutoScroll(duration: 0.05, direction: .upper)
                }
            }
            
            if(gestureRecognizer.state == .ended){
                point = gestureRecognizer.translation(in: self)
                movedCenterPoint = CGPoint(x: gestureRecognizer.view!.center.x + point.x, y: gestureRecognizer.view!.center.y + point.y)
                movedPoint = CGPoint(x: movedCenterPoint.x - self.frame.size.width/2 ,y: movedCenterPoint.y - self.frame.size.height/2)
                location = aTouch.location(in: self)
                //(Double(movedPoint.y) - 30) / separate
                for i in 0..<92 {
                    if(Double(movedPoint.y) > Double(no1point) + Double(hour*i/4) && Double(movedPoint.y) <= Double(no1point) + Double(hour/8) + Double(hour*i/4)){
                        movedCenterPoint.y = CGFloat(Double(no1point) + Double(hour*i/4) + Double(self.frame.size.height)/2)
//                        if(i % 2 != 0){
//                            movedCenterPoint.y += 0.5
//                        }
                        print("center",movedCenterPoint.y,i)
                        print(self.frame.origin)
                    }else if(Double(movedPoint.y) <= Double(no1point) + Double(hour*(i+1)/4) && Double(movedPoint.y) > Double(no1point) + Double(hour/8) + Double(hour*i/4)){
                        movedCenterPoint.y = CGFloat(Double(no1point) + Double(hour*(i+1)/4) + Double(self.frame.size.height)/2)
//                        if(i % 2 == 0){
//                            movedCenterPoint.y += 0.5
//                        }
                        print("center",movedCenterPoint.y)
                        print(self.frame.origin)
                    }
                }
                stopAutoScrollIfNeeded()
            }
            
            gestureRecognizer.view!.center = movedCenterPoint
            gestureRecognizer.setTranslation(CGPoint.zero, in: self)
        }
        getTaskTime()
    }
    
    func getTaskTime(){
        for v in self.subviews {
            // オブジェクトの型がUIImageView型で、タグ番号が1〜5番のオブジェクトを取得する
            if let v = v as? UILabel, v.tag == 100  {
                // そのオブジェクトを親のviewから取り除く
                v.removeFromSuperview()
            }
        }
        let hour = (no23point - no1point)/23
        let minute:Double
        minute = Double(hour)/Double(60)
        
        let format = DateFormatter()
        
        let calendar = Calendar.current
        let date = Date()
        let m = calendar.component(.minute, from: date)
        
        let starttime = Int(round(Double(Double(self.frame.origin.y) - Double(no1point)) / minute)) - m
        //let endtime = Int(round(Double(Int(self.frame.origin.y) + Int(self.frame.size.height) - no1point) / minute)) - m
        //print(starttime)
        let startDate = Calendar.current.date(byAdding: .minute, value: starttime, to: date)!
        //let endDate = Calendar.current.date(byAdding: .minute, value: endtime, to: date)!
        
        format.dateFormat = "HH:mm"
        format.timeZone   = TimeZone(identifier: "Asia/Tokyo")
        startTime.text = format.string(from: startDate)
        //endTime.text = format.string(from: endDate)
        
       // var tasktime = Double(endtime - starttime)
        var tasktime = Double(self.content.frame.size.height) / minute
        let timetext = String(format: "%d:%02d", Int(tasktime/60), Int(tasktime - Double(60*Int(tasktime/60))))
        
        taskTime.text = String(timetext)
    }
    
    var location = CGPoint()
    var flag = 0
    
//    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
//        let touch = touches.first! //このタッチイベントの場合確実に1つ以上タッチ点があるので`!`つけてOKです
//        location = touch.location(in: self) //in: には対象となるビューを入れます
//        //print(location)
//        if(location.y >= self.frame.size.height - 20){
//            print("circleIn")
//            flag = 1
//        }else {
//            flag = 0
//        }
//    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        let touch = touches.first! //このタッチイベントの場合確実に1つ以上タッチ点があるので`!`つけてOKです
        location = touch.location(in: self) //in: には対象となるビューを入れます
        print(location)
//        if(location.y >= self.frame.size.height - 20 && location.x <= self.center.x + radius && location.x >= self.center.x - radius){
//            print("circleIn")
//            flag = 1
//        }else {
//            flag = 0
//        }
        if(location.y >= circle.center.y - circle.frame.size.height/2 && location.y <= circle.center.y + circle.frame.size.height/2){
            if(location.x >= circle.center.x - circle.frame.size.width/2  && location.x <= circle.center.x + circle.frame.size.width/2){
                print("circleIn")
        
                flag = 1
            }else{
                print("circleOut")
                flag = 0
            }
        }else {
            flag = 0
        }
    }

//    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?){
//        let touch = touches.first! //このタッチイベントの場合確実に1つ以上タッチ点があるので`!`つけてOKです
//        location = touch.location(in: self) //in: には対象となるビューを入れます
//        print(location)
//        flag = 0
//    }
    
    var autoScrollTimer = Timer()
    
    func startAutoScroll(duration: TimeInterval, direction: ScrollDirectionType) {
        // 表示されているTableViewのOffsetを取得
        var currentOffsetY = (self.superview?.superview as! UIScrollView).contentOffset.y
        print(currentOffsetY)
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
                let highLimit = (self.superview?.superview as! UIScrollView).contentSize.height - (self.superview?.superview!.bounds.size.height)!
                currentOffsetY = (currentOffsetY + 10 > highLimit) ? highLimit : currentOffsetY + 10
                shouldFinish = currentOffsetY == highLimit
            default: break
            }
            DispatchQueue.main.async {
                UIView.animate(withDuration: duration * 2, animations: {
                    (self.superview?.superview as! UIScrollView).setContentOffset(CGPoint(x: 0, y: currentOffsetY), animated: false)
                }, completion: { _ in
                    if shouldFinish { self.stopAutoScrollIfNeeded() }
                })
            }
        })
    }
    
    // 自動スクロールを停止する
    func stopAutoScrollIfNeeded() {
        //print("------------------------------------------------------")
        if (autoScrollTimer.isValid) {
            print("#######3333333333333333333333333333333333333333333")
            self.superview?.superview!.layer.removeAllAnimations()
            autoScrollTimer.invalidate()
        }
    }
    
    enum ScrollDirectionType {
        case upper, under, left, right
    }
    
   
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
