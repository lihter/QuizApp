//
//  Question+CD.swift
//  QuizApp
//
//  Created by Mac Use on 20.05.2021..
//

import CoreData

extension Question {
    
    init(with entity: CDQuestion) {
        id = Int(entity.identifier)
        question = entity.question
        answers = entity.answers
        correctAnswer = Int(entity.correctAnswer)
    }
    
    func populate(_ entity: CDQuestion) {
        entity.identifier = Int32(id)
        entity.question = question
        entity.answers = answers
        entity.correctAnswer = Int16(correctAnswer)
    }
}
