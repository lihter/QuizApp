//
//  LeaderboardViewController.swift
//  QuizApp
//
//  Created by Mac Use on 06.05.2021..
//

import UIKit
import SnapKit

class LeaderboardViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, LeaderboardPresenterDelegate{
    
    //MARK: - Constants
    private let tableViewRowHeight: CGFloat = 63
    private let leaderboardCellId: String = "leaderboardCell"
    
    //MARK: - VC elements
    private var gradientLayer = CAGradientLayer()
    private var coordinator: MainCoordinatorPatternProtocol!
    private let presenter = LeaderboardPresenter()
    private var users: [LeaderboardResult] = []
    
    private var leaderboardTableView = UITableView(frame: .zero)

    //MARK: - Code
    convenience init(coordinator: MainCoordinatorPatternProtocol) {
        self.init()
        
        self.coordinator = coordinator
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        navigationController?.setNavigationBarHidden(true, animated: true)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        buildViews()
        addConstraints()
        
        presenter.setViewDelegate(delegate: self)
        presenter.fetchLeaderboard(withQuizId: coordinator.getQuiz().id)
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
                
        //MARK: Setting Table View
        setLeaderboardTableViewDelegates()
        leaderboardTableView.rowHeight = tableViewRowHeight
        leaderboardTableView.separatorColor = UIColor.white
        leaderboardTableView.backgroundColor = UIColor.clear
        leaderboardTableView.showsVerticalScrollIndicator = false
        leaderboardTableView.register(LeaderboardCell.self, forCellReuseIdentifier: leaderboardCellId)
        leaderboardTableView.tableFooterView = UIView()
        
        
        view.layer.addSublayer(gradientLayer)
        view.addSubview(leaderboardTableView)
    }
    
    private func updateConstraints() {
        gradientLayer.reloadBoundsForGradient(view)
    }
    
    private func addConstraints() {
        leaderboardTableView.snp.makeConstraints{
            $0.width.equalToSuperview()
            $0.top.equalTo(view.snp.top).offset(20)
            $0.bottom.equalTo(view.snp.bottom)
        }
    }
    
    //MARK: - Additional functions
    
    @objc private func returnToQuizStart() {
        coordinator.dismiss()
    }
    
    func presentLeaderboard(results: [LeaderboardResult]) {
        users = results
        
        DispatchQueue.main.async {
            self.leaderboardTableView.reloadData()
        }
    }
    
    
    
    //MARK: - Table View Setup
    private func setLeaderboardTableViewDelegates() {
        leaderboardTableView.delegate = self
        leaderboardTableView.dataSource = self
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return users.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: LeaderboardCell = tableView.dequeueReusableCell(withIdentifier: leaderboardCellId, for: indexPath) as! LeaderboardCell
        let user = users[indexPath.row]
        cell.set(place: indexPath.row + 1, username: user.username, points: String(user.score?.split(separator: ".").first ?? "0"))
        
        return cell
    }
}

