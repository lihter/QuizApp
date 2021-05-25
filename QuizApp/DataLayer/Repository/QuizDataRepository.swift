//
//  QuizDataRepository.swift
//  QuizApp
//
//  Created by Mac Use on 20.05.2021..
//

class QuizDataRepository: QuizRepositoryProtocol {
    
    private let networkDataSource: QuizNetworkSourceProtocol
    private let coreDataSource: QuizCoreDataSourceProtocol
    
    init(networkDataSource: QuizNetworkSourceProtocol, coreDataSource: QuizCoreDataSourceProtocol) {
        self.networkDataSource = networkDataSource
        self.coreDataSource = coreDataSource
    }
    
    func fetchNetworkData(completionHandler: @escaping (Error?) -> Void) {
        networkDataSource.fetchQuizzesFromNetwork{ result in
            switch result {
            case .success(let quizzes):
                self.coreDataSource.saveNewQuizzes(quizzes)
                completionHandler(nil)
            case .failure(let error):
                completionHandler(error)
            }
        }
    }
    
    func fetchLocalData(filter: FilterSettings) -> [Quiz] {
        coreDataSource.fetchQuizzesFromCoreData(filter: filter)
    }
    
    func deleteLocalData(withId id: Int) {
        coreDataSource.deleteQuiz(withId: id)
    }
}
