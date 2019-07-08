//
//  EditViewController.swift
//  MyTodoList
//
//  Created by 古府侑樹 on 2019/06/10.
//  Copyright © 2019 古府侑樹. All rights reserved.
//

import UIKit

class EditViewController: UIViewController {
    var HoursPickerView: UIPickerView = UIPickerView()
    var MinutesPickerView: UIPickerView = UIPickerView()
    var hours = [Int](0...30)
    var minutes = [Int](0...59)
    @IBOutlet weak var hoursTextField: UITextField!
    @IBOutlet weak var minutesTextField: UITextField!
    var todoList = MyTodo()
    var todoListArray = [MyTodo]()
    @IBOutlet weak var TitleTextField: UITextField!
    @IBOutlet weak var segmentedController: UISegmentedControl!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("EditViewControllerf")
        TitleTextField.text = todoList.todoTitle
        //初期値の設定
        if todoList.todoDone {
            segmentedController.selectedSegmentIndex = 1
        } else {
            segmentedController.selectedSegmentIndex = 0
        }
        let s :Int = todoList.dotime
        let h :Int = s / 3600
        let m :Int = (s % 3600) / 60
        print(h)
        print(m)
        hoursTextField.text = String(h)
        minutesTextField.text = String(m)
        let userDefaults = UserDefaults.standard
        if let storedTodoList = userDefaults.object(forKey: "todoList") as? Data {
            do {
                if let unarchiveTodoList = try NSKeyedUnarchiver.unarchivedObject(ofClasses: [NSArray.self, MyTodo.self], from: storedTodoList) as? [MyTodo] {
                    todoListArray.append(contentsOf: unarchiveTodoList)
                }
            } catch {
                
            }
        }
        HoursPickerView.delegate = self
        HoursPickerView.dataSource = self
        HoursPickerView.showsSelectionIndicator = true
        HoursPickerView.tag = 1
        MinutesPickerView.delegate = self
        MinutesPickerView.dataSource = self
        MinutesPickerView.showsSelectionIndicator = true
        MinutesPickerView.tag = 2
        
        // 決定バーの生成
        let toolbar = UIToolbar(frame: CGRect(x: 0, y: 0, width: view.frame.size.width, height: 35))
        let toolbar2 = UIToolbar(frame: CGRect(x: 0, y: 0, width: view.frame.size.width, height: 35))
        let spacelItem = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: self, action: nil)
        let doneItem = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(done))
        let doneItem2 = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(done2))
        toolbar.setItems([spacelItem, doneItem], animated: true)
        toolbar2.setItems([spacelItem, doneItem2], animated: true)
        
        // インプットビュー設定
        hoursTextField.inputView = HoursPickerView
        hoursTextField.inputAccessoryView = toolbar
        minutesTextField.inputView = MinutesPickerView
        minutesTextField.inputAccessoryView = toolbar2
    }
    
    @objc func done() {
        hoursTextField.endEditing(true)
        hoursTextField.text = "\(hours[HoursPickerView.selectedRow(inComponent: 0)])"
    }
    @objc func done2() {
        minutesTextField.endEditing(true)
        minutesTextField.text = "\(minutes[MinutesPickerView.selectedRow(inComponent: 0)])"
    }
    
    //保存ボタン
    @IBAction func SaveButton(_ sender: Any) {
        print("SaveButtonが押されました。")
        todoList.todoTitle = TitleTextField.text!
        var time :Int = 0
        let h :Int? = Int(hoursTextField.text!)
        let m :Int? = Int(minutesTextField.text!)
        time = (h! * 3600) + (m! * 60)
        todoList.dotime = time
        if let index = todoList.index { //indexは選択された行
            todoListArray[index] = todoList
        }
        let userDefaults = UserDefaults.standard
        do {
            let data = try NSKeyedArchiver.archivedData(withRootObject: self.todoListArray, requiringSecureCoding: true)
            userDefaults.set(data, forKey: "todoList")
            userDefaults.synchronize()
        } catch {
            print("保存できませんでした")
        }
    }
    
    @IBAction func segmentChanged(_ sender: Any) {
        let selectedIndex = segmentedController.selectedSegmentIndex
        if selectedIndex == 0 {
            todoList.todoDone = false
        } else if selectedIndex == 1 {
            todoList.todoDone = true
        }
    }
}

extension EditViewController: UIPickerViewDelegate, UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        // アイテム表示個数を返す
        if pickerView.tag == 1 {
            // 1個目のピッカーの設定
            return hours.count
        }else {
            return minutes.count
        }
    }
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        if pickerView.tag == 1  {
            // 1個目のピッカーの設定
            return String(hours[row])
        }else {
            return String(minutes[row])
        }
    }
}
