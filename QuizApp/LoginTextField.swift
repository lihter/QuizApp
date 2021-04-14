//
//  LoginTextField.swift
//  QuizApp
//
//  Created by Mac Use on 12.04.2021..
//

import UIKit

class LoginTextField: UITextField {
    
    let insets: UIEdgeInsets
    
    init() {
        self.insets = UIEdgeInsets(top: topAndBottomInset, left: leftInset, bottom: topAndBottomInset, right: rightInset)
        super.init(frame: .zero)
        
        backgroundColor = UIColor(red: 1, green: 1, blue: 1, alpha: textFieldOpacity)
        textColor = .white
        font = UIFont(name: Fonts.main, size: textFieldFontSize)
        layer.cornerRadius = viewElementCornerRadius
    }
    
    required init?(coder: NSCoder) {
        fatalError("error loginTextField")
    }
    
    override func textRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.inset(by: insets)
    }
    
    override func editingRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.inset(by: insets)
    }
    
    //MARK: Constants
    let textFieldOpacity : CGFloat = 0.3
    let topAndBottomInset : CGFloat = 10
    let leftInset : CGFloat = 21
    let rightInset : CGFloat = 44
    let viewElementCornerRadius : CGFloat = 20
}
