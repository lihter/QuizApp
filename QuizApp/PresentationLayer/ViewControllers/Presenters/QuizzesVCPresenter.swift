//
//  QuizzesVCPresenter.swift
//  QuizApp
//
//  Created by Mac Use on 21.05.2021..
//

import Foundation

final class QuizVCPresenter {

    private var quizUseCase: QuizUseCase!
    private var quizzes: [Quiz] = []
    private var sectionNames: [String] = []
    private var currentFilterSettings: FilterSettings

    init() {
        let coreDataContext = CoreDataStack(modelName: "QuizCDModel").managedContext
        let quizRepository = QuizDataRepository(networkDataSource: QuizNetworkDataSource(), coreDataSource: QuizCoreDataSource(coreDataContext: coreDataContext))
        self.quizUseCase = QuizUseCase(quizRepo: quizRepository)
        self.currentFilterSettings = FilterSettings()
    }

    func refreshQuizzes(completionHandler: @escaping (Result<[Quiz], Error>) -> Void) {
        quizUseCase.refreshData { error in
            if error == nil {
                completionHandler(.success(self.filterQuizzes(filter: self.currentFilterSettings)))
            } else {
                completionHandler(.failure(error!))
            }
        }
    }

    func filterQuizzes(filter: FilterSettings) -> [Quiz] {
        currentFilterSettings = filter
        quizzes = quizUseCase.getQuizzes(filter: filter)
        return quizzes
    }

}
