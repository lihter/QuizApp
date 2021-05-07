//
//  QuizStartViewController.swift
//  QuizApp
//
//  Created by Mac Use on 03.05.2021..
//

import UIKit
import SnapKit

class QuizStartViewController: UIViewController {
    //MARK: Constants
    private let leaderboardLabelFontSize: CGFloat = 18
    private let containerAlpha: CGFloat = 0.3
    private let containerCornerRadius: CGFloat = 20
    private let containerTitleFontSize: CGFloat = 24
    private let containerDescriptionFontSize: CGFloat = 18
    private let containerHeightMultiplier: CGFloat = 0.5
    private let containerInset: CGFloat = 21
    private let leaderboardFromContainerOffset: CGFloat = -18.5
    private let containerFromTopOffsetMul: CGFloat = 0.2530
    private let containerFromTopOffsetMulLandscape: CGFloat = 0.2
    private let containerFromBottomOffsetMul: CGFloat = 0.0428//0.2408 //0.0428
    private let containerFromBottomOffsetMulLandscape: CGFloat = 0.0428
    private let containerTitleOffset: CGFloat = 23
    private let containerDescriptionOffset: CGFloat = 18
    private let containerItemOffset: CGFloat = 10
    private let containerItemWidthInset: CGFloat = 20
    
