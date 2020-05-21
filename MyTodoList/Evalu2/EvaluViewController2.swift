//
//  EvaluViewController2.swift
//  MyTodoList
//
//  Created by 古府侑樹 on 2019/11/15.
//  Copyright © 2019 古府侑樹. All rights reserved.
//

import UIKit
import Cosmos
import RealmSwift
class EvaluViewController2: UIViewController {
    var index: Int = 0
    var countNum: Int = 0
    var todoListArray: [MyTodo] = []
    var myTodo: MyTodo?
    var todoid :String = ""
    let realm = try! Realm()
    @IBOutlet weak var save_button: UIButton!
    @IBOutlet weak var check_button: UIButton!
    @IBOutlet weak var slideview: CosmosView!
    @IBOutlet weak var save_label: UILabel!
    @IBOutlet weak var check_label: UILabel!
    @IBOutlet weak var speech_label: UILabel!
    @IBOutlet weak var cant_label: UILabel!
    @IBOutlet weak var can_label: UILabel!
    @IBOutlet weak var menherakanojo: UIImageView!

    var speech_flag = false
    var animationTimer: Timer?
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.7)
        speech_label.text = ""
        self.animationTimer = Timer.scheduledTimer(timeInterval: 0.5, target: self, selector: #selector(self.animate), userInfo: nil, repeats: true)
    }
    
    @objc func animate() {
        UIView.animate(withDuration: 0.5) {
            if self.menherakanojo.frame.origin.y == 135.0 {
                   self.menherakanojo.frame.origin.y += 10
            } else {
                   self.menherakanojo.frame.origin.y = 135.0
            }
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        presentingViewController?.endAppearanceTransition()
        speech_label.numberOfLines = 3;
        speech_label.text = "集中はできたかな？\n現状までのタスクの達\n成度を教えてね♡"
        //animated_label(text: "集中はできたかな？\n現状までのタスクの達\n成度を教えてね♡")
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        presentingViewController?.beginAppearanceTransition(true, animated: animated)
        presentingViewController?.endAppearanceTransition()
    }

    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
    }
    override func viewWillAppear(_ animated: Bool) {
        presentingViewController?.beginAppearanceTransition(false, animated: animated)
        super.viewWillAppear(animated)
        /*
        if let presented = self.presentedViewController {
            if type(of: presented) == ResultViewController.self {
                print(type(of: presented))
                dismiss(animated: false, completion: {
                })
                //let parentVC = self.presentingViewController as! EvaluViewController
                //parentVC.navigationController?.popToRootViewController(animated: false)
            }
        }
 */
    }
    
    
    @IBAction func returnbutton(_ sender: Any) {
        self.animationTimer?.invalidate()
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func evalu_button(_ sender: UIButton) {
        //self.speech_flag = true
        save_button.isHidden = false
        check_button.isHidden = false
        sender.isHidden = true
        slideview.isHidden = true
        save_label.isHidden = false
        check_label.isHidden = false
        cant_label.isHidden = true
        can_label.isHidden = true
        speech_label.numberOfLines = 2;
        speech_label.text = "タスクは全部終わったかな？\n教えて教えて〜♡"
        //animated_label(text: "タスクは全部終わったかな？\n教えて教えて〜♡")
    }
    
    @IBAction func save(_ sender: Any) {
        self.speech_flag = true
        //RunLoop.current.run(until: Date()+0.1)
        var rating :Double = slideview.rating
        switch rating {
            case 1.0:
                rating = 0.25
            case 2.0:
                rating = 0.5
            case 3.0:
                rating = 0.75
            case 4.0:
                rating = 1.0
        default:
            rating = 0
        }
        let result = realm.object(ofType: Todo.self, forPrimaryKey: "\(todoid)")
        try! realm.write {
            var donetime :Int = result!.donetime
            let countNum2: Double = Double(countNum)
            donetime += Int(countNum2 * rating)
            result!.donetime = donetime
        }
        
        self.animationTimer?.invalidate()
        let navigationVc = self.presentingViewController as! UINavigationController
        let evaluVC = navigationVc.viewControllers[1] as? EvaluViewController
        evaluVC?.trans()
        dismiss(animated: false, completion: {
        })
    }
    
    @IBAction func check(_ sender: UIButton) {
        var rating :Double = slideview.rating
        switch rating {
            case 1.0:
                rating = 0.25
            case 2.0:
                rating = 0.5
            case 3.0:
                rating = 0.75
            case 4.0:
                rating = 1.0
        default:
            rating = 0
        }
        let result = realm.object(ofType: Todo.self, forPrimaryKey: "\(todoid)")
        try! realm.write {
            var donetime :Int = result!.donetime
            let countNum2: Double = Double(countNum)
            donetime += Int(countNum2 * rating)
            result!.donetime = donetime
            result!.todoDone = true
        }
        
        //画面遷移の処理 以下
        self.animationTimer?.invalidate()
        let navigationVc = self.presentingViewController as! UINavigationController
        let evaluVC = navigationVc.viewControllers[1] as? EvaluViewController
        evaluVC?.trans()
        dismiss(animated: false, completion: {
        })
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (segue.identifier == "toResultView") {
            let vc = segue.destination as! ResultViewController
            if let unmyTodo = myTodo{
                vc.myTodo = unmyTodo
            }else{
                print("myTodoがありません。")
            }
        }
    }
    
    func animated_label(text: String){
        speech_label.text = ""
        self.speech_flag = false //２つ目のセリフが終わった時に１つ目のセリフが途中から始まってしまうのでflagで制御
        for char in text{
            speech_label.text! += "\(char)"
            if self.speech_flag {
                //speech_label.text = ""
                print("break")
                break
            }
            RunLoop.current.run(until: Date()+0.1)
        }
        self.speech_flag = true
    }
}
