//
//  QuizUseCase.swift
//  QuizApp
//
//  Created by Mac Use on 21.05.2021..
//

final class QuizUseCase {

    private let quizRepo: QuizRepositoryProtocol


    init(quizRepo: QuizRepositoryProtocol) {
        self.quizRepo = quizRepo
    }

    func refreshData() throws {
        try quizRepo.fetchNetworkData()
    }

    func getQuizzes(filter: FilterSettings) -> [Quiz] {
        quizRepo.fetchLocalData(filter: filter)
    }

    func deleteQuiz(withId id: Int) {
        quizRepo.deleteLocalData(withId: id)
    }

}

