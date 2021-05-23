//
//  QuizNetworkDataSource.swift
//  QuizApp
//
//  Created by Mac Use on 20.05.2021..
//

import Foundation

struct QuizNetworkDataSource: QuizNetworkSourceProtocol {
    
    func fetchQuizzesFromNetwork() throws -> [Quiz] {
        var quizzes: [Quiz]? = nil
        guard let url = URL(string: "https://iosquiz.herokuapp.com/api/quizzes") else { throw RequestError.serverError}
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        
        let networkService = NetworkService()
        var checkIfDone = false
        networkService.executeUrlRequest(request) { (result: Result<QuizResponse, RequestError>) in
            switch result {
            case .failure(let error):
                MainCoordinator.handleRequestError(error: error)
            case .success(let value):
                quizzes = value.quizzes
            }
            checkIfDone.toggle()
        }
        while checkIfDone != true{
            //radno cekanje koje mogu sigurno na neki bolji nacin rijesiti, ali sad cu ostaviti ovako pojednostavljeno
        }
        
        if quizzes != nil {
            return quizzes!
        } else {
            throw RequestError.fetchingFromNetError
        }
    }
}
