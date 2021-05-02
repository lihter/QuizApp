//
//  QuizzesViewController.swift
//  QuizApp
//
//  Created by Mac Use on 13.04.2021..
//

import UIKit
import SnapKit

class QuizzesViewController: UIViewController {
    
    //MARK: Constants
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
    
    
    //MARK:Code
    private var titleLabel: PopQuizLabel!
    private var getQuizzesButton: MenuButton!
    
    private var errorImageView: UIImageView!
    private var errorTitle: UILabel!
    private var errorDescription: UILabel!
    
    private var quizTableView = UITableView(frame: .zero, style: .grouped)
    private var funFactTitle: UILabel!
    private var funFactDescription: UILabel!
    
    private let quizCellId: String = "quizCell"
    
    private var quizzesMatrix: [[Quiz]] = [[]]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        buildViews()
        addConstraints()
        getQuizzesButton.addTarget(self, action: #selector(getQuizzes), for: .touchUpInside)
    }
    
    @objc func getQuizzes() {
        if !errorTitle.isHidden {
            errorTitle.isHidden = true
            errorDescription.isHidden = true
            errorImageView.isHidden = true
        }
        
        let dataService = DataService()
        quizzesMatrix = sortBySections(dataService.fetchQuizes())
        configureFunFact()
        configureTableView()
    }
    
    override func updateViewConstraints() {
        super.updateViewConstraints()
        updateConstraints()
    }
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)
        view.setNeedsUpdateConstraints()
    }
    
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
        let numberOfNBA: Int = numberOfNBAMentiones()
        funFactDescription.numberOfLines = 0
        funFactDescription.lineBreakMode = .byWordWrapping
        funFactDescription.attributedText = NSMutableAttributedString(string: "There are \(numberOfNBA) questions that contain the word “NBA”",
                                                                    attributes: [NSAttributedString.Key.kern: 0.22])
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
        
        //Morao sam umetnuti ovaj kod kako bi se riješio sticky/floating section headera
        /*let dummyViewHeight = CGFloat(40)
        quizTableView.tableHeaderView = UIView(frame: CGRect(x: 0, y: 0, width: self.quizTableView.bounds.size.width, height: dummyViewHeight))
        quizTableView.contentInset = UIEdgeInsets(top: -dummyViewHeight, left: 0, bottom: 0, right: 0)*/
        
        
        quizTableView.register(QuizCell.self, forCellReuseIdentifier: quizCellId)
        setQuizTableViewConstraints()
    }
    
    private func buildViews()  {
        setBackgroundStyle(view, style)
        
        //MARK: Get Quizzes Button
        getQuizzesButton = MenuButton(style)
        getQuizzesButton.setTitle("Get Quiz", for: .normal)
        getQuizzesButton.alpha = buttonOpacity
        
        //MARK: Title Pop Quiz Label
        titleLabel = PopQuizLabel(size: titleLabelSize)
        
        //MARK: Error message elements
        //Mogu sliku uzeti i iz SF Symbols, ali sam ju odlucio ovako importat da primjenim i ovu opciju
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
        //Ne koristim snapkit sada da isprobam i druge alate
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
    
    private func sortBySections(_ quizzes: [Quiz]) -> [[Quiz]] {
        /*var matrix = [[Quiz]]()
        for quiz in quizzes { // citljivije ostvariti ovu fju
            if matrix.count == 0 {
                matrix.append([quiz])
            } else {
                var added = false
                var index: Int = 0
                for section in matrix{
                    if section.first!.category == quiz.category {
                        added = true
                        break
                    }
                    index = index + 1
                }
                if added == false {
                    matrix.append([quiz])
                } else {
                    matrix[index].append(quiz)
                }
            }
        }*/
        let groupedDict = Dictionary(grouping: quizzes, by: { $0.category })
        let array2d = groupedDict.map({ $0.value })
        return array2d
    }
    
    private func numberOfNBAMentiones() -> Int {
        return quizzesMatrix.flatMap{$0.flatMap{$0.questions }
            .filter{ $0.question.contains("NBA")} }
            .count
    }
}

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
        let pop = PopupView(quiz: quiz)
        view.addSubview(pop)
        //pinati pop na sve edgeve i maknuti uiscreen.frame
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return quizzesMatrix[section].count
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let returnedView = UIView(frame: CGRect(x: 0, y: 0, width: 134, height: 45)) //set these values as necessary
        returnedView.backgroundColor = UIColor.clear
        
        let label = UILabel(frame: CGRect(x: 0, y: -5, width: 134, height: 20))
        let str = quizzesMatrix[section].first!.category.rawValue
        label.text = str.capitalizingFirstLetter()
        label.font = UIFont(name: Fonts.mainBold, size: 20)
        label.textColor = chooseQuizCategoryColor(quiz: quizzesMatrix[section].first!)
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
}

extension String {
    func capitalizingFirstLetter() -> String {
        return prefix(1).capitalized + dropFirst().lowercased()
    }

    mutating func capitalizeFirstLetter() {
        self = self.capitalizingFirstLetter()
    }
}
