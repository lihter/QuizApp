//
//  QuizzesViewController.swift
//  QuizApp
//
//  Created by Mac Use on 13.04.2021..
//

import UIKit
import SnapKit

class QuizzesViewController: UIViewController, QuizzesPresenterDelegate, TabBarThemeProtocol {
    
    //MARK: - Constants
    private let buttonOpacity: CGFloat = 1.0
    private let distance: CGFloat = 10
    private let tableViewFromFunFactTextOffset: CGFloat = 32
    private let titleLabelTopOffsetMultiplier: CGFloat = 0.0723
    private let buttonFromTitleLabelOffsetMultiplier: CGFloat = 0.0415
    private let errorImageName: String = "multiply.circle"
    private let errorImageDimensions: CGFloat = 67
    private let errorTitleFontSize: CGFloat = 28
    private let errorDescriptionWidth: CGFloat = 211
    private let errorDescriptionHeight: CGFloat = 69
    private let errorDescriptionFontSize: CGFloat = 16
    private let tableViewRowHeight: CGFloat = 153
    private let funFactDescriptionFontSize: CGFloat = 18
    private let funFactFromButtonOffsetMultiplier: CGFloat = 0.0652
    private let elementInset: CGFloat = 24
    private let previewAlphaComponent: CGFloat = 0.6
    
    
    //MARK: - VC elements
    private var coordinator: MainCoordinatorPatternProtocol!
    private let presenter = QuizzesPresenter()
    private var titleLabel: PopQuizLabel!
    private var getQuizzesButton: MenuButton!
    
    private var gradientLayer = CAGradientLayer()

    private var errorImageView: UIImageView!
    private var errorTitle: UILabel!
    private var errorDescription: UILabel!
    
    private var quizTableView = UITableView(frame: .zero, style: .grouped)
    private var funFactTitle: UILabel!
    private var funFactDescription: UILabel!
    
    private let quizCellId: String = "quizCell"
    
    private var quizzesMatrix: [[Quiz]] = [[]]
    private let networkService = NetworkService()
    
    //MARK: - Code
    
    convenience init(coordinator: MainCoordinatorPatternProtocol) {
        self.init()
        
        self.coordinator = coordinator
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: false)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        buildViews()
        addConstraints()
        
