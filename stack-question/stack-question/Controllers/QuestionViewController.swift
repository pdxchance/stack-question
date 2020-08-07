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

class QuestionViewController: UIViewController {
    
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
        scoreLabel.textAlignment = .center
        scoreLabel.textColor = UIColor.QuestionColorTheme.primaryDarkBlue
        scoreLabel.translatesAutoresizingMaskIntoConstraints = false
        
        return scoreLabel
    }()
    
    let searchTextField : UITextField = {
       let searchTextField = UITextField()
        searchTextField.placeholder = "Filter questions by topic e.g. Swift"
        searchTextField.text = "swift"
        searchTextField.autocorrectionType = .no
        searchTextField.autocapitalizationType = .none
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
        
        view.backgroundColor = UIColor.QuestionColorTheme.white
        
        // Style the nav bar
        navigationController?.navigationBar.barTintColor = UIColor.QuestionColorTheme.primaryDarkBlue
        navigationController?.navigationBar.setValue(true, forKey: "hidesShadow")
        
        view.addSubview(scoreLabel)
        view.addSubview(searchTextField)
        view.addSubview(questionTableView)
        
        searchTextField.delegate = self
        
        navigationItem.title = "StackQuestion"
        
        questionTableView.refreshControl = refreshControl
        questionTableView.separatorStyle = .none
        questionTableView.register(QuestionAnswerTableViewCell.self, forCellReuseIdentifier: reuseID)
        questionTableView.delegate = self
        questionTableView.dataSource = self
        
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        view.addGestureRecognizer(tap)
        view.isUserInteractionEnabled = true
        
        let guide = self.view.safeAreaLayoutGuide
        
        scoreLabel.anchor(top: guide.topAnchor , bottom: nil, leading: view.leadingAnchor, trailing: view.trailingAnchor)
        
        searchTextField.anchor(top: scoreLabel.bottomAnchor, bottom: nil, leading: view.leadingAnchor, trailing: view.trailingAnchor)
        
        questionTableView.anchor(top: searchTextField.bottomAnchor, bottom: view.bottomAnchor, leading: view.leadingAnchor, trailing: view.trailingAnchor)
        
        loadData()
    }
    
    @objc func loadData() {
        
        let query = "&tagged=" + searchTextField.text!
        let url = baseURL + searchFilter + query
                
        requestGET(url, params: nil, success: { [weak self ] (jsonData) in
            
            self?.data = nil
            self?.data = try? JSONDecoder().decode(QuestionAnswerModel.self, from: jsonData
            )
            
            DispatchQueue.main.async {
                self?.refreshControl.endRefreshing()
                self?.questionTableView.reloadData()
            }
            
        }) { (error) in
            Loaf.init("Sorry an error occured", sender: self).show()
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
        
        let question = data?.items?[sender.tag]
        
        let controller = AnswerViewController()
        controller.question = question
        controller.delegate = self
        navigationController?.pushViewController(controller, animated: true)
    }
}

extension QuestionViewController : UpdateScoreAndSaveProtocol {
    func updateScoreAndSave(score: Int, question: Question, selectedAnswer: Answer) {
        
        //update the score
        self.score += score
        scoreLabel.text = "Score: " + String(self.score)
        
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
