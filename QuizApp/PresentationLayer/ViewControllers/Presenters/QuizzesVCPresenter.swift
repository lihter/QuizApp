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

    func refreshRestaurants() throws -> [Quiz] {
        try quizUseCase.refreshData()
        return filterRestaurants(filter: currentFilterSettings)
    }

    func filterRestaurants(filter: FilterSettings) -> [Quiz] {
        currentFilterSettings = filter
        quizzes = quizUseCase.getQuizzes(filter: filter)
        return quizzes
    }

}
