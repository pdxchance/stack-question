//
//  CustomTabController.swift
//  stack-question
//
//  Created by Deanne Chance on 8/8/20.
//  Copyright © 2020 Deanne Chance. All rights reserved.
//

import UIKit

class CustomTabController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        let vc1 = UINavigationController(rootViewController: QuestionViewController())
        let vc2 = UINavigationController(rootViewController: GuessesViewController())
        
        vc1.tabBarItem = UITabBarItem(title: "Questions", image: .none, selectedImage: .none)
        vc2.tabBarItem = UITabBarItem(title: "Guesses", image: .none, selectedImage: .none)


        viewControllers = [vc1, vc2]
    }
    


}
