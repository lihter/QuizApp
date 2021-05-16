//
//  DataCoordinator.swift
//  QuizApp
//
//  Created by Mac Use on 05.05.2021..
//

import Foundation
import UIKit

protocol DataCoordinatorProtocol {
    func getUsername() -> String
    func logout()
    func setQuiz(_ quiz: Quiz)
    func getQuiz() -> Quiz
    
    func resetQuizTrackingVariables()
    func addTime(_ time: Double)
    func getTime() -> Double
    func isAnswered(correct add: Bool)
    func numberOfQuestions() -> Int
    func getQuestionTrackArray() -> [Bool]
}

class DataCoordinator: DataCoordinatorProtocol {
    //MARK: - Coordinator vars
    private let navigationController: UINavigationController!
    private var mainCoordinator: MainCoordinator!
    private let networkService: NetworkServiceProtocol!
    private var quiz: Quiz!
    
    //MARK: - Code
    init(navigationController: UINavigationController, mainCoordinator: MainCoordinator) {
        self.navigationController = navigationController
        self.mainCoordinator = mainCoordinator
        self.networkService = NetworkService()
    }
    
    //MARK: - Functions
    func getUsername() -> String {        
        //sad ću predpostaviti da je username jednak prefixu emaila korisnika
        //Dvije opcije username-a su: ako email unesen na login screenu ima znak @ u sebi, onda je username sve prjie tog znaka, a ako nema znaka @ u unesenom emailu, onda je username cijeli taj email string
        let str = UserDefaults.standard.string(forKey: "Username")!
        let username = str[..<(str.firstIndex(of: "@") ?? str.endIndex)]
        return String(username)
    }
    
    func logout() {
        UserDefaults.standard.set(nil, forKey: "Token")
        UserDefaults.standard.set(nil, forKey: "UserID")
        UserDefaults.standard.set(nil, forKey: "Username")
    }
    
    func setQuiz(_ quiz: Quiz) {
        self.quiz = quiz
    }
    
    func getQuiz() -> Quiz {
        return quiz
    }
        
    func resetQuizTrackingVariables() {
        QuizTemporaryVariables.currentQuestionId = 0
        QuizTemporaryVariables.correctQuestions = []
        QuizTemporaryVariables.timeSpentSolvingQuiz = 0
    }
    
    func isAnswered(correct add: Bool) {
        QuizTemporaryVariables.correctQuestions.append(add)
    }
    
    func numberOfQuestions() -> Int {
        return quiz.questions.count
    }
    
    func getQuestionTrackArray() -> [Bool] {
        return QuizTemporaryVariables.correctQuestions
    }
    
    func addTime(_ time: Double) {
        QuizTemporaryVariables.timeSpentSolvingQuiz += time
    }
    
    func getTime() -> Double {
        return QuizTemporaryVariables.timeSpentSolvingQuiz
    }
}

