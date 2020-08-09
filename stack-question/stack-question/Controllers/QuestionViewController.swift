//
//  QuestionViewController.swift
//  stack-question
//
//  Created by Deanne Chance on 8/6/20.
//  Copyright © 2020 Deanne Chance. All rights reserved.
//

import UIKit
import Alamofire
import Loaf
import CoreData

class QuestionViewController: UIViewController {
    
    var managedObjectContext: NSManagedObjectContext
    
    let reuseID = "reuseID"
    
    var data: QuestionAnswerModel?
    
    var score = 0
    
    var query = "Swift"
    
    let refreshControl : UIRefreshControl = {
       let refreshControl = UIRefreshControl()
        refreshControl.tintColor = UIColor.QuestionColorTheme.primaryOrange
        refreshControl.addTarget(self, action: #selector(loadData), for: .valueChanged)
        return refreshControl
    }()
    
    let scoreLabel: UILabel = {
        let scoreLabel = UILabel()
        scoreLabel.text = "Score : 0"
        scoreLabel.font = UIFont(name: "Lato-Bold", size: 32.0)
        scoreLabel.textAlignment = .center
        scoreLabel.textColor = UIColor.QuestionColorTheme.primaryDarkBlue
        scoreLabel.translatesAutoresizingMaskIntoConstraints = false
        
        return scoreLabel
    }()
    
    let searchTextField : UITextField = {
       let searchTextField = UITextField()
        searchTextField.placeholder = "Filter questions by topic e.g. Swift"
        searchTextField.text = "swift"
        searchTextField.font = UIFont(name: "Lato-Regular", size: 32.0)
        searchTextField.autocorrectionType = .no
        searchTextField.autocapitalizationType = .none
        searchTextField.textAlignment = .center
        searchTextField.backgroundColor = UIColor.QuestionColorTheme.white
        searchTextField.borderStyle = .roundedRect
        searchTextField.translatesAutoresizingMaskIntoConstraints = false
        
        return searchTextField
    }()
    
    let questionTableView : UITableView = {
        let questionTableView = UITableView()
        questionTableView.translatesAutoresizingMaskIntoConstraints = false
        
        return questionTableView
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
        
        // for queries
        searchTextField.delegate = self
                
        // style the question table
        questionTableView.refreshControl = refreshControl
        questionTableView.separatorStyle = .none
        questionTableView.register(QuestionAnswerTableViewCell.self, forCellReuseIdentifier: reuseID)
        questionTableView.delegate = self
        questionTableView.dataSource = self
        
        // used to dismiss keyboard on query
        let tap = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        view.addGestureRecognizer(tap)
        view.isUserInteractionEnabled = true
        
        // add views and set constraints
        view.addSubview(scoreLabel)
        view.addSubview(searchTextField)
        view.addSubview(questionTableView)
        
        let guide = self.view.safeAreaLayoutGuide
        scoreLabel.anchor(top: guide.topAnchor , bottom: nil, leading: view.leadingAnchor, trailing: view.trailingAnchor)
        
        searchTextField.anchor(top: scoreLabel.bottomAnchor, bottom: nil, leading: view.leadingAnchor, trailing: view.trailingAnchor)
        
        questionTableView.anchor(top: searchTextField.bottomAnchor, bottom: view.bottomAnchor, leading: view.leadingAnchor, trailing: view.trailingAnchor)
        
        //intial grab of data
        loadData()
    }
    
    init(managedObjectContext : NSManagedObjectContext) {
        self.managedObjectContext = managedObjectContext
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc func loadData() {
        
        //set up search query, filter is baked in the API, see docs
        let searchText = searchTextField.text ?? ""
        
        let query = "&tagged=" + searchText
        let url = baseURL + searchFilter + query
                
        requestGET(url, params: nil, success: { [weak self ] (jsonData) in
            
            // reset results
            self?.data = nil
            
            // decode payload
            self?.data = try? JSONDecoder().decode(QuestionAnswerModel.self, from: jsonData
            )
            
            // update UI
            DispatchQueue.main.async {
                self?.refreshControl.endRefreshing()
                self?.questionTableView.reloadData()
            }
            
        }) { (error) in
            self.refreshControl.endRefreshing()
            Loaf.init("Sorry an error occured", state: .error, location: .top, presentingDirection: .vertical, dismissingDirection: .vertical, sender: self).show()
        }
    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }

}

extension QuestionViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        data?.items?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: reuseID, for: indexPath) as! QuestionAnswerTableViewCell
        
        let question = self.data?.items?[indexPath.row]

        cell.delegate = self
        
        //for convience, storing the current question index with the button on the tag param
        cell.answersButton.tag = indexPath.row
        cell.selectionStyle = .none
        cell.titleLabel.text = question?.title?.htmlToString
        cell.bodyLabel.text = question?.body?.htmlToString
        
        return cell
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
}

extension QuestionViewController : LoadControllerProtocol {
    func loadAnswersController(sender: UIButton) {
        
        // current question is stored on the tag param when cell is loaded
        guard let question = data?.items?[sender.tag] else {
            return
        }
        
        //inject the controller and load
        let controller = AnswerViewController(question: question, delegate: self)
        navigationController?.pushViewController(controller, animated: true)
    }
}

extension QuestionViewController : UpdateScoreBoardAndSaveProtocol {
    func updateScoreBoardAndSave(score: Int, question: Question, selectedAnswer: Answer) {
        
        //remove answered questions but kinda pointless because a reload could bring it back
        if let array = data?.items {
            if let offset = array.firstIndex(where: {$0.questionID == question.questionID}) {
                data?.items?.remove(at: offset)
                questionTableView.reloadData()
                questionTableView.scrollToRow(at: IndexPath(row: 0, section: 0), at: .top, animated: false)
            }
        }

        //update the score
        self.score += score
        scoreLabel.text = "Score: " + String(self.score)
        
        //save to coredata
        
    }
}

extension QuestionViewController : UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
       loadData()
    }
    
    
}
