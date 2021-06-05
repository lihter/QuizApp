//
//  LoginTextField.swift
//  QuizApp
//
//  Created by Mac Use on 12.04.2021..
//

import UIKit

class LoginTextField: UITextField {
    //MARK: - Constants
    private let textFieldOpacity : CGFloat = 0.3
    private let topAndBottomInset : CGFloat = 10
    private let leftInset : CGFloat = 21
    private let rightInset : CGFloat = 44
    private let viewElementCornerRadius : CGFloat = 20
    
    //MARK: - View vars
    private let insets: UIEdgeInsets
    
    //MARK: - Code
    init() {
        insets = UIEdgeInsets(top: topAndBottomInset, left: leftInset, bottom: topAndBottomInset, right: rightInset)
        super.init(frame: .zero)
        
        backgroundColor = UIColor.white.withAlphaComponent(textFieldOpacity)
        textColor = .white
        font = UIFont(name: Fonts.main, size: textFieldFontSize)
        layer.cornerRadius = viewElementCornerRadius
    }
    
    required init?(coder: NSCoder) {
        fatalError("error loginTextField")
    }
    
    //MARK: - Additional functions
    override func textRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.inset(by: insets)
    }
    
    override func editingRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.inset(by: insets)
    }
}
