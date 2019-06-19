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

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    @IBAction func TableShowButton(_ sender: Any) {
        var todoListArray = [MyTodo]()
        let userDefaults = UserDefaults.standard
        if let storedTodoList = userDefaults.object(forKey: "todoList") as? Data {
            do {
                if let unarchiveTodoList = try NSKeyedUnarchiver.unarchivedObject(ofClasses: [NSArray.self, MyTodo.self], from: storedTodoList) as? [MyTodo] {
                    todoListArray.append(contentsOf: unarchiveTodoList)
                }
            } catch {
                
            }
        }
        let title = "Fruits"
        let dataArray = ["apple", "grape", "watermelon", "banana", "strawberry", "cherry", "pineapple", "pear"]
        let bottomUpTable = YYBottomSheet.init(bottomUpTableTitle: title, dataArray: dataArray, options: nil) { (cell) in
            print(cell.indexPath)
            let myTodo = todoListArray[cell.indexPath[0]]
            myTodo.index = cell.indexPath[0]
            self.performSegue(withIdentifier: "toEvaluViewController", sender: myTodo)
        }
        bottomUpTable.show()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (segue.identifier == "toEvaluViewController") {
            let vc = segue.destination as! EvaluViewController
            // ViewControllerのtextVC2にメッセージを設定
            vc.myTodo = sender as! MyTodo
        }
    }
}
