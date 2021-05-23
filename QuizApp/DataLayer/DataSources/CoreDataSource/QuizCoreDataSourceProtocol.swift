//
//  QuizCoreDataSourceProtocol.swift
//  QuizApp
//
//  Created by Mac Use on 20.05.2021..
//

protocol QuizCoreDataSourceProtocol {
    func fetchQuizzesFromCoreData(filter: FilterSettings) -> [Quiz]
    func saveNewQuizzes(_ quizzes: [Quiz])
    func deleteQuiz(withId id: Int)
}
