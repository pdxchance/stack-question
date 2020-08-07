//
//  QuestionAnswerModel.swift
//  stack-question
//
//  Created by Deanne Chance on 8/7/20.
//  Copyright © 2020 Deanne Chance. All rights reserved.
//

import Foundation

// MARK: - QuestionAnswerModel
struct QuestionAnswerModel: Codable {
    let items: [Question]?
    let hasMore: Bool?
    let quotaMax, quotaRemaining: Int?

    enum CodingKeys: String, CodingKey {
        case items
        case hasMore = "has_more"
        case quotaMax = "quota_max"
        case quotaRemaining = "quota_remaining"
    }
}

// MARK: - Item
struct Question: Codable {
    let tags: [String]?
    let answers: [Answer]?
    let isAnswered: Bool?
    let acceptedAnswerID, answerCount, score, lastActivityDate: Int?
    let creationDate, questionID: Int?
    let title, body: String?

    enum CodingKeys: String, CodingKey {
        case tags, answers
        case isAnswered = "is_answered"
        case acceptedAnswerID = "accepted_answer_id"
        case answerCount = "answer_count"
        case score
        case lastActivityDate = "last_activity_date"
        case creationDate = "creation_date"
        case questionID = "question_id"
        case title, body
    }
}

// MARK: - Answer
struct Answer: Codable {
    let isAccepted: Bool?
    let score, answerID, questionID: Int?
    let body: String?

    enum CodingKeys: String, CodingKey {
        case isAccepted = "is_accepted"
        case score
        case answerID = "answer_id"
        case questionID = "question_id"
        case body
    }
}


