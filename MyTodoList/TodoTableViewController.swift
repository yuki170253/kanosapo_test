//
//  ViewController.swift
//  MyTodoList
//
//  Created by 古府侑樹 on 2019/06/07.
//  Copyright © 2019 古府侑樹. All rights reserved.
//

import UIKit

class TodoTableViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    var todoList = [MyTodo]()
    @IBOutlet weak var tableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        print("viewDidLoad=TodoTableViewに遷移")
    }
    
    // 画面に表示される直前に呼ばれます。
    // viewDidLoadとは異なり毎回呼び出されます。
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        //保存しているToDoの読み込み処理
        let userDefaults = UserDefaults.standard
        if let storedTodoList = userDefaults.object(forKey: "todoList") as? Data {
            do {
                if let unarchiveTodoList = try NSKeyedUnarchiver.unarchivedObject(ofClasses: [NSArray.self, MyTodo.self], from: storedTodoList) as? [MyTodo] {
                    todoList = unarchiveTodoList
                }
            } catch {
                
            }
        }
        //タスク達成率
        let count: Double = Double(todoList.count)
        let tcount: Double = Double(truecount(array: todoList))
        let rate: Double = tcount/count
        if rate.isNaN { //問題あり
            let str: String = "ToDoリストが設定されていません"
            self.navigationItem.title = str;
        }else {
            let percent: Int = Int(rate * 100)
            let str: String = "ToDoリスト：" + String(percent) + "%達成"
            self.navigationItem.title = str;
        }
        print("viewWillApppear=TodoTableViewに遷移")
    }
    /*
    @IBAction func tapAddButton(_ sender: Any) {
        let alertController = UIAlertController(title: "ToDo追加", message: "ToDoを入力してください",
                                                preferredStyle: UIAlertController.Style.alert)
        //テキストエリアを追加
        alertController.addTextField(configurationHandler: nil)
        let okAction = UIAlertAction(title: "OK", style: UIAlertAction.Style.default) { (action: UIAlertAction) in
            //OKボタンがタップされた時の処理
            if let textField = alertController.textFields?.first{
                let myTodo = MyTodo()
                myTodo.todoTitle = textField.text!
                //ToDoの配列に入力値を挿入。先頭に挿入。
                self.todoList.insert(myTodo, at: 0)
                //テーブルに行が追加されたことをテーブルに通知
                self.tableView.insertRows(at:[IndexPath(row: 0, section: 0)], with: UITableView.RowAnimation.right)
                let userDefaults = UserDefaults.standard
                //Data型にしリアライズする
                do {
                    let data = try NSKeyedArchiver.archivedData(withRootObject: self.todoList, requiringSecureCoding: true)
                    userDefaults.set(data, forKey: "todoList")
                    userDefaults.synchronize()
                } catch {
                    
                }
            }
        }
        //OKボタンがタップされた時の処理
        alertController.addAction(okAction)
        //cancelボタンがタップされた時の処理
        let cancelButton = UIAlertAction(title: "CANCEL", style: UIAlertAction.Style.cancel, handler: nil)
        //cancelボタンを追加
        alertController.addAction(cancelButton)
        //アラートダイアログを表示
        present(alertController, animated: true, completion: nil)
    }//tapAddButtonの処理
    */
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return todoList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "todoCell", for: indexPath)
        //行番号に合ったToDoの情報を取得
        let myTodo = todoList[indexPath.row]
        cell.textLabel?.text = myTodo.todoTitle
        //セルのじチェックマーク状態をセット
        if myTodo.todoDone {
            cell.accessoryType = UITableViewCell.AccessoryType.checkmark
        } else {
            cell.accessoryType = UITableViewCell.AccessoryType.none
        }
        return cell
    }
    
    //セルが選択された時の処理
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // セルの選択を解除
        tableView.deselectRow(at: indexPath, animated: true)
        let myTodo = todoList[indexPath.row]
        myTodo.index = indexPath.row
        performSegue(withIdentifier: "toEditViewController", sender: myTodo)
    }
    //画面遷移の処理
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (segue.identifier == "toEditViewController") {
            let vc = segue.destination as! EditViewController
            // ViewControllerのtextVC2にメッセージを設定
            vc.todoList = sender as! MyTodo
        }
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        //削除処理かどうか
        if editingStyle == UITableViewCell.EditingStyle.delete {
            //ToDoリストから削除
            todoList.remove(at: indexPath.row)
            //セルを削除
            tableView.deleteRows(at: [indexPath], with: UITableView.RowAnimation.fade)
            //データ保存。Data型にシリアライズ
            do {
                let data: Data = try NSKeyedArchiver.archivedData(withRootObject: todoList, requiringSecureCoding: true)
                let userDefaults = UserDefaults.standard
                userDefaults.set(data, forKey: "todoList")
                userDefaults.synchronize()
            } catch {
                
            }
            let count: Double = Double(todoList.count)
            let tcount: Double = Double(truecount(array: todoList))
            let rate: Double = tcount/count
            if rate.isNaN{ //問題あり
                let str: String = "ToDoリストが設定されていません"
                self.navigationItem.title = str;
            }else {
                let percent: Int = Int(rate * 100)
                let str: String = "ToDoリスト：" + String(percent) + "%達成"
                self.navigationItem.title = str;
            }
        }
    }
    
    @IBAction func restart(_ segue: UIStoryboardSegue) {
        loadView()
    }
}





