//
//  String+capitilizingFirstLetter.swift
//  QuizApp
//
//  Created by Mac Use on 15.05.2021..
//

extension String {
    func capitalizingFirstLetter() -> String {
        return prefix(1).capitalized + dropFirst().lowercased()
    }

    mutating func capitalizeFirstLetter() {
        self = self.capitalizingFirstLetter()
    }
}
