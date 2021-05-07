//
//  QuizResultViewController.swift
//  QuizApp
//
//  Created by Mac Use on 04.05.2021..
//

import UIKit
import SnapKit

class QuizResultViewController: UIViewController {
    //MARK: Constants
    private let scoreLabelFontSize: CGFloat = 88
    private let scoreLabelFromTopOffsetMultiplier: CGFloat = 0.3435
    private let finishQuizButtonFromBottomOffsetMultiplier: CGFloat = 0.05379
    
    //MARK: Code
    private var gradientLayer: CAGradientLayer!
    private var router: AppRouterProtocol!
    private var numberOfCorrectQuestions: Int!
    private var questionsCount: Int!
    
    private var scoreLabel: UILabel!
    private var finishQuizButton: UIButton!
        
    convenience init(router: AppRouterProtocol, correctQuestions: [Bool], questionsCount: Int) {
        self.init()
        
        self.router = router
        self.numberOfCorrectQuestions = correctQuestions.filter{$0}.count
        self.questionsCount = questionsCount
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: false)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        buildViews()
        addConstraints()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
    }
    
    override func updateViewConstraints() {
            super.updateViewConstraints()
            updateConstraints()
    }
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
            super.traitCollectionDidChange(previousTraitCollection)
            view.setNeedsUpdateConstraints()
    }
    
    @objc private func returnToQuizzes() {
        router.toQuizzesVC()
    }

    
    private  func buildViews()  {
        gradientLayer = setBackgroundStyle(view)
        
        //MARK: Score Label
        scoreLabel = UILabel()
        scoreLabel.font = UIFont(name: Fonts.mainBold, size: scoreLabelFontSize)
        scoreLabel.textAlignment = .left
        scoreLabel.text = "\(numberOfCorrectQuestions!)/\(questionsCount!)"
        scoreLabel.textColor = .white
        scoreLabel.numberOfLines = 0
        scoreLabel.lineBreakMode = .byWordWrapping
        
        //MARK: Finish Quiz Button
        finishQuizButton = MenuButton()
        finishQuizButton.setTitle("Finish Quiz", for: .normal)
        finishQuizButton.addTarget(self, action: #selector(returnToQuizzes), for: .touchUpInside)
        
        view.layer.addSublayer(gradientLayer)

        view.addSubview(scoreLabel)
        view.addSubview(finishQuizButton)
    }
    
    private func updateConstraints() {
        scoreLabel.snp.updateConstraints{
            $0.top.equalTo(view).offset(view.bounds.height * scoreLabelFromTopOffsetMultiplier)
        }
        gradientLayer.reloadBoundsForGradient(view)
    }
    
    private func addConstraints() {
        scoreLabel.snp.makeConstraints{
            $0.top.equalTo(view).offset(view.bounds.height * scoreLabelFromTopOffsetMultiplier)
            $0.centerX.equalTo(view)
        }
        
        finishQuizButton.snp.makeConstraints {
            $0.width.equalTo(view).inset(buttonWidthInset)
            $0.height.equalTo(viewElementHeight)
            $0.bottom.equalTo(view).offset(view.bounds.height * -1 * finishQuizButtonFromBottomOffsetMultiplier)
            $0.centerX.equalTo(view)
        }
    }

}
