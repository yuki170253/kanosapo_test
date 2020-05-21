//
//  TabBarController.swift
//  MyTodoList
//
//  Created by 古府侑樹 on 2019/07/03.
//  Copyright © 2019 古府侑樹. All rights reserved.
//

import UIKit

class TabBarController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()
        for vc in self.viewControllers! {
            _ = vc.view
            print("a")
        }
        // Do any additional setup after loading the view.
    }

}
