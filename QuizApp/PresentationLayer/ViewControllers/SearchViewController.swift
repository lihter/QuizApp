//
//  SearchViewController.swift
//  QuizApp
//
//  Created by Mac Use on 13.04.2021..
//

import UIKit

class SearchViewController: UIViewController, TabBarThemeProtocol, SearchDelegate {
    //MARK: - Constants
    private let barFromTopOffsetMultiplier: CGFloat = 0.0948
    private let quizCellId: String = "quizCell"
    private let tableViewRowHeight: CGFloat = 153

    //MARK: - VC vars
    private var coordinator: MainCoordinatorPatternProtocol!
    private var gradientLayer = CAGradientLayer()
    private let presenter = QuizVCPresenter()
    private var searchBarView: SearchBarView!
    
    private var quizTableView = UITableView(frame: .zero, style: .grouped)
    private var quizzes: [Quiz] = []
    private var quizzesMatrix: [[Quiz]] = [[]]
    

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
                
        NotificationCenter.default.addObserver(self, selector: #selector(themeChanged), name: Notification.Name("NewTheme"), object: nil)
        
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self, name: Notification.Name("NewTheme"), object: nil)
    }
    
    //MARK: - Building Views and Constraints
    private func buildViews() {
        gradientLayer.setBackgroundStyle(view)

        //MARK: Search Bar View
        searchBarView = SearchBarView()
        searchBarView.setViewDelegate(delegate: self)
        
        view.layer.addSublayer(gradientLayer)
        view.addSubview(searchBarView)
        
        configureTableView()
    }
    
    private func addConstraints() {
        searchBarView.translatesAutoresizingMaskIntoConstraints = false
        searchBarView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        searchBarView.widthAnchor.constraint(equalTo: view.widthAnchor).isActive = true
        searchBarView.heightAnchor.constraint(equalToConstant: 44).isActive = true
        searchBarView.topAnchor.constraint(equalTo: view.topAnchor, constant: view.bounds.height * barFromTopOffsetMultiplier).isActive = true
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
    
    private func setQuizTableViewConstraints() {
        quizTableView.snp.makeConstraints{
            $0.top.equalTo(searchBarView.snp.bottom).offset(view.bounds.height * 0.0379)
            $0.leading.equalTo(view.snp.leading).inset(20)
            $0.trailing.equalTo(view.snp.trailing).inset(20)
            $0.bottom.equalTo(view.snp.bottom)
        }
    }
    
    private func setQuizTableViewDelegates() {
        quizTableView.delegate = self
        quizTableView.dataSource = self
    }
    
    //MARK: - Additional functions
    
    @objc func themeChanged() {
        DispatchQueue.main.async {
            self.gradientLayer.colors = Theme.current.gradientColor
            self.tabBarItem.selectedImage = self.tabBarItem.selectedImage?.withTintColor(Theme.current.tabbarSelectedImageColor, renderingMode: .alwaysOriginal)
        }
    }
    
    func handleSearch(forText: String?) {
        showFilteredQuizzes(filterString: forText)

        dismissKeyboard()
    }
    
    private func dismissKeyboard() {
        view.endEditing(true)
    }
    
    private func showFilteredQuizzes(filterString: String?) {
        let filter = FilterSettings(searchText: filterString)
        quizzes = presenter.filterRestaurants(filter: filter)
        quizzesMatrix = QuizManager.sortBySections(quizzes)
        quizTableView.reloadData()
    }
}

//MARK: - Table View Setup
extension SearchViewController: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return quizzesMatrix.count
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let quiz = quizzesMatrix[indexPath.section][indexPath.row]
        makePreview(quiz: quiz)
    }
    
    func makePreview(quiz: Quiz) {
        coordinator.showQuizStartVC(for: quiz)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return quizzesMatrix[section].count
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let returnedView = UIView(frame: CGRect(x: 0, y: 0, width: 134, height: 45))
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
}
