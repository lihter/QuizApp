//
//  AppRouter.swift
//  QuizApp
//
//  Created by Mac Use on 03.05.2021..
//

import Foundation
import UIKit

protocol AppRouterProtocol {
    func setStartScreen(in window: UIWindow?)
    func goBack()
    func showQuizStartVC(for quiz: Quiz)
    func showNextQuizQuestion()
    func toQuizzesVC()
    func openLeaderboard()
    func dismiss()
    
    func successfulLogin()
    func logout()
}

class AppRouter: AppRouterProtocol {
    //MARK: - Coordinator vars
    private let navigationController: UINavigationController!
    private var mainCoordinator: MainCoordinator!
    private var quiz: Quiz!
    
    //MARK: - Code
    init(navigationController: UINavigationController, mainCoordinator: MainCoordinator) {
        self.navigationController = navigationController
        self.mainCoordinator = mainCoordinator
    }

    //MARK: - Functions
    func setStartScreen(in window: UIWindow?) {
        let vc = LoginViewController(coordinator: mainCoordinator)
        
        navigationController.pushViewController(vc, animated: true)
        
        window?.rootViewController = navigationController
        window?.makeKeyAndVisible()
    }
    
    func goBack() {
        navigationController.popViewController(animated: true)
    }
    
    func showQuizStartVC(for quiz: Quiz) {
        let vc = QuizStartViewController(coordinator: mainCoordinator, for: quiz)
        self.quiz = quiz
        
        navigationController.pushViewController(vc, animated: true)
    }
    
    func showNextQuizQuestion() {
        var vc: UIViewController!
        if QuizTemporaryVariables.currentQuestionId < quiz.questions.count {
            vc = QuizViewController(coordinator: mainCoordinator, for: quiz.questions[QuizTemporaryVariables.currentQuestionId])
            QuizTemporaryVariables.currentQuestionId += 1
        } else {
            vc = QuizResultViewController(coordinator: mainCoordinator, correctQuestions: mainCoordinator.getQuestionTrackArray(), questionsCount: quiz.questions.count)
        }
        navigationController.pushViewController(vc, animated: true)
    }
    
    func toQuizzesVC() {
        navigationController.popToRootViewController(animated: true)
    }
    
    func openLeaderboard() {
        let vc = LeaderboardViewController(coordinator: mainCoordinator)
        navigationController.present(vc, animated: true, completion: nil)
        //navigationController.pushViewController(vc, animated: true)
    }
    
    func dismiss() {
        navigationController.dismiss(animated: true, completion: nil)
    }
    
    func successfulLogin() {        
        let tabBarViewController = UITabBarController()
        let quizVC = QuizzesViewController(coordinator: mainCoordinator)
        let searchVC = SearchViewController(coordinator: mainCoordinator)
        let settingsVC = SettingsViewController(coordinator: mainCoordinator)

        quizVC.tabBarItem = UITabBarItem(title: "Quiz", image: ImageEnum.quizTabBarItem.image, selectedImage: ImageEnum.quizTabBarItemSelected.image)
        searchVC.tabBarItem = UITabBarItem(title: "Search", image: ImageEnum.searchTabBarItem.image, selectedImage: ImageEnum.searchTabBarItemSelected.image)
        settingsVC.tabBarItem = UITabBarItem(title: "Settings", image: ImageEnum.settingsTabBarItem.image, selectedImage: ImageEnum.settingsTabBarItemSelected.image)
        
        //Search maknut prema uputstvima iz 2. dz
        tabBarViewController.viewControllers = [quizVC, settingsVC]//[quizVC, searchVC, settingsVC]
        
        UITabBar.appearance().tintColor = UIColor.black
        tabBarViewController.modalPresentationStyle = .fullScreen
        navigationController.setViewControllers([tabBarViewController], animated: true)
    }
    
    func logout() {
        let vc = LoginViewController(coordinator: mainCoordinator)
        navigationController.setViewControllers([vc], animated: true)
    }
}
