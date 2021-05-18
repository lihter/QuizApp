//
//  QuizCategoryColor.swift
//  QuizApp
//
//  Created by Mac Use on 14.04.2021..
//

import UIKit

//Odlucio sam koristiti vec preodredene boje a ne mozda neke random zbog sigurne vidljivosti natpisa i ostalih view-ova
func chooseQuizCategoryColor(quiz: Quiz) -> UIColor {
    switch quiz.category {
    case .sport :
        return UIColor(red: 242/255, green: 201/255, blue: 76/255, alpha: 1)
    case .science :
        return UIColor(red: 86/255, green: 204/255, blue: 242/255, alpha: 1)
    //default cu ostaviti jer pretpostavljam da ce se dodavati nove kategorije kvizova u buducnosti pa da se ne crasha
    default :
        return UIColor.white
    }
}
