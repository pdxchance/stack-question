//
//  UpdateScoreAndSaveProtocol.swift
//  stack-question
//
//  Created by Deanne Chance on 8/7/20.
//  Copyright © 2020 Deanne Chance. All rights reserved.
//

import Foundation

protocol UpdateScoreBoardAndSaveProtocol : NSObjectProtocol {
    func updateScoreBoardAndSave(score: Int, question: Question, selectedAnswer : Answer)
}

