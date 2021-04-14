//
//  QuizViewModel.swift
//  QuizApp
//
//  Created by Mac Use on 13.04.2021..
//

import Combine
import UIKit

class QuizViewModel {

    private let quizSubject = Quiz.self
    private let dataService: DataServiceProtocol
    private var disposables = Set<AnyCancellable>()

    var quizes: [Quiz] {
        quizSubject
    }

    init(dataService: DataServiceProtocol) {
        self.dataService = dataService
    }

    func queryQuizes(){
        quizes = dataService.fetchQuizes()
    }

}
