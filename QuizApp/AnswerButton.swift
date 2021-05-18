//
//  AnswerButton.swift
//  QuizApp
//
//  Created by Mac Use on 03.05.2021..
//

import UIKit
import SnapKit

class AnswerButton: UIButton {
    //MARK: Constants
    private let buttonFontSize: CGFloat = 20
    private let viewElementCornerRadius: CGFloat = 27
    private let buttonHeight: CGFloat = 56
    
    //MARK: Code
    init(withText answerText: String) {
        super.init(frame: .zero)
        titleLabel?.font = UIFont(name: Fonts.mainBold, size: buttonFontSize)
        backgroundColor = UIColor.white.withAlphaComponent(0.3)
        setTitle(answerText, for: .normal)
        contentHorizontalAlignment = .left
        contentEdgeInsets = UIEdgeInsets(top: 0, left: 31, bottom: 0, right: 0)
        layer.cornerRadius = viewElementCornerRadius
        setTitleColor(.white, for: .normal)
        
        snp.makeConstraints{
            $0.height.equalTo(buttonHeight)
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
