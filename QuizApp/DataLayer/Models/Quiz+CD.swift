//
//  Quiz+CD.swift
//  QuizApp
//
//  Created by Mac Use on 20.05.2021..
//

import CoreData

extension Quiz {
    
    init(with entity: CDQuiz) {
        id = Int(entity.identifier)
        title = entity.title
        description = entity.quizDescription
        category = QuizCategory(rawValue: entity.category) ?? QuizCategory.sport
        level = Int(entity.level)
        imageUrl = entity.imageUrl
        questions = entity.questions.map{ Question(with: $0 as! CDQuestion)}
    }
    
    func populate(_ entity: CDQuiz, in context: NSManagedObjectContext) {
        entity.identifier = Int16(id)
        entity.title = title
        entity.quizDescription = description
        entity.category = category.rawValue
        entity.level = Int16(level)
        entity.imageUrl = imageUrl
        var cdQuestions: [CDQuestion] = []
        questions.forEach {
            let cdQuestion = CDQuestion(context: context)
            $0.populate(cdQuestion)
            cdQuestions.append(cdQuestion)
        }
        entity.questions = NSSet(array: cdQuestions)
    }
}
