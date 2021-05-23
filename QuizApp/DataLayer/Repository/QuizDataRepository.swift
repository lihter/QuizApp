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
    
    func fetchNetworkData() throws {
        let quizzes = try networkDataSource.fetchQuizzesFromNetwork()
        coreDataSource.saveNewQuizzes(quizzes) //error
    }
    
    func fetchLocalData(filter: FilterSettings) -> [Quiz] {
        coreDataSource.fetchQuizzesFromCoreData(filter: filter)
    }
    
    func deleteLocalData(withId id: Int) {
        coreDataSource.deleteQuiz(withId: id)
    }
}
