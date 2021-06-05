//
//  QuizCell.swift
//  QuizApp
//
//  Created by Mac Use on 13.04.2021..
//

import UIKit
import Cosmos // za rating

class QuizCell: UITableViewCell {

    //MARK: - Constants
    private let imageCornerRadius: CGFloat = 6
    private let descriptionFontSize: CGFloat = 14
    private let ratingImageFilledColor: UIColor = UIColor(red: 242/255, green: 201/255, blue: 76/255, alpha: 1)
    private let unfilledRatingColor: UIColor = UIColor.white.withAlphaComponent(0.3)
    
    private let totalNumberOfStars: Int = 3
    private let starHeight: Double = 9.71
    private let starDistance: Double = 4.29
    
    
    //MARK: - View elements
    private var quizImageView = UIImageView()
    private var quizTitleLabel = UILabel()
    private var quizDescriptionLabel = UILabel()
    private var starsView = CosmosView()
    private var quizCategoryColor = UIColor()
    
    //MARK: - Code
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        addSubview(cellView)
        
        NSLayoutConstraint.activate([
            cellView.topAnchor.constraint(equalTo: self.topAnchor, constant: 5),
            cellView.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            cellView.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            cellView.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -5)
        ])
        
        cellView.addSubview(quizImageView)
        cellView.addSubview(quizTitleLabel)
        cellView.addSubview(quizDescriptionLabel)
        cellView.addSubview(starsView)
        
        configureStarsView()
        configureImageView()
        configureTitleLabel()
        configureDescriptionLabel()
        
        setImageContstraints()
        setTitleLabelContstraints()
        setDescriptionLabelContstraints()
        setRatingConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - Building Views and Constraints
    private let cellView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.white.withAlphaComponent(0.3)
        view.layer.cornerRadius = 10
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private func configureStarsView() {
        starsView.settings.updateOnTouch = false
        //Ne radi .withTintColor (koji je unutar ovog enum-a koristen)
        //starsView.settings.filledImage = ImageEnum.coloredStar.image
        starsView.settings.filledImage = ImageEnum.filledStar.image
        starsView.settings.emptyImage =  ImageEnum.emptyStar.image
        
        starsView.settings.totalStars = totalNumberOfStars
        starsView.settings.starSize = starHeight
        starsView.settings.starMargin = starDistance
    }
    
    private func configureImageView() {
        quizImageView.layer.cornerRadius = imageCornerRadius
        quizImageView.contentMode = .scaleAspectFill
        quizImageView.clipsToBounds = true
    }
    
    private func configureTitleLabel() {
        quizTitleLabel.numberOfLines = 0
        
        //Nije napomenuto što u slučaju kada je ime duže od prostora za ispis naslova, ja sam pretpostavio da ovako treba, mogu lako promijeniti ako nije tako zamišljeno
        quizTitleLabel.lineBreakMode = .byWordWrapping
        
        quizTitleLabel.font = UIFont(name: Fonts.mainBold, size: titleLabelSize)
        quizTitleLabel.textColor = .white
        quizTitleLabel.textAlignment = .left

    }
    
    private func configureDescriptionLabel() {
        quizDescriptionLabel.numberOfLines = 0
        quizDescriptionLabel.lineBreakMode = .byWordWrapping
        
        quizDescriptionLabel.font = UIFont(name: Fonts.main, size: descriptionFontSize)
        quizDescriptionLabel.textColor = .white
        quizDescriptionLabel.textAlignment = .left
    }
    
    
    private func setImageContstraints() {
        //Ovaj put neću koristiti snapkit zbog vježbe ostalih alata
        quizImageView.translatesAutoresizingMaskIntoConstraints = false
        quizImageView.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        quizImageView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20).isActive = true
        quizImageView.heightAnchor.constraint(equalToConstant: 103).isActive = true
        quizImageView.widthAnchor.constraint(equalTo: quizImageView.heightAnchor, multiplier: 1).isActive = true
    }
    
    private func setTitleLabelContstraints() {
        //Ovaj put neću koristiti snapkit zbog vježbe ostalih alata
        quizTitleLabel.translatesAutoresizingMaskIntoConstraints = false
        quizTitleLabel.topAnchor.constraint(equalTo: quizImageView.topAnchor, constant: 6).isActive = true
        quizTitleLabel.leadingAnchor.constraint(equalTo: quizImageView.trailingAnchor, constant: 18).isActive = true //mozda je constant: 40
        quizTitleLabel.heightAnchor.constraint(equalToConstant: 25).isActive = true
        quizTitleLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -33).isActive = true
    }
    
    private func setDescriptionLabelContstraints() {
        //Ovaj put neću koristiti snapkit zbog vježbe ostalih alata
        quizDescriptionLabel.translatesAutoresizingMaskIntoConstraints = false
        quizDescriptionLabel.topAnchor.constraint(equalTo: quizTitleLabel.bottomAnchor, constant: -12).isActive = true
        quizDescriptionLabel.leadingAnchor.constraint(equalTo: quizImageView.trailingAnchor, constant: 18).isActive = true
        quizDescriptionLabel.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -35).isActive = true
        quizDescriptionLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -18).isActive = true
    }
    
    private func setRatingConstraints() {
        starsView.translatesAutoresizingMaskIntoConstraints = false
        starsView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -18).isActive = true
        starsView.bottomAnchor.constraint(equalTo: quizTitleLabel.topAnchor).isActive = true
    }
    
    //MARK: - Additional functions
    
    func set(quiz: Quiz) {
        quizImageView.load(url: URL(string: quiz.imageUrl)!)
        quizTitleLabel.text = quiz.title
        quizDescriptionLabel.attributedText = NSMutableAttributedString(string: quiz.description, attributes: [NSAttributedString.Key.kern: 0.1])
        quizCategoryColor = chooseQuizCategoryColor(quizCategory: quiz.category)
        starsView.rating = Double(quiz.level)
    }
}


