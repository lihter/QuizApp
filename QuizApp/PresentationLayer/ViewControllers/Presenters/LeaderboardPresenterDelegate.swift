//
//  LeaderboardPresenterDelegate.swift
//  QuizApp
//
//  Created by Mac Use on 15.05.2021..
//

import Foundation
import UIKit

protocol LeaderboardPresenterDelegate: AnyObject {
    func presentLeaderboard(results: [LeaderboardResult])
}

typealias LeaderboardPresenterDel = LeaderboardPresenterDelegate & UIViewController

class LeaderboardPresenter {
    
    weak var delegate: LeaderboardPresenterDel?
    
    public func setViewDelegate(delegate: LeaderboardPresenterDel) {
        self.delegate = delegate
    }
    
    public func fetchLeaderboard(withQuizId quizId: Int) {
        guard var url = URL(string: "https://iosquiz.herokuapp.com/api/score") else { return }
        url.appendQueryItem(name: "quiz_id", value: String(quizId))
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.setValue(UserDefaults.standard.string(forKey: "Token"), forHTTPHeaderField: "Authorization")
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        networkService.executeUrlRequest(request) { (result: Result<[LeaderboardResult], RequestError>) in
            switch result {
            case .failure(let error):
                MainCoordinator.handleRequestError(error: error)
            case .success(let value):
                self.delegate?.presentLeaderboard(results: value)
            }
        }
    }
    
    public func postResult(quizId: Int, noOfCorrect: Int, time: Double) {
        guard let url = URL(string: "https://iosquiz.herokuapp.com/api/result") else { return }
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue(UserDefaults.standard.string(forKey: "Token"), forHTTPHeaderField: "Authorization")
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        
        let resultData = ResultModel(quizId: quizId, userId: UserDefaults.standard.object(forKey: "UserID") as! Int, time: time, noOfCorrect: noOfCorrect)
        let jsonData = try? JSONEncoder().encode(resultData)
        request.httpBody = jsonData
        
        networkService.executeUrlRequest(request) { (result: Result<EmptyResponseModel, RequestError>) in
            switch result {
            case .failure(let error):
                MainCoordinator.handleRequestError(error: error)
            case .success(_):
                print(result)
            }
        }
    }
    
}
