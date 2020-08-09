//
//  AnswerViewController.swift
//  stack-question
//
//  Created by Deanne Chance on 8/7/20.
//  Copyright © 2020 Deanne Chance. All rights reserved.
//

import UIKit
import Loaf

class AnswerViewController: UIViewController {
    
    weak var delegate : UpdateScoreBoardAndSaveProtocol?
    
    let reuseID = "reuseID"

    var question: Question?
    
    let answerTableView : UITableView = {
        let answerTableView = UITableView()
        answerTableView.translatesAutoresizingMaskIntoConstraints = false
        
        return answerTableView
    }()
    
    init(question: Question, delegate : UpdateScoreBoardAndSaveProtocol) {
        self.question = question
        self.delegate = delegate
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // config initial view
        view.backgroundColor = UIColor.QuestionColorTheme.white
                
        // configure tableView
        answerTableView.separatorStyle = .none
        answerTableView.register(AnswerTableViewCell.self, forCellReuseIdentifier: reuseID)
        answerTableView.delegate = self
        answerTableView.dataSource = self
        
        // add subviews and constraints
        view.addSubview(answerTableView)
        answerTableView.anchor(top: view.topAnchor, bottom: view.bottomAnchor, leading: view.leadingAnchor, trailing: view.trailingAnchor)
        
        // refresh
        answerTableView.reloadData()
    }

}

extension AnswerViewController : UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return question?.answers?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: reuseID, for: indexPath) as! AnswerTableViewCell
        
        let answer = question?.answers?[indexPath.row]
        
        cell.delegate = self
        cell.answersButton.tag = indexPath.row
        
        cell.titleLabel.text = question?.title
        cell.answerLabel.text = answer?.body?.htmlToString
        
        
        return cell
    }
}

extension AnswerViewController : ScoreAndSaveProtocol{
    @objc func scoreAndSaveAnswer(sender : UIButton) {
        
        // unwrap
        guard let question = self.question else {
            return
        }
        
        guard let selectedAnswer =  question.answers?[sender.tag] else {
            return
        }

        // used to compute the score
        var score = 0
        
        // guard against multiple answers
        answerTableView.isUserInteractionEnabled = false
        
        //get indexPath for selected answer
        let index = IndexPath(row: sender.tag, section: 0)
        
        //verify the answer
        let pickedAnswer = question.answers?[index.row].answerID
        let correctAnswer = question.acceptedAnswerID
        
        // find the correct answer
        let answer = question.answers?.first(where: { (selected) -> Bool in
            selected.answerID == correctAnswer
        })
                
                        
        if pickedAnswer != correctAnswer {
            score = -1
            
            let alert = UIAlertController(title: "Incorrect!\nAnswer Shown", message: answer?.body?.htmlToString, preferredStyle: .alert)
            let alertAction = UIAlertAction(title: "Ok", style: .default) { (action) in
                self.navigationController?.popViewController(animated: true)

                self.delegate?.updateScoreBoardAndSave(score: score, question: question, selectedAnswer: selectedAnswer)
            }
            alert.addAction(alertAction)
            present(alert, animated: true)
            
        } else {
            let votes = question.answers?[sender.tag].score ?? 1
            score = votes

            let alert = UIAlertController(title: "Correct!", message: "You scored some points!", preferredStyle: .alert)
            let alertAction = UIAlertAction(title: "Ok", style: .default) { (action) in
                self.navigationController?.popViewController(animated: true)

                self.delegate?.updateScoreBoardAndSave(score: score, question: question, selectedAnswer: selectedAnswer)
            }
            alert.addAction(alertAction)
            present(alert, animated: true)
            
            }
        }
    }