        getQuizzesButton.addTarget(self, action: #selector(getQuizzes), for: .touchUpInside)
        
        NotificationCenter.default.addObserver(self, selector: #selector(themeChanged), name: Notification.Name("NewTheme"), object: nil)
    }
    
    override func updateViewConstraints() {
        super.updateViewConstraints()
        updateConstraints()
    }
    
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)
        view.setNeedsUpdateConstraints()
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self, name: Notification.Name("NewTheme"), object: nil)
    }
    
    //MARK: - Building Views and Constraints
    private func configureFunFact() {
        
        //MARK: Fun Fact Title
        funFactTitle = UILabel()
        funFactTitle.font = UIFont(name: Fonts.mainBold, size: titleLabelSize)
        funFactTitle.textColor = .white
        funFactTitle.text = "💡 Fun Fact"
        funFactTitle.textAlignment = .left
        
        //MARK: Fun Fact Description
        funFactDescription = UILabel()
        funFactDescription.font = UIFont(name: Fonts.main, size: funFactDescriptionFontSize)
        funFactDescription.textColor = .white
        funFactDescription.numberOfLines = 0
        funFactDescription.lineBreakMode = .byWordWrapping
        funFactDescription.attributedText = NSMutableAttributedString(string: "There are \(numberOfNBAMentiones()) questions that contain the word “NBA”", attributes: [NSAttributedString.Key.kern: 0.22])
        funFactDescription.textAlignment = .left
        
        view.addSubview(funFactTitle)
        view.addSubview(funFactDescription)
        setFunFactConstraints()
    }
    
    private func configureTableView() {
        view.addSubview(quizTableView)
        setQuizTableViewDelegates()
        quizTableView.rowHeight = tableViewRowHeight
        quizTableView.separatorColor = UIColor.clear
        quizTableView.backgroundColor = UIColor.clear
        quizTableView.showsVerticalScrollIndicator = false
        
        
        quizTableView.register(QuizCell.self, forCellReuseIdentifier: quizCellId)
        setQuizTableViewConstraints()
    }
    
    private func buildViews()  {
        gradientLayer.setBackgroundStyle(view)
        
        //MARK: Get Quizzes Button
        getQuizzesButton = MenuButton()
        getQuizzesButton.setTitle("Get Quiz", for: .normal)
        
        //MARK: Title Pop Quiz Label
        titleLabel = PopQuizLabel(size: titleLabelSize)
        
        //MARK: Error message elements
        errorImageView = UIImageView(image: ImageEnum.errorSign.image)
        
        errorTitle = UILabel()
        errorTitle.font = UIFont(name: Fonts.mainBold, size: errorTitleFontSize)
        errorTitle.textColor = .white
        errorTitle.text = "Error"
        errorTitle.textAlignment = .center
        
        errorDescription = UILabel()
        errorDescription.numberOfLines = 0
        errorDescription.lineBreakMode = .byWordWrapping
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineHeightMultiple = 1.09
        errorDescription.attributedText = NSMutableAttributedString(string: "Data can’t be reached.\nPlease try again",
                                                                    attributes: [NSAttributedString.Key.paragraphStyle: paragraphStyle])
        errorDescription.textColor = .white
        errorDescription.textAlignment = .center
        errorDescription.font = UIFont(name: Fonts.main, size: errorDescriptionFontSize)
        
        view.layer.addSublayer(gradientLayer)
        
        view.addSubview(titleLabel)
        view.addSubview(getQuizzesButton)
        
        view.addSubview(errorImageView)
        view.addSubview(errorTitle)
        view.addSubview(errorDescription)
    }
    
    private func updateConstraints() {
        titleLabel.snp.updateConstraints{
            $0.top.equalTo(view).offset(view.bounds.height * titleLabelTopOffsetMultiplier)
        }
        
        getQuizzesButton.snp.updateConstraints{
            $0.top.equalTo(titleLabel.snp.bottom).offset(view.bounds.height * buttonFromTitleLabelOffsetMultiplier)
        }
        
        if errorImageView.isHidden {
            funFactTitle.snp.updateConstraints {
                $0.top.equalTo(getQuizzesButton.snp.bottom).offset(view.bounds.height * funFactFromButtonOffsetMultiplier)
            }
            quizTableView.snp.updateConstraints{
                $0.top.equalTo(funFactDescription.snp.bottom).offset(view.bounds.height * 0.0379)
            }
        } else {
            errorImageView.snp.updateConstraints{
                $0.height.equalTo(view.bounds.height * 0.1)
                $0.width.equalTo(view.bounds.height * 0.1)
            }
        }
        
        gradientLayer.reloadBoundsForGradient(view)
    }
    
    private func addConstraints() {
        titleLabel.snp.makeConstraints{
            $0.top.equalToSuperview().offset(titleLabelTopOffsetMultiplier)
            $0.centerX.equalTo(view)
        }
        
        getQuizzesButton.snp.makeConstraints {
            $0.width.equalTo(view).inset(buttonWidthInset)
            $0.height.equalTo(viewElementHeight)
            $0.top.equalTo(titleLabel.snp.bottom).offset(view.bounds.height * buttonFromTitleLabelOffsetMultiplier)
            $0.centerX.equalTo(view)
        }
        
        errorImageView.snp.makeConstraints {
            $0.centerX.equalTo(view)
            $0.height.equalTo(view.bounds.height * 0.1)
            $0.width.equalTo(view.bounds.height * 0.1)
            $0.bottom.equalTo(errorTitle.snp.top).offset(distance * -1)
        }
        
        errorTitle.snp.makeConstraints {
            $0.center.equalTo(view)
        }
        
        errorDescription.snp.makeConstraints {
            $0.top.equalTo(errorTitle.snp.bottom).offset(distance)
            $0.centerX.equalTo(view)
        }
    }
    
    private func setQuizTableViewDelegates() {
        quizTableView.delegate = self
        quizTableView.dataSource = self
    }
    
    private func setQuizTableViewConstraints() {
        quizTableView.snp.makeConstraints{
            $0.top.equalTo(funFactDescription.snp.bottom).offset(view.bounds.height * 0.0379)
            $0.leading.equalTo(view.snp.leading).inset(20)
            $0.trailing.equalTo(view.snp.trailing).inset(20)
            $0.bottom.equalTo(view.snp.bottom)
        }
    }
    
    private func setFunFactConstraints() {
        funFactTitle.snp.makeConstraints {
            $0.top.equalTo(getQuizzesButton.snp.bottom).offset(view.bounds.height * funFactFromButtonOffsetMultiplier)
            $0.width.equalTo(view).inset(elementInset)
            $0.centerX.equalTo(view)
        }
        funFactDescription.snp.makeConstraints {
            $0.top.equalTo(funFactTitle.snp.bottom)
            $0.width.equalTo(view).inset(elementInset)
            $0.centerX.equalTo(view)
        }
    }
    
    
    //MARK: - Additional functions
    private func numberOfNBAMentiones() -> Int {
        return quizzesMatrix.flatMap{$0.flatMap{$0.questions }
            .filter{ $0.question.contains("NBA")} }
            .count
    }
    
    @objc func getQuizzes() {
        if !errorTitle.isHidden {
            errorTitle.isHidden = true
            errorDescription.isHidden = true
            errorImageView.isHidden = true
            
            configureFunFact()
            configureTableView()
        }
        presenter.setViewDelegate(delegate: self)
        presenter.fetchQuizzes()
    }
}


