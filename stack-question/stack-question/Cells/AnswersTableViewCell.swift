//
//  AnswersTableViewCell.swift
//  stack-question
//
//  Created by Deanne Chance on 8/7/20.
//  Copyright © 2020 Deanne Chance. All rights reserved.
//

import UIKit

class AnswerTableViewCell: UITableViewCell {
    
    weak var delegate : ScoreAndSaveProtocol?
    
    let titleLabel: UILabel = {
        let titleLabel = UILabel()
        titleLabel.numberOfLines = 0
        titleLabel.lineBreakMode = .byWordWrapping
        titleLabel.font = UIFont(name: "Lato-Bold", size: 32.0)
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        
        return titleLabel
    }()
    
    let answerStackView : UIStackView = {
        let answerStackView = UIStackView()
        answerStackView.axis = .vertical
        answerStackView.distribution = .fill
        answerStackView.spacing = 3
        answerStackView.translatesAutoresizingMaskIntoConstraints = false
        
        return answerStackView
    }()
    
    let answerLabel: UILabel = {
        let answerLabel = UILabel()
        answerLabel.numberOfLines = 0
        answerLabel.lineBreakMode = .byWordWrapping
        answerLabel.translatesAutoresizingMaskIntoConstraints = false
        
        return answerLabel
    }()
    
    let answersButton : UIButton = {
       let answersButton = UIButton()
        answersButton.backgroundColor = UIColor.QuestionColorTheme.primaryOrange
        answersButton.setTitle("Pick this answer", for: .normal)
        answersButton.titleLabel?.font = UIFont(name: "Lato-Regular", size: 18)
        answersButton.setTitleColor(UIColor.QuestionColorTheme.white, for: .normal)
        answersButton.layer.cornerRadius = 4
        answersButton.translatesAutoresizingMaskIntoConstraints = false
        
        return answersButton
    }()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        
        super.init(style: style, reuseIdentifier: reuseIdentifier)
                
        answersButton.addTarget(self, action: #selector(scoreAndSaveAnswer), for: .touchUpInside)
        
        selectionStyle = .none

        addSubview(titleLabel)
        addSubview(answerStackView)
        answerStackView.addArrangedSubview(answerLabel)
        answerStackView.addArrangedSubview(answersButton)
        
        
        titleLabel.anchor(top: self.topAnchor, bottom: nil, leading: self.leadingAnchor, trailing: self.trailingAnchor)
        
        answerStackView.anchor(top: titleLabel.bottomAnchor, bottom: self.bottomAnchor, leading: self.leadingAnchor, trailing: self.trailingAnchor, padding: .init(top: 0, left: 0, bottom: 30, right: 0))

    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func hitTest(_ point: CGPoint, with event: UIEvent?) -> UIView? {

         guard isUserInteractionEnabled else { return nil }

         guard !isHidden else { return nil }

         guard alpha >= 0.01 else { return nil }

         guard self.point(inside: point, with: event) else { return nil }


         if self.answersButton.point(inside: convert(point, to: answersButton), with: event) {
             return self.answersButton
         }

         return super.hitTest(point, with: event)
     }
    
    @objc func scoreAndSaveAnswer() {
        if delegate?.responds(to: #selector(self.scoreAndSaveAnswer)) != nil {
            delegate?.scoreAndSaveAnswer(sender: answersButton)
        }
    }

}
