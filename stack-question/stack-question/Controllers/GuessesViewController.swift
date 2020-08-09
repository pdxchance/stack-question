//
//  GuessesViewController.swift
//  stack-question
//
//  Created by Deanne Chance on 8/8/20.
//  Copyright © 2020 Deanne Chance. All rights reserved.
//

import UIKit
import CoreData

class GuessesViewController: UIViewController {
    
    var managedObjectContext: NSManagedObjectContext

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // setup view
        let logo = UIImage(named: "logo.png")
        let imageView = UIImageView(image:logo)
        self.navigationItem.titleView = imageView
        view.backgroundColor = UIColor.QuestionColorTheme.white
        navigationController?.navigationBar.barTintColor = UIColor.QuestionColorTheme.primaryDarkBlue
        navigationController?.navigationBar.setValue(true, forKey: "hidesShadow")
    }
    
    init(managedObjectContext : NSManagedObjectContext) {
        self.managedObjectContext = managedObjectContext
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    



}
