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
    
    func login(email: String)
    func getUserEmail() -> String
    func getUsername() -> String
    func logout()
    
    func reset()
    func isAnswered(correct add: Bool)
    func numberOfQuestions() -> Int
    func getQuestionTrackArray() -> [Bool]
}

class MainCoordinator: MainCoordinatorPatternProtocol {
    //MARK: Constants
    
    //MARK: Code
    private let navigationController: UINavigationController!
    private var navCoordinator: AppRouter!
    private var dataCoordinator: DataCoordinator!
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
        navCoordinator = AppRouter(navigationController: navigationController, mainCoordinator: self)
        dataCoordinator = DataCoordinator(navigationController: navigationController, mainCoordinator: self)
    }
    
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
    
    func showNextQuizQuestion() {
        navCoordinator.showNextQuizQuestion()
    }
    
    func toQuizzesVC() {
        navCoordinator.toQuizzesVC()
    }
    
    func openLeaderboard() {
        navCoordinator.openLeaderboard()
    }
    
    func login(email: String) {
        navCoordinator.login()
        
        dataCoordinator.login(email: email)
    }
    
    func getUserEmail() -> String{
        return dataCoordinator.getUserEmail()
    }
    
    func getUsername() -> String {
        return dataCoordinator.getUsername()
    }
    
    func logout() {
        dataCoordinator.logout()
        navCoordinator.logout()
    }
    
    //---------------------------------------------------------------------
    
    func reset() {
        dataCoordinator.reset()
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
}

