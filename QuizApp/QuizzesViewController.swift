//
//  QuizzesViewController.swift
//  QuizApp
//
//  Created by Mac Use on 13.04.2021..
//

import UIKit
import SnapKit

class QuizzesViewController: UIViewController {
    
    var titleLabel: PopQuizLabel!
    var getQuizzesButton: MenuButton!
    
    var errorImageView: UIImageView!
    var errorTitle: UILabel!
    var errorDescription: UILabel!
    
    var quizTableView = UITableView()
    var funFactTitle: UILabel!
    var funFactDescription: UILabel!
    
    let quizCellId: String = "quizCell"
    
    var quizzesMatrix: [[Quiz]] = [[]]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        buildViews()
        addConstraints()
        getQuizzesButton.addTarget(self, action: #selector(getQuizzes), for: .touchUpInside)
    }
    
    @objc func getQuizzes() {
        self.errorTitle.isHidden = true
        self.errorDescription.isHidden = true
        self.errorImageView.isHidden = true
        
        let dataService = DataService()
        quizzesMatrix = sortBySections(dataService.fetchQuizes())
        configureFunFact()
        configureTableView()
    }
    
    func configureFunFact() {
        
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
    
    func configureTableView() {
        view.addSubview(quizTableView)
        setQuizTableViewDelegates()
        quizTableView.rowHeight = tableViewRowHeight
        quizTableView.separatorColor = UIColor.clear
        quizTableView.backgroundColor = UIColor.clear
        quizTableView.showsVerticalScrollIndicator = false
        
        //Morao sam umetnuti ovaj kod kako bi se riješio sticky/floating section headera
        let dummyViewHeight = CGFloat(40)
        quizTableView.tableHeaderView = UIView(frame: CGRect(x: 0, y: 0, width: self.quizTableView.bounds.size.width, height: dummyViewHeight))
        quizTableView.contentInset = UIEdgeInsets(top: -dummyViewHeight, left: 0, bottom: 0, right: 0)
        
        
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
        errorImageView = UIImageView(image: UIImage(named: "errorImageFile.svg"))
        
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
    
    private func addConstraints() {
        titleLabel.snp.makeConstraints{
            $0.top.equalToSuperview().offset(titleLabelTopOffset)
            $0.centerX.equalTo(view)
        }
        
        getQuizzesButton.snp.makeConstraints {
            $0.width.equalTo(view).inset(buttonWidthInset)
            $0.height.equalTo(viewElementHeight)
            $0.top.equalTo(titleLabel.snp.bottom).offset(buttonFromTitleLabelOffset)
            $0.centerX.equalTo(view)
        }
        
        errorImageView.snp.makeConstraints {
            $0.centerX.equalTo(view)
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
    
    func setQuizTableViewDelegates() {
        quizTableView.delegate = self
        quizTableView.dataSource = self
    }
    
    func setQuizTableViewConstraints() {
        //Ne koristim snapkit sada da isprobam i druge alate
        quizTableView.translatesAutoresizingMaskIntoConstraints = false
        quizTableView.topAnchor.constraint(equalTo: funFactDescription.bottomAnchor, constant: 32).isActive = true
        quizTableView.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 20).isActive = true
        quizTableView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        quizTableView.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -20).isActive = true
    }
    
    func setFunFactConstraints() {
        funFactTitle.snp.makeConstraints {
            $0.top.equalTo(getQuizzesButton.snp.bottom).offset(funFactFromButtonOffset)
            $0.width.equalTo(view).inset(elementInset)
            $0.centerX.equalTo(view)
        }
        funFactDescription.snp.makeConstraints {
            $0.top.equalTo(funFactTitle.snp.bottom)
            $0.width.equalTo(view).inset(elementInset)
            $0.centerX.equalTo(view)
        }
    }
    
    func sortBySections(_ quizzes: [Quiz]) -> [[Quiz]] {
        var matrix = [[Quiz]]()
        for quiz in quizzes {
            if matrix.count == 0 {
                matrix.append([quiz])
            } else {
                var added = false
                var index: Int = 0
                for section in matrix{
                    if section.first!.category == quiz.category {
                        //section.append(quiz)
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
        }
        return matrix
    }
    
    private func numberOfNBAMentiones() -> Int {
        return quizzesMatrix.flatMap{$0.flatMap{$0.questions }
            .filter{ $0.question.contains("NBA")} }
            .count
    }
    
    //MARK: Constants
    let buttonOpacity: CGFloat = 1.0
    let distance: CGFloat = 10
    let tableViewFromFunFactTextOffset: CGFloat = 32
    let titleLabelTopOffset: CGFloat = 61
    let buttonFromTitleLabelOffset: CGFloat = 35
    let errorImageName: String = "multiply.circle"
    let errorImageDimensions: CGFloat = 67
    let errorTitleFontSize: CGFloat = 28
    let errorDescriptionWidth: CGFloat = 211
    let errorDescriptionHeight: CGFloat = 69
    let errorDescriptionFontSize: CGFloat = 16
    let tableViewRowHeight: CGFloat = 153
    let funFactDescriptionFontSize: CGFloat = 18
    let funFactFromButtonOffset: CGFloat = 55
    let elementInset: CGFloat = 24
    let previewAlphaComponent: CGFloat = 0.6
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
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return quizzesMatrix[section].count
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let returnedView = UIView(frame: CGRect(x: 0, y: 0, width: 134, height: 28)) //set these values as necessary
        returnedView.backgroundColor = UIColor.clear
        
        let label = UILabel(frame: CGRect(x: 0, y: 0, width: 134, height: 28))
        let str = self.quizzesMatrix[section].first!.category.rawValue
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
