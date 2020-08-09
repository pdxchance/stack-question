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
    
    let reuseID = "reuseID"
    
    var managedObjectContext: NSManagedObjectContext
    
    var guesses : [GuessesModel] = []
    
    let guessesTableView : UITableView = {
        let guessesTableView = UITableView()
        guessesTableView.translatesAutoresizingMaskIntoConstraints = false
        
        return guessesTableView
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // setup view
        let logo = UIImage(named: "logo.png")
        let imageView = UIImageView(image:logo)
        self.navigationItem.titleView = imageView
        view.backgroundColor = UIColor.QuestionColorTheme.white
        navigationController?.navigationBar.barTintColor = UIColor.QuestionColorTheme.primaryDarkBlue
        navigationController?.navigationBar.setValue(true, forKey: "hidesShadow")
        
        guessesTableView.separatorStyle = .none
        guessesTableView.register(GuessesTableViewCell.self, forCellReuseIdentifier: reuseID)
        guessesTableView.delegate = self
        guessesTableView.dataSource = self
        
        view.addSubview(guessesTableView)
        
        let guide = self.view.safeAreaLayoutGuide
        guessesTableView.anchor(top: guide.topAnchor, bottom: guide.bottomAnchor , leading: view.leadingAnchor, trailing: view.trailingAnchor)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        guesses = []
        loadData()
        guessesTableView.reloadData()
    }
    
    init(managedObjectContext : NSManagedObjectContext) {
        self.managedObjectContext = managedObjectContext
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension GuessesViewController {
    func loadData() {
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Guesses")
        
        do {
            let result = try managedObjectContext.fetch(fetchRequest)
            
            for data in result as! [NSManagedObject] {
                let title = data.value(forKey: "questionTitle")
                let body = data.value(forKey: "questionBody")
                let answer = data.value(forKey: "questionAnswer")
                let answeredCorrectly = data.value(forKey: "questionAnswerCorrect")
                
                let node = GuessesModel(guessTitle: title as! String, guessBody: body as! String, guessAnswer: answer as! String, guessCorrect: (answeredCorrectly != nil))
                
                guesses.append(node)
            }
            

        } catch  {
            print("Failed to fetch guesses")
        }
    }
}

extension GuessesViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return guesses.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: reuseID, for: indexPath) as! GuessesTableViewCell
        
        let guess = guesses[indexPath.row]
        
        cell.selectionStyle = .none
        cell.titleLabel.text = guess.guessTitle
        cell.answerLabel.text = guess.guessAnswer
        
        if guess.guessCorrect {
            cell.correctLabel.text = "You answered correctly"
        } else {
            cell.correctLabel.text = "You answered incorrectly"
        }
        
        return cell
    }
    
    
}
