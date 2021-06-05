//
//  MainCoordinatorPattern.swift
//  QuizApp
//
//  Created by Mac Use on 05.05.2021..
//

import Foundation
import UIKit

protocol MainCoordinatorPatternProtocol {
    func setStartScreen(in window: UIWindow?)
    func goBack()
    func showQuizStartVC(for quiz: Quiz)
    func showNextQuizQuestion()
    func toQuizzesVC()
    func openLeaderboard()
    func dismiss()
    
    func successfulLogin()
    func getUsername() -> String
    func logout()
    func addTime(_ time: Double)
    func getTime() -> Double
    func getQuiz() -> Quiz
    
    func resetQuizTrackingVariables()
    func isAnswered(correct add: Bool)
    func numberOfQuestions() -> Int
    func getQuestionTrackArray() -> [Bool]
    
    static func handleRequestError(error: RequestError)
}

class MainCoordinator: MainCoordinatorPatternProtocol {
    //MARK: - Coordinator vars
    private let navigationController: UINavigationController!
    private var navCoordinator: AppRouter!
    private var dataCoordinator: DataCoordinator!
    
    //MARK: - Code
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
        navCoordinator = AppRouter(navigationController: navigationController, mainCoordinator: self)
        dataCoordinator = DataCoordinator(navigationController: navigationController, mainCoordinator: self)
    }
    
    //MARK: - Functions
    func setStartScreen(in window: UIWindow?) {
        navCoordinator.setStartScreen(in: window)
    }
    
    func goBack() {
        navCoordinator.goBack()
    }
    
    func showQuizStartVC(for quiz: Quiz) {
        navCoordinator.showQuizStartVC(for: quiz)
        dataCoordinator.setQuiz(quiz)
    }
    
    func getQuiz() -> Quiz {
        return dataCoordinator.getQuiz()
    }
    
    func showNextQuizQuestion() {
        navCoordinator.showNextQuizQuestion()
    }
        
    func toQuizzesVC() {
        navCoordinator.toQuizzesVC()
    }
    
    func openLeaderboard() {
        navCoordinator.openLeaderboard()
    }
    
    func dismiss() {
        navCoordinator.dismiss()
    }
    
    func successfulLogin() {
        navCoordinator.successfulLogin()
    }
    
    func getUsername() -> String {
        return dataCoordinator.getUsername()
    }
    
    func logout() {
        dataCoordinator.logout()
        navCoordinator.logout()
    }
    
    //MARK: -
    
    func resetQuizTrackingVariables() {
        dataCoordinator.resetQuizTrackingVariables()
    }
    
    func isAnswered(correct add: Bool) {
        dataCoordinator.isAnswered(correct: add)
    }
    
    func numberOfQuestions() -> Int {
        return dataCoordinator.numberOfQuestions()
    }
    
    func getQuestionTrackArray() -> [Bool] {
        return dataCoordinator.getQuestionTrackArray()
    }
    
    func addTime(_ time: Double) {
        dataCoordinator.addTime(time)
    }
    
    func getTime() -> Double {
        return dataCoordinator.getTime()
    }
    
    //MARK: -
    
    static func handleRequestError(error: RequestError) {
        print("An error has occured during fetching data: \(error)")
    }

}

