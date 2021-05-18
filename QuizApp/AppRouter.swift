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
    
    func login()
    func logout()
}

class AppRouter: AppRouterProtocol {
    //MARK: Constants
    
    //MARK: Code
    private let navigationController: UINavigationController!
    private var mainCoordinator: MainCoordinator!
    
    
    //This var will always track which quiz are we currently playing
    var quiz: Quiz!
    
    init(navigationController: UINavigationController, mainCoordinator: MainCoordinator) {
        self.navigationController = navigationController
        self.mainCoordinator = mainCoordinator
    }

    
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
        if currentQuestionId < quiz.questions.count {
            vc = QuizViewController(coordinator: mainCoordinator, for: quiz.questions[currentQuestionId])
            currentQuestionId += 1
        } else {
            vc = QuizResultViewController(router: self, correctQuestions: mainCoordinator.getQuestionTrackArray(), questionsCount: quiz.questions.count)
        }
        navigationController.pushViewController(vc, animated: true)
    }
    
    func toQuizzesVC() {
        navigationController.popToRootViewController(animated: true)
    }
    
    func openLeaderboard() {
        let vc = LeaderboardViewController(coordinator: mainCoordinator)
        
        navigationController.pushViewController(vc, animated: true)
    }
    
    func login() {        
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