//MARK: - Table View Setup
extension QuizzesViewController: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return quizzesMatrix.count
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let quiz = quizzesMatrix[indexPath.section][indexPath.row]
        makePreview(quiz: quiz)
    }
    
    func makePreview(quiz: Quiz) {
        //Mozemo umjesto quizStartVC-a prikazat PopUpView koji je napravljen u figmi, dostupan je samo u portrait modu
        /*let pop = PopupView(quiz: quiz)
        view.addSubview(pop)*/
        coordinator.showQuizStartVC(for: quiz)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return quizzesMatrix[section].count
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let returnedView = UIView(frame: CGRect(x: 0, y: 0, width: 134, height: 45)) //set these values as necessary
        returnedView.backgroundColor = UIColor.clear
        
        let label = UILabel(frame: CGRect(x: 0, y: -5, width: 134, height: 20))
        let str = quizzesMatrix[section].first?.category.rawValue ?? ""
        label.text = str.capitalizingFirstLetter()
        label.font = UIFont(name: Fonts.mainBold, size: 20)
        label.textColor = chooseQuizCategoryColor(quizCategory: quizzesMatrix[section].first?.category ?? .sport)
        returnedView.addSubview(label)
        

        return returnedView
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = quizTableView.dequeueReusableCell(withIdentifier: quizCellId) as! QuizCell
        let quiz = quizzesMatrix[indexPath.section][indexPath.row]
        
        cell.set(quiz: quiz)
        
        cell.backgroundColor = UIColor.clear
        cell.selectionStyle = .none
        
        return cell
    }
    
    func presentQuizzes(quizzes: [[Quiz]]) {
        quizzesMatrix = quizzes
        
        DispatchQueue.main.async {
            self.funFactDescription.attributedText = NSMutableAttributedString(string: "There are \(self.numberOfNBAMentiones()) questions that contain the word “NBA”", attributes: [NSAttributedString.Key.kern: 0.22])
            self.quizTableView.reloadData()
        }
    }
    
    @objc func themeChanged() {
        DispatchQueue.main.async {
            self.gradientLayer.colors = Theme.current.gradientColor
            self.getQuizzesButton.setTitleColor(Theme.current.buttonTextColor, for: .normal)
            self.tabBarItem.selectedImage = self.tabBarItem.selectedImage?.withTintColor(Theme.current.tabbarSelectedImageColor, renderingMode: .alwaysOriginal)
        }
    }
}
