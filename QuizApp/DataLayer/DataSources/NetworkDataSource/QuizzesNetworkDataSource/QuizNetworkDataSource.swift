//
//  QuizNetworkDataSource.swift
//  QuizApp
//
//  Created by Mac Use on 20.05.2021..
//

import Foundation

struct QuizNetworkDataSource: QuizNetworkSourceProtocol {
    
    func fetchQuizzesFromNetwork(completionHandler: @escaping (Result<[Quiz], RequestError>) -> Void) {
        guard let url = URL(string: "https://iosquiz.herokuapp.com/api/quizzes") else {
            print("Error fetching from network.")
            return }
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        
        networkService.executeUrlRequest(request) { (result: Result<QuizResponse, RequestError>) in
            switch result {
            case .failure(let error):
                completionHandler(.failure(error))
            case .success(let value):
                completionHandler(.success(value.quizzes))
            }
        }
    }
}