    //MARK: Code
    private var gradientLayer: CAGradientLayer!
    private var coordinator: MainCoordinatorPatternProtocol!
    private var quiz: Quiz!
    private var leaderboardButton: UIButton!
    private var container: UIView!
    private var containerTitle: UILabel!
    private var containerDescription: UILabel!
    private var containerImageView: UIImageView!
    private var containerStartButton: MenuButton!
    private var containerHeight: CGFloat!
    //private var questionTrackerStackView: UIStackView!

        
    convenience init(coordinator: MainCoordinatorPatternProtocol, for quiz: Quiz) {
        self.init()
        
        self.quiz = quiz
        self.coordinator = coordinator
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(false, animated: false)
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
        coordinator.goBack()
    }

    
    private  func buildViews()  {
        gradientLayer = setBackgroundStyle(view)
        
        //MARK: Setting Navigation Bar
        navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        navigationController?.navigationBar.shadowImage = UIImage()
        //navigationController?.navigationBar.isTranslucent = true
        navigationController?.view.backgroundColor = .clear
        
        navigationController?.navigationBar.tintColor = .white
        navigationItem.leftBarButtonItem = UIBarButtonItem(image: ImageEnum.backwardArrowItem.image, style: .done, target: self, action: #selector(returnToQuizzes))
        navigationItem.titleView = NavigationTitleLabel(withText: "PopQuiz")
        
        
        //MARK: Leaderboard Button
        leaderboardButton = UIButton(frame: .zero)
        leaderboardButton.titleLabel?.font = UIFont(name: Fonts.mainBold, size: leaderboardLabelFontSize)
        leaderboardButton.backgroundColor = .clear
        leaderboardButton.setTitleColor(.white, for: .normal)
        leaderboardButton.setAttributedTitle(NSAttributedString(string: "Leaderboard", attributes: [.underlineStyle: NSUnderlineStyle.thick.rawValue]), for: .normal)
        leaderboardButton.addTarget(self, action: #selector(openLeaderboard), for: .touchUpInside)
        
        //MARK: White Container
        container = UIView()
        container.translatesAutoresizingMaskIntoConstraints = false
        container.backgroundColor = UIColor.white.withAlphaComponent(containerAlpha)
        container.layer.cornerRadius = containerCornerRadius
        
        //MARK: Container Title
        containerTitle = UILabel()
        containerTitle.translatesAutoresizingMaskIntoConstraints = false
        containerTitle.font = UIFont(name: Fonts.mainBold, size: containerTitleFontSize)
        containerTitle.textAlignment = .center
        containerTitle.text = quiz.title
        containerTitle.textColor = .white
        containerTitle.numberOfLines = 0
        containerTitle.lineBreakMode = .byWordWrapping
        
        //MARK: Container Description
        containerDescription = UILabel()
        containerDescription.translatesAutoresizingMaskIntoConstraints = false
        containerDescription.font = UIFont(name: Fonts.mainSemiBold, size: containerDescriptionFontSize)
        containerDescription.textAlignment = .center
        containerDescription.text = quiz.description
        containerDescription.textColor = .white
        containerDescription.numberOfLines = 0
        containerDescription.lineBreakMode = .byWordWrapping
        
        //MARK: Container ImageView
        containerImageView = UIImageView()
        containerImageView.layer.cornerRadius = containerCornerRadius
        containerImageView.contentMode = .scaleAspectFill
        containerImageView.clipsToBounds = true
        containerImageView.load(url: URL(string: quiz.imageUrl)!)
        
        //MARK: Start Quiz Button
        containerStartButton = MenuButton()
        containerStartButton.setTitle("Start Quiz", for: .normal)
        containerStartButton.addTarget(self, action: #selector(startQuiz), for: .touchUpInside)
        
        
        view.layer.addSublayer(gradientLayer)
        
        view.addSubview(leaderboardButton)
        view.addSubview(container)
        
        container.addSubview(containerTitle)
        container.addSubview(containerDescription)
        container.addSubview(containerImageView)
        container.addSubview(containerStartButton)
    }
    
    private func updateConstraints() {
        if UIWindow.isLandscape {
            container.snp.updateConstraints{
                $0.top.equalTo(view).offset(view.bounds.height * containerFromTopOffsetMulLandscape)
                $0.bottom.equalTo(view).offset(-1 * view.bounds.height * containerFromBottomOffsetMulLandscape)
            }
        } else {
            container.snp.updateConstraints{
                $0.top.equalTo(view).offset(view.bounds.height * containerFromTopOffsetMul)
                $0.bottom.equalTo(view).offset(-1 * view.bounds.height * containerFromBottomOffsetMul)
            }
        }
        
        gradientLayer.reloadBoundsForGradient(view)
    }
    
    private func addConstraints() {
        leaderboardButton.snp.makeConstraints{
            $0.bottom.equalTo(container.snp.top).offset(leaderboardFromContainerOffset)
            $0.trailing.equalTo(container.snp.trailing)
        }
        
        container.snp.makeConstraints{
            $0.centerX.equalToSuperview()
            $0.width.equalToSuperview().inset(containerInset)
            //$0.top.equalTo(view).offset(view.bounds.height * containerFromTopOffsetMul)
            //$0.bottom.equalTo(view).offset(-1 * view.bounds.height * containerFromBottomOffsetMul)
        }
        if UIWindow.isLandscape {
            container.snp.makeConstraints{
                $0.top.equalTo(view).offset(view.bounds.height * containerFromTopOffsetMulLandscape)
                $0.bottom.equalTo(view).offset(-1 * view.bounds.height * containerFromBottomOffsetMulLandscape)
            }
        } else {
            container.snp.makeConstraints{
                $0.top.equalTo(view).offset(view.bounds.height * containerFromTopOffsetMul)
                $0.bottom.equalTo(view).offset(-1 * view.bounds.height * containerFromBottomOffsetMul)
            }
        }
        
        containerTitle.snp.makeConstraints{
            $0.centerX.equalToSuperview()
            $0.top.equalToSuperview().offset(containerTitleOffset)
        }
        
        containerDescription.snp.makeConstraints{
            $0.centerX.equalToSuperview()
            $0.top.equalTo(containerTitle.snp.bottom).offset(containerDescriptionOffset)
        }
        
        containerImageView.snp.makeConstraints{
            $0.centerX.equalToSuperview()
            $0.top.equalTo(containerDescription.snp.bottom).offset(containerItemOffset)
            $0.bottom.equalTo(containerStartButton.snp.top).offset(-1 * containerItemOffset)
            $0.width.equalToSuperview().inset(containerItemWidthInset)
        }
        
        containerStartButton.snp.makeConstraints{
            $0.centerX.equalToSuperview()
            $0.height.equalTo(viewElementHeight)
            $0.bottom.equalToSuperview().offset(-1 * containerItemOffset)
            $0.width.equalToSuperview().inset(containerItemWidthInset)
        }
    }
    
    @objc private func startQuiz() {
        //questionTrackerStackView = QuestionTrackerView(quiz: quiz)
        coordinator.reset()
        coordinator.showNextQuizQuestion()
    }
    
    @objc private func openLeaderboard() {
        coordinator.openLeaderboard()
    }
}
