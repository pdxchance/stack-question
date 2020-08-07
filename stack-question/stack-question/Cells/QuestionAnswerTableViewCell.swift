//
//  QuestionAnswerTableViewCell.swift
//  stack-question
//
//  Created by Deanne Chance on 8/7/20.
//  Copyright © 2020 Deanne Chance. All rights reserved.
//

import UIKit

class QuestionAnswerTableViewCell: UITableViewCell {
    
    weak var delegate : LoadControllerProtocol?
    
    let questionStackView : UIStackView = {
        let questionStackView = UIStackView()
        questionStackView.axis = .vertical
        questionStackView.distribution = .fill
        questionStackView.spacing = 3
        questionStackView.translatesAutoresizingMaskIntoConstraints = false
        
        return questionStackView
    }()
    
    let titleLabel: UILabel = {
        let titleLabel = UILabel()
        titleLabel.numberOfLines = 0
        titleLabel.lineBreakMode = .byWordWrapping
        titleLabel.font = UIFont(name: "Lato-Bold", size: 32.0)
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        
        return titleLabel
    }()
    
    let bodyLabel: UILabel = {
        let bodyLabel = UILabel()
        bodyLabel.numberOfLines = 0
        bodyLabel.lineBreakMode = .byWordWrapping
        bodyLabel.translatesAutoresizingMaskIntoConstraints = false
        
        return bodyLabel
    }()
    
    let answersButton : UIButton = {
       let answersButton = UIButton()
        answersButton.backgroundColor = UIColor.QuestionColorTheme.primaryOrange
        answersButton.setTitle("Reveal Answers", for: .normal)
        answersButton.titleLabel?.font = UIFont(name: "Lato-Regular", size: 18)
        answersButton.setTitleColor(UIColor.QuestionColorTheme.white, for: .normal)
        answersButton.layer.cornerRadius = 4
        answersButton.translatesAutoresizingMaskIntoConstraints = false
        
        return answersButton
    }()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        answersButton.addTarget(self, action: #selector(revealAnswers), for: .touchUpInside)

        addSubview(questionStackView)
        questionStackView.addArrangedSubview(titleLabel)
        questionStackView.addArrangedSubview(bodyLabel)
        questionStackView.addArrangedSubview(answersButton)
        
        questionStackView.anchor(top: self.topAnchor, bottom: self.bottomAnchor, leading: self.leadingAnchor, trailing: self.trailingAnchor, padding: .init(top: 0, left: 0, bottom: 30, right: 0))

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
    
    @objc func revealAnswers() {
         if delegate?.responds(to: "loadAnswersController") != nil {
            delegate?.loadAnswersController(sender: answersButton)
        }
    }

}
