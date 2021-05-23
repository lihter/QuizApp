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
    func getCurrentQuestionId() -> Int
    func setCurrentQuestion(id: Int)
}

class DataCoordinator: DataCoordinatorProtocol {
    //MARK: - Coordinator vars
    private let navigationController: UINavigationController!
    private var mainCoordinator: MainCoordinator!
    private let networkService: NetworkServiceProtocol!
    private var quizzes: [Quiz]!
    private var quiz: Quiz!
    
    var currentQuestionId: Int = 0
    var correctQuestions: [Bool] = []
    var timeSpentSolvingQuiz: Double = 0
    
    //MARK: - Code
    init(navigationController: UINavigationController, mainCoordinator: MainCoordinator) {
        self.navigationController = navigationController
        self.mainCoordinator = mainCoordinator
        self.networkService = NetworkService()
    }
    
    //MARK: - Functions
    func getUsername() -> String {        
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
        currentQuestionId = 0
        correctQuestions = []
        timeSpentSolvingQuiz = 0
    }
    
    func isAnswered(correct add: Bool) {
        correctQuestions.append(add)
    }
    
    func numberOfQuestions() -> Int {
        return quiz.questions.count
    }
    
    func getQuestionTrackArray() -> [Bool] {
        return correctQuestions
    }
    
    func addTime(_ time: Double) {
        timeSpentSolvingQuiz += time
    }
    
    func getTime() -> Double {
        return timeSpentSolvingQuiz
    }
    
    func getCurrentQuestionId() -> Int {
        return currentQuestionId
    }
    
    func setCurrentQuestion(id: Int) {
        currentQuestionId = id
    }
}

