//
//  QuizzesPresenterDelegate.swift
//  QuizApp
//
//  Created by Mac Use on 15.05.2021..
//

import Foundation
import UIKit

protocol QuizzesPresenterDelegate: AnyObject {
    func presentQuizzes(quizzes: [[Quiz]])
}

typealias QuizzesresenterDel = QuizzesPresenterDelegate & UIViewController

class QuizzesPresenter {
    
    weak var delegate: QuizzesresenterDel?
    
    public func setViewDelegate(delegate: QuizzesresenterDel) {
        self.delegate = delegate
    }
    
    public func fetchQuizzes() {
        guard let url = URL(string: "https://iosquiz.herokuapp.com/api/quizzes") else { return }
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        
        let networkService = NetworkService()
        networkService.executeUrlRequest(request) { (result: Result<QuizResponse, RequestError>) in
            switch result {
            case .failure(let error):
                MainCoordinator.handleRequestError(error: error)
            case .success(let value):
                self.delegate?.presentQuizzes(quizzes: self.sortBySections(value.quizzes))
            }
        }
    }
    
    private func sortBySections(_ quizzes: [Quiz]) -> [[Quiz]] {
        let groupedDict = Dictionary(grouping: quizzes, by: { $0.category })
        let array2d = groupedDict.map({ $0.value })
        return array2d
    }
}
