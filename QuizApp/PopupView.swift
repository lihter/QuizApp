//
//  PopupView.swift
//  QuizApp
//
//  Created by Mac Use on 14.04.2021..
//

import UIKit

class PopupView: UIView {
    //MARK: Constants
    private let answerStackSpacing: CGFloat = 16

    //MARK: Code
    private var quiz: Quiz
    private var answersStackView: UIStackView!
    
    private let questionText:UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont(name: Fonts.mainBold, size: 20.61)
        label.textAlignment = .left
        label.textColor = .white
        label.numberOfLines = 0
        label.lineBreakMode = .byWordWrapping
        return label
    }()
    
    private let container: UIView = {
        let v = UIView()
        v.translatesAutoresizingMaskIntoConstraints = false
        v.backgroundColor = UIColor(red: 116/255, green: 79/255, blue: 163/255, alpha: 1) //dodati gradient boju
        v.layer.cornerRadius = 20
        return v
    }()
    
    @objc func animateOut() {
        UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 0.7, initialSpringVelocity: 1, options: .curveEaseIn, animations: {
            self.container.transform = CGAffineTransform(translationX: 0, y: -self.frame.height)
            self.alpha = 0
        }) {
            (complete) in
            if complete {
                self.removeFromSuperview()
            }
        }
    }
    
    @objc func animateIn() {
        container.transform = CGAffineTransform(translationX: 0, y: -self.frame.height)
        alpha = 0
        UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 0.7, initialSpringVelocity: 1, options: .curveEaseIn, animations: {
            self.container.transform = .identity
            self.alpha = 1
        }) {
            (complete) in
            if complete {
                self.removeFromSuperview()
            }
        }
    }
    
    init(quiz: Quiz) {
        self.quiz = quiz
        super.init(frame: .zero)
        
        addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(animateOut))) // maknuti self di netreba
        backgroundColor = UIColor.white.withAlphaComponent(0.6)
        questionText.text = quiz.questions.first!.question
        
        frame = UIScreen.main.bounds
        addSubview(container)
        
        answersStackView = UIStackView()
        answersStackView.translatesAutoresizingMaskIntoConstraints = false
        answersStackView.axis = .vertical
        answersStackView.distribution = .equalSpacing
        answersStackView.spacing = answerStackSpacing
        addButtonsToStackView()
        
        container.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
        container.centerXAnchor.constraint(equalTo: self.centerXAnchor).isActive = true
        container.widthAnchor.constraint(equalTo: self.widthAnchor, multiplier: 0.7).isActive = true
        container.heightAnchor.constraint(equalTo: self.heightAnchor, multiplier: 0.5).isActive = true
        
        
        container.addSubview(answersStackView)
        container.addSubview(questionText)
        
        questionText.leadingAnchor.constraint(equalTo: container.leadingAnchor, constant: 24).isActive = true
        questionText.trailingAnchor.constraint(equalTo: container.trailingAnchor, constant: -20.94).isActive = true
        questionText.topAnchor.constraint(equalTo: container.topAnchor, constant: 15).isActive = true
        
        answersStackView.leadingAnchor.constraint(equalTo: container.leadingAnchor, constant: 24).isActive = true
        answersStackView.trailingAnchor.constraint(equalTo: container.trailingAnchor, constant: -20.94).isActive = true
        answersStackView.topAnchor.constraint(equalTo: questionText.bottomAnchor, constant: 15).isActive = true
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func addButtonsToStackView() {
        guard let question = quiz.questions.first else {
            print("Quiz \(quiz.title) has no questions")
            return
        }
        for answerId in 0..<question.answers.count {
            let btn = AnswerButton(withText: question.answers[answerId])
            answersStackView.addArrangedSubview(btn)
        }
    }
}
