//
//  LeaderboardViewController.swift
//  QuizApp
//
//  Created by Mac Use on 06.05.2021..
//



/* Pojednostavit ću problem, tako da za svaki quiz fetcham
 isti leaderboard s interneta. Kreirao sam za ovu 2. DZ svoj .json file i uploadao ga na internet.
 Podatke fetcham iz njega, u kasnijim zadacama pretpostavljam da cemo koristiti neke "official"
 .json dokumente ili slicno.
 */

import UIKit
import SnapKit

class LeaderboardViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    //MARK: Constants
    private let tableViewRowHeight: CGFloat = 63
    private let leaderboardCellId: String = "leaderboardCell"
    
    //MARK: Code
    private var gradientLayer: CAGradientLayer!
    private var coordinator: MainCoordinatorPatternProtocol!
    private var leaderboardManager: LeaderboardManager!
    private var users: [User]? {
        didSet {
            self.leaderboardTableView.reloadData()
        }
    }
    
    private var leaderboardTableView = UITableView(frame: .zero)

        
    convenience init(coordinator: MainCoordinatorPatternProtocol) {
        self.init()
        
        self.coordinator = coordinator
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(false, animated: true)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        leaderboardManager = LeaderboardManager()
        leaderboardManager.fetchLeaderboard { (quiz) in
            DispatchQueue.main.async(execute: {
                self.users = quiz.users//quiz.users
                self.users?.sort{ $0.points > $1.points } //sortiram od najveceg prema najmanjem
            })
        }
        
        
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
    
    @objc private func returnToQuizStart() {
        coordinator.goBack()
    }

    
    private  func buildViews()  {
        gradientLayer = setBackgroundStyle(view)
        
        //MARK: Setting Navigation Bar
        navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        navigationController?.navigationBar.shadowImage = UIImage()
        navigationController?.view.backgroundColor = .clear
        
        navigationController?.navigationBar.tintColor = .white
        navigationItem.setHidesBackButton(true, animated: false)
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: ImageEnum.xmarkItem.image, style: .done, target: self, action: #selector(returnToQuizStart))
        navigationItem.titleView = NavigationTitleLabel(withText: "Leaderboard")
                
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
            $0.top.equalTo(view.snp.top).offset(view.bounds.height * 0.2127)
            $0.bottom.equalTo(view.snp.bottom)
        }
    }
    
    private func setLeaderboardTableViewDelegates() {
        leaderboardTableView.delegate = self
        leaderboardTableView.dataSource = self
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return users?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: LeaderboardCell = tableView.dequeueReusableCell(withIdentifier: leaderboardCellId, for: indexPath) as! LeaderboardCell
        let user = users?[indexPath.row]
        cell.set(place: indexPath.row + 1, username: user!.username, points: user!.points)
        
        return cell
    }
}

