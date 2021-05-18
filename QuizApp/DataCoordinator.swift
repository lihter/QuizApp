//
//  DataCoordinator.swift
//  QuizApp
//
//  Created by Mac Use on 05.05.2021..
//

import Foundation
import UIKit

protocol DataCoordinatorProtocol {
    func login(email: String)
    func getUserEmail() -> String
    func getUsername() -> String
    func logout()
    func setQuiz(_ quiz: Quiz)
    
    func reset()
    func isAnswered(correct add: Bool)
    func numberOfQuestions() -> Int
    func getQuestionTrackArray() -> [Bool]
}

class DataCoordinator: DataCoordinatorProtocol {
    //MARK: Constants
    
    //MARK: Code
    private let navigationController: UINavigationController!
    private var currentUserEmail: String = ""
    private var mainCoordinator: MainCoordinator!
    
    //This var will be RESET TO 0 everytime someone starts a NEW QUIZ
    private var correctQuestions: [Bool]!
    //This var will always track which quiz are we currently playing
    private var quiz: Quiz!
    
    init(navigationController: UINavigationController, mainCoordinator: MainCoordinator) {
        self.navigationController = navigationController
        self.mainCoordinator = mainCoordinator
    }
    
    func login(email: String) {
        currentUserEmail = email
    }
    
    func getUserEmail() -> String{
        return currentUserEmail
    }
    
    func getUsername() -> String {
        //return username
        
        //sad ću predpostaviti da je username jednak prefixu emaila korisnika
        //Dvije opcije username-a su: ako email unesen na login screenu ima znak @ u sebi, onda je username sve prjie tog znaka, a ako nema znaka @ u unesenom emailu, onda je username cijeli taj email string
        let username = currentUserEmail[..<(currentUserEmail.firstIndex(of: "@") ?? currentUserEmail.endIndex)]
        return String(username)
    }
    
    func logout() {
        currentUserEmail = ""
    }
    
    func setQuiz(_ quiz: Quiz) {
        self.quiz = quiz
    }
        
    func reset() {
        currentQuestionId = 0
        correctQuestions = []
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
}

