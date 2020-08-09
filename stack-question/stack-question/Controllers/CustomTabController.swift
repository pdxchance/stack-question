//
//  CustomTabController.swift
//  stack-question
//
//  Created by Deanne Chance on 8/8/20.
//  Copyright © 2020 Deanne Chance. All rights reserved.
//

import UIKit
import CoreData

class CustomTabController: UITabBarController {

    var managedObjectContext: NSManagedObjectContext

    override func viewDidLoad() {
        super.viewDidLoad()

        let vc1 = UINavigationController(rootViewController: QuestionViewController(managedObjectContext: managedObjectContext))
        let vc2 = UINavigationController(rootViewController: GuessesViewController(managedObjectContext: managedObjectContext))
        
        vc1.tabBarItem = UITabBarItem(title: "Questions", image: .none, selectedImage: .none)
        vc2.tabBarItem = UITabBarItem(title: "Guesses", image: .none, selectedImage: .none)


        viewControllers = [vc1, vc2]
    }
    
    init(managedObjectContext : NSManagedObjectContext) {
        self.managedObjectContext = managedObjectContext
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    


}
