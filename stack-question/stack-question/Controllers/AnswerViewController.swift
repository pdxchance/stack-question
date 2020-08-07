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
    
    weak var delegate : UpdateScoreAndSaveProtocol?
    
    let reuseID = "reuseID"

    var question: Question?
    
    let answerTableView : UITableView = {
        let answerTableView = UITableView()
        answerTableView.translatesAutoresizingMaskIntoConstraints = false
        
        return answerTableView
    }()

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

        // compute the scord
        var score : Int? = 0
        
        // guard against multiple answers
        answerTableView.isUserInteractionEnabled = false
        
        //verify the answer
        let pickedAnswer = question?.answers?[sender.tag].answerID
        let correctAnswer = question?.acceptedAnswerID
                
        if pickedAnswer != correctAnswer {
            score = -1
            
            Loaf.init("Sorry you guessed wrong :( ", state: .custom(.init(backgroundColor: UIColor.red)), location: .top, presentingDirection: .vertical, dismissingDirection: .vertical, sender: self).show(.short) { [weak self]  dismissalType in
                self?.navigationController?.popViewController(animated: true)

                self?.delegate?.updateScoreAndSave(score: score!, question: (self?.question)!, selectedAnswer: (self?.question?.answers?[sender.tag])!)
                }
        } else {
            score = question?.answers?[sender.tag].score

            Loaf.init("Good answer! You earned some points :)", state: .custom(.init(backgroundColor: UIColor.QuestionColorTheme.primaryDarkBlue)), location: .top, presentingDirection: .vertical, dismissingDirection: .vertical, sender: self).show(.short){ [weak self] dismissalType in
                
                self?.navigationController?.popViewController(animated: true)

                self?.delegate?.updateScoreAndSave(score: score!, question: (self?.question)!, selectedAnswer: (self?.question?.answers?[sender.tag])!)
            
            }
        }
    
        
        
    }
}
