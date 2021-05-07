//
//  QuestionTrackerView.swift
//  QuizApp
//
//  Created by Mac Use on 03.05.2021..
//

import UIKit

/*Ovo nije zasad koristeno nigdje, jer jos nije dovrseno, ali planiram to u sljedecim zadacam implementirat u svoj kod.
 Pretpostavljam da bi to bilo elegantnije rješenje.
 */

class QuestionTrackerView: UIStackView {
    //MARK: Constants
    private let trackerItemSpacing: CGFloat = 8
    
    //MARK: Code
    private var coordinator: MainCoordinatorPatternProtocol!


    init(coordinator: MainCoordinatorPatternProtocol) {
        self.coordinator = coordinator
        super.init(frame: .zero)
        
        axis = .horizontal
        distribution = .equalSpacing
        spacing = trackerItemSpacing
        addItemsToTrackerStackView()
    }
    
    private func addItemsToTrackerStackView() {
        for _ in 0..<coordinator.numberOfQuestions() {
            let view = UIView()
            view.backgroundColor = UIColor.white.withAlphaComponent(0.5)
            view.layer.cornerRadius = 2.5
            
            view.snp.makeConstraints{
                $0.height.equalTo(15)
            }
            
            addArrangedSubview(view)
        }
    }
    
    public func onNewQuestion(answers: [Bool]) {
        /*for ansId in 0..<answers.count {
            
        }*/
    }
    
    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
