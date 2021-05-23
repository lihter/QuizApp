//
//  ResultModel.swift
//  QuizApp
//
//  Created by Mac Use on 14.05.2021..
//

struct ResultModel: Codable {
    
    enum CodingKeys: String, CodingKey {
        case quizId = "quiz_id"
        case userId = "user_id"
        case time
        case noOfCorrect = "no_of_correct"
    }

    let quizId: Int
    let userId: Int
    let time: Double
    let noOfCorrect: Int

}
