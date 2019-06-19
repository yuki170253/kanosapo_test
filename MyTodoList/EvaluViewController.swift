//
//  EvaluViewController.swift
//  MyTodoList
//
//  Created by 古府侑樹 on 2019/06/19.
//  Copyright © 2019 古府侑樹. All rights reserved.
//

import UIKit

class EvaluViewController: UIViewController {
    var myTodo = MyTodo()
    @IBOutlet weak var testlabel: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
        testlabel.text = myTodo.todoTitle
        // Do any additional setup after loading the view.
    }
}
