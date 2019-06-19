//
//  EditViewController.swift
//  MyTodoList
//
//  Created by 古府侑樹 on 2019/06/10.
//  Copyright © 2019 古府侑樹. All rights reserved.
//

import UIKit

class EditViewController: UIViewController {
    var todoList = MyTodo()
    var todoListArray = [MyTodo]()
    @IBOutlet weak var TitleTextField: UITextField!
    @IBOutlet weak var segmentedController: UISegmentedControl!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        TitleTextField.text = todoList.todoTitle
        //初期値の設定
        if todoList.todoDone {
            segmentedController.selectedSegmentIndex = 1
        } else {
            segmentedController.selectedSegmentIndex = 0
        }
        let userDefaults = UserDefaults.standard
        if let storedTodoList = userDefaults.object(forKey: "todoList") as? Data {
            do {
                if let unarchiveTodoList = try NSKeyedUnarchiver.unarchivedObject(ofClasses: [NSArray.self, MyTodo.self], from: storedTodoList) as? [MyTodo] {
                    todoListArray.append(contentsOf: unarchiveTodoList)
                }
            } catch {
                
            }
        }
    }
    @IBAction func SaveButton(_ sender: Any) {
        print("SaveButtonが押されました。")
        todoList.todoTitle = TitleTextField.text!
        if let index = todoList.index {
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
