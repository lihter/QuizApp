//
//  PopQuizLabel.swift
//  QuizApp
//
//  Created by Mac Use on 13.04.2021..
//

import UIKit

class PopQuizLabel: UILabel {
    
    init(size: CGFloat) {
        super.init(frame: .zero)
        text = "PopQuiz"
        textColor = .white
        font = UIFont(name: Fonts.mainBold, size: size)
        textAlignment = .center
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: Constants
    let labelText: String = "PopQuiz"
}
