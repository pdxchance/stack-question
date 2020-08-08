//
//  GuessesViewController.swift
//  stack-question
//
//  Created by Deanne Chance on 8/8/20.
//  Copyright © 2020 Deanne Chance. All rights reserved.
//

import UIKit

class GuessesViewController: UIViewController {

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
    



}
