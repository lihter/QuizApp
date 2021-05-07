//
//  NavigationTitleLabel.swift
//  QuizApp
//
//  Created by Mac Use on 03.05.2021..
//

import UIKit

class NavigationTitleLabel: UILabel {
    //MARK: Constants
    let fontSize: CGFloat = 24
    
    //MARK: Code
    init(withText title: String) {
        super.init(frame: .zero)
        text = title
        textColor = .white
        font = UIFont(name: Fonts.mainBold, size: fontSize)
        textAlignment = .center
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
