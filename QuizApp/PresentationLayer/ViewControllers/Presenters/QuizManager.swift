//
//  QuizManager.swift
//  QuizApp
//
//  Created by Mac Use on 22.05.2021..
//

import Foundation

class QuizManager {
    static func sortBySections(_ quizzes: [Quiz]) -> [[Quiz]] {
        let groupedDict = Dictionary(grouping: quizzes, by: { $0.category })
        let array2d = groupedDict.map({ $0.value })
        return array2d
    }
}
