//
//  HomeViewController.swift
//  MyTodoList
//
//  Created by 古府侑樹 on 2019/06/19.
//  Copyright © 2019 古府侑樹. All rights reserved.
//

import UIKit
import YYBottomSheet
class HomeViewController: UIViewController {
    var todoListArray = [MyTodo]()
    override func viewDidLoad() { //切り替えても呼び出されない...
        super.viewDidLoad()
        print("homeviewに遷移")
        // Do any additional setup after loading the view.
    }
    
    @IBAction func TableShowButton(_ sender: Any) {
        let userDefaults = UserDefaults.standard
        if let storedTodoList = userDefaults.object(forKey: "todoList") as? Data {
            do {
                if let unarchiveTodoList = try NSKeyedUnarchiver.unarchivedObject(ofClasses: [NSArray.self, MyTodo.self], from: storedTodoList) as? [MyTodo] {
                    todoListArray = unarchiveTodoList
                }
            } catch {
                
            }
        }
        let title = "ToDoリスト"
        let dataArray = arrayTitle(array: todoListArray)
        let bottomUpTable = YYBottomSheet.init(bottomUpTableTitle: title, dataArray: dataArray, options: nil) { (cell) in
            print(cell.indexPath[1])
            let myTodo = self.todoListArray[cell.indexPath[1]]
            print("todoTitle"+myTodo.todoTitle!)
            print("donetime="+String(myTodo.donetime))
            myTodo.index = cell.indexPath[1]
            self.performSegue(withIdentifier: "toEvaluViewController", sender: myTodo)
        }
        print("データ数")
        print(todoListArray.count)
        bottomUpTable.show()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (segue.identifier == "toEvaluViewController") {
            let vc = segue.destination as! EvaluViewController
            // ViewControllerのtextVC2にメッセージを設定
            vc.myTodo = sender as! MyTodo
        }
    }
    @IBAction func restart(_ segue: UIStoryboardSegue) {
        loadView()
    }
}
