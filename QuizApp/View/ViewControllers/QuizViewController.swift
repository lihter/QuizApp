//
//  QuizViewController.swift
//  QuizApp
//
//  Created by Mac Use on 03.05.2021..
//

import UIKit
import SnapKit

class QuizViewController: UIViewController {
    //MARK: - Constants
    private let questionLabelFontSize: CGFloat = 24
    private let answerStackSpacing: CGFloat = 16
    private let itemInset: CGFloat = 20
    private let stackviewFromLabelOffsetMultiplier: CGFloat = 0.0465
    private let questionIndexLabelFontSize: CGFloat = 18
    private let questionIndexFromTrackerOffset: CGFloat = 11
    
    private let trackerItemSpacing: CGFloat = 8

    
    //MARK: - VC elements
    private var gradientLayer = CAGradientLayer()
    private var coordinator: MainCoordinatorPatternProtocol!
    private var question: Question!
    private var questionLabel: UILabel!
    private var answersStackView: UIStackView!
    private var questionTrackerStackView: UIStackView!
    private var questionIndexLabel: UILabel!
    private var startTime: Date!
    
    //MARK: - Code
    convenience init(coordinator: MainCoordinatorPatternProtocol, for question: Question) {
        self.init()
        
        self.question = question
        self.coordinator = coordinator
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(false, animated: false)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        startTime = Date()
        
        buildViews()
        addConstraints()
        
        refreshQuestionTracker()
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
    
    //MARK: - Building Views and Constraints
    private  func buildViews()  {
        gradientLayer.setBackgroundStyle(view)
        
        //MARK: Setting Navigation Bar
        navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        navigationController?.navigationBar.shadowImage = UIImage()
        navigationController?.view.backgroundColor = .clear
        
        navigationController?.navigationBar.tintColor = .white
        navigationItem.leftBarButtonItem = UIBarButtonItem(image: ImageEnum.backwardArrowItem.image, style: .done, target: self, action: #selector(returnToQuizzes))
        navigationItem.titleView = NavigationTitleLabel(withText: "PopQuiz")
        
        
        //MARK: Question Index Label
        questionIndexLabel = UILabel()
        questionIndexLabel.font = UIFont(name: Fonts.mainBold, size: questionIndexLabelFontSize)
        questionIndexLabel.textAlignment = .left
        questionIndexLabel.text = "\(coordinator.getQuestionTrackArray().count + 1)/\(coordinator.numberOfQuestions())"
        questionIndexLabel.textColor = .white
        
        
        //MARK: Question Tracker Stack View
        questionTrackerStackView = UIStackView()
        questionTrackerStackView.axis = .horizontal
        questionTrackerStackView.distribution = .fillEqually
        questionTrackerStackView.spacing = trackerItemSpacing
        addItemsToTrackerStackView()

        
        //MARK: Question Label
        questionLabel = UILabel()
        questionLabel.translatesAutoresizingMaskIntoConstraints = false
        questionLabel.font = UIFont(name: Fonts.mainBold, size: questionLabelFontSize)
        questionLabel.textAlignment = .left
        questionLabel.text = question.question
        questionLabel.textColor = .white
        questionLabel.numberOfLines = 0
        questionLabel.lineBreakMode = .byWordWrapping
        
        //MARK: Answers Stack View
        answersStackView = UIStackView()
        answersStackView.axis = .vertical
        answersStackView.distribution = .equalSpacing
        answersStackView.spacing = answerStackSpacing
        addButtonsToStackView()
        
        
        view.layer.addSublayer(gradientLayer)
        
        view.addSubview(questionIndexLabel)
        view.addSubview(questionTrackerStackView)
        view.addSubview(questionLabel)
        view.addSubview(answersStackView)
    }
    
    private func updateConstraints() {
        //baca neki error pri prelasku iz landscapea u normal/portrait view
        if UIWindow.isLandscape {
            questionIndexLabel.snp.remakeConstraints{
                $0.bottom.equalTo(questionTrackerStackView).offset(-1 * questionIndexFromTrackerOffset)
                $0.leading.equalTo(questionTrackerStackView)
            }
            
            questionTrackerStackView.snp.remakeConstraints{
                $0.top.equalTo(view).offset(view.bounds.height * 0.1711)
                $0.leading.equalTo(view).offset(itemInset)
                $0.trailing.equalTo(view).offset(-1 * itemInset)
            }
            
            questionLabel.snp.remakeConstraints{
                $0.top.equalTo(questionTrackerStackView.snp.bottom).offset(view.bounds.height * 0.0660)
                $0.leading.equalTo(view).offset(itemInset)
                $0.trailing.equalTo(view).offset(-1 * ((view.bounds.width / 2) + itemInset))
            }
            
            answersStackView.snp.remakeConstraints{
                $0.leading.equalTo(view).offset((view.bounds.width / 2) + itemInset)
                $0.trailing.equalTo(view).offset(-1 * itemInset)
                $0.top.equalTo(questionLabel.snp.top)
            }
        } else {
            questionIndexLabel.snp.remakeConstraints{
                $0.bottom.equalTo(questionTrackerStackView).offset(-1 * questionIndexFromTrackerOffset)
                $0.leading.equalTo(questionTrackerStackView)
            }
            
            questionTrackerStackView.snp.remakeConstraints{
                $0.top.equalTo(view).offset(view.bounds.height * 0.1711)
                $0.leading.equalTo(view).offset(itemInset)
                $0.width.equalTo(view).inset(itemInset)
            }
            
            questionLabel.snp.remakeConstraints{
                $0.centerX.equalTo(view)
                $0.top.equalTo(questionTrackerStackView.snp.bottom).offset(view.bounds.height * 0.0660)
                $0.width.equalTo(view).inset(itemInset)
            }
            
            answersStackView.snp.remakeConstraints{
                $0.centerX.equalTo(view)
                $0.top.equalTo(questionLabel.snp.bottom).offset(view.bounds.height * stackviewFromLabelOffsetMultiplier)
                $0.width.equalTo(view).inset(itemInset)
            }
        }
        
        gradientLayer.reloadBoundsForGradient(view)
    }
    
    private func addConstraints() {
        if UIWindow.isLandscape {
            questionIndexLabel.snp.makeConstraints{
                $0.bottom.equalTo(questionTrackerStackView).offset(-1 * questionIndexFromTrackerOffset)
                $0.leading.equalTo(questionTrackerStackView)
            }
            
            questionTrackerStackView.snp.makeConstraints{
                $0.top.equalTo(view).offset(view.bounds.height * 0.1711)
                $0.leading.equalTo(view).offset(itemInset)
                $0.trailing.equalTo(view).offset(-1 * itemInset)
            }
            
            questionLabel.snp.makeConstraints{
                $0.top.equalTo(questionTrackerStackView.snp.bottom).offset(view.bounds.height * 0.0660)
                $0.leading.equalTo(view).offset(itemInset)
                $0.trailing.equalTo(view).offset(-1 * ((view.bounds.width / 2) + itemInset))
            }
            
            answersStackView.snp.makeConstraints{
                $0.leading.equalTo(view).offset((view.bounds.width / 2) + itemInset)
                $0.trailing.equalTo(view).offset(-1 * itemInset)
                $0.top.equalTo(questionLabel.snp.top)
            }
        } else {
            questionIndexLabel.snp.makeConstraints{
                $0.bottom.equalTo(questionTrackerStackView).offset(-1 * questionIndexFromTrackerOffset)
                $0.leading.equalTo(questionTrackerStackView)
            }
            
            questionTrackerStackView.snp.makeConstraints{
                $0.top.equalTo(view).offset(view.bounds.height * 0.1711)
                $0.leading.equalTo(view).offset(itemInset)
                $0.width.equalTo(view).inset(itemInset)
            }
            
            questionLabel.snp.makeConstraints{
                $0.centerX.equalTo(view)
                $0.top.equalTo(questionTrackerStackView.snp.bottom).offset(view.bounds.height * 0.0660)
                $0.width.equalTo(view).inset(itemInset)
            }
            
            answersStackView.snp.makeConstraints{
                $0.centerX.equalTo(view)
                $0.top.equalTo(questionLabel.snp.bottom).offset(view.bounds.height * stackviewFromLabelOffsetMultiplier)
                $0.width.equalTo(view).inset(itemInset)
            }
        }
    }
    
    //MARK: - Additional functions
    
    @objc private func returnToQuizzes() {
        coordinator.toQuizzesVC()
    }
    
    private func addButtonsToStackView() {
        for answerId in 0..<question.answers.count {
            let btn = AnswerButton(withText: question.answers[answerId])
            btn.addTarget(self, action: #selector(answerButtonClicked), for: .touchUpInside)
            btn.tag = answerId
            answersStackView.addArrangedSubview(btn)
        }
    }
    
    private func addItemsToTrackerStackView() {
        for _ in 0..<coordinator.numberOfQuestions() {
            let viewItem = UIButton()
            viewItem.backgroundColor = UIColor.white.withAlphaComponent(0.5)
            viewItem.layer.cornerRadius = 2.5
            
            viewItem.snp.makeConstraints{
                $0.height.equalTo(5)
            }
            
            questionTrackerStackView.addArrangedSubview(viewItem)
        }
    }
    
    @objc private func answerButtonClicked(sender: UIButton!) {
        coordinator.addTime(Date().timeIntervalSince(startTime))
        answersStackView.arrangedSubviews.forEach {
            $0.isUserInteractionEnabled = false
        }
        if sender.tag == question.correctAnswer {
            answersStackView.arrangedSubviews[sender.tag].backgroundColor = correctAnswerColor
        } else {
            answersStackView.arrangedSubviews[question.correctAnswer].backgroundColor = correctAnswerColor
            answersStackView.arrangedSubviews[sender.tag].backgroundColor = wrongAnswerColor
        }
        coordinator.isAnswered(correct: (sender.tag == question.correctAnswer))
        refreshLastQuestionInQuestionTracker()
        
        perform(#selector(doneWithQuestion), with: nil, afterDelay: 2)
    }
    
    @objc private func doneWithQuestion() {
        coordinator.showNextQuizQuestion()
        answersStackView.arrangedSubviews.forEach {
            $0.isUserInteractionEnabled = true
        }
    }
    
    private func refreshQuestionTracker() {
        let boolArray: [Bool] = coordinator.getQuestionTrackArray()
        for i in 0..<boolArray.count {
            if(boolArray[i]) {
                questionTrackerStackView.arrangedSubviews[i].backgroundColor = correctAnswerColor
            } else {
                questionTrackerStackView.arrangedSubviews[i].backgroundColor = wrongAnswerColor
            }
        }
        questionTrackerStackView.arrangedSubviews[boolArray.count].backgroundColor = .white.withAlphaComponent(1)
    }
    private func refreshLastQuestionInQuestionTracker() {
        let boolArray: [Bool] = coordinator.getQuestionTrackArray()
        if(boolArray[boolArray.count - 1]) {
            questionTrackerStackView.arrangedSubviews[boolArray.count - 1].backgroundColor = correctAnswerColor
        } else {
            questionTrackerStackView.arrangedSubviews[boolArray.count - 1].backgroundColor = wrongAnswerColor
        }
    }
    
}
