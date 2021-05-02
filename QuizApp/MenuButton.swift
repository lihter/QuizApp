//
//  MenuButton.swift
//  QuizApp
//
//  Created by Mac Use on 12.04.2021..
//

import UIKit

class MenuButton: UIButton {
    //MARK: Constants
    private let buttonFontSize : CGFloat = 16
    private let viewElementCornerRadius : CGFloat = 20
    
    //MARK: Code
    init(_ style : StyleOptions) {
        super.init(frame: .zero)
        titleLabel?.font = UIFont(name: Fonts.mainBold, size: buttonFontSize)
        backgroundColor = .white
        layer.cornerRadius = viewElementCornerRadius
        setTitleColor(buttonColorStyle(style), for: .normal)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

