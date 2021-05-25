//
//  FunFactPresenter.swift
//  QuizAppWidgetExtension
//
//  Created by Mac Use on 22.05.2021..
//

import Foundation

//Edit JSON:
//https://www.npoint.io/docs/0f1cac17f9c065d4d789

class FunFactPresenter {
    func fetchQuizzesFromNetwork(completionHandler: @escaping(Result<String?, RequestError>) -> Void) {
        let url = URL(string: "https://api.npoint.io/0f1cac17f9c065d4d789")
        var request = URLRequest(url: url!)
        request.httpMethod = "GET"
        
        let networkService = NetworkService()
        networkService.executeUrlRequest(request) { (result: Result<FunFactResponse, RequestError>) in
            switch result {
            case .failure(let error):
                completionHandler(.failure(error))
            case .success(let value):
                completionHandler(.success(value.widgetFunFact))
            }
        }
    }
}
