//
//  GuessesTableViewCell.swift
//  stack-question
//
//  Created by Deanne Chance on 8/9/20.
//  Copyright © 2020 Deanne Chance. All rights reserved.
//

import UIKit

class GuessesTableViewCell: UITableViewCell {
    
    
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
    
    let answerLabel: UILabel = {
        let answerLabel = UILabel()
        answerLabel.numberOfLines = 0
        answerLabel.lineBreakMode = .byWordWrapping
        answerLabel.translatesAutoresizingMaskIntoConstraints = false
        
        return answerLabel
    }()
    
    let correctLabel: UILabel = {
        let correctLabel = UILabel()
        correctLabel.numberOfLines = 0
        correctLabel.backgroundColor = UIColor.QuestionColorTheme.primaryOrange
        correctLabel.lineBreakMode = .byWordWrapping
        correctLabel.translatesAutoresizingMaskIntoConstraints = false
        
        return correctLabel
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        

        addSubview(questionStackView)
        questionStackView.addArrangedSubview(titleLabel)
        questionStackView.addArrangedSubview(answerLabel)
        questionStackView.addArrangedSubview(correctLabel)
        
        questionStackView.anchor(top: self.topAnchor, bottom: self.bottomAnchor, leading: self.leadingAnchor, trailing: self.trailingAnchor, padding: .init(top: 0, left: 0, bottom: 30, right: 0))

    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

