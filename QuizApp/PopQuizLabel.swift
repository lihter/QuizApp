//
//  PopQuizLabel.swift
//  QuizApp
//
//  Created by Mac Use on 13.04.2021..
//

import UIKit

class PopQuizLabel: UILabel {
    //MARK: Constants
    private let labelText: String = "PopQuiz"
    
    //MARK: Code
    init(size: CGFloat) {
        super.init(frame: .zero)
        text = labelText
        textColor = .white
        font = UIFont(name: Fonts.mainBold, size: size)
        textAlignment = .center
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
