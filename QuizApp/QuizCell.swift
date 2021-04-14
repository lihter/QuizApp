//
//  QuizCell.swift
//  QuizApp
//
//  Created by Mac Use on 13.04.2021..
//

import UIKit
import Cosmos // za rating

class QuizCell: UITableViewCell {
    
    var quizImageView = UIImageView()
    var quizTitleLabel = UILabel()
    var quizDescriptionLabel = UILabel()
    var starsView = CosmosView()
    var quizCategoryColor = UIColor()
    
    let cellView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.white.withAlphaComponent(0.3)
        view.layer.cornerRadius = 10
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        addSubview(cellView)
        
        NSLayoutConstraint.activate([
            cellView.topAnchor.constraint(equalTo: self.topAnchor, constant: 5),
            cellView.rightAnchor.constraint(equalTo: self.rightAnchor),
            cellView.leftAnchor.constraint(equalTo: self.leftAnchor),
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
    
    func set(quiz: Quiz) {
        quizImageView.load(url: URL(string: quiz.imageUrl)!) //popraviti jer bude se mozda precesto crashalo, takoder mozda se previse puta loada ista slika????
        quizTitleLabel.text = quiz.title
        quizDescriptionLabel.attributedText = NSMutableAttributedString(string: quiz.description, attributes: [NSAttributedString.Key.kern: 0.1])
        quizCategoryColor = chooseQuizCategoryColor(quiz: quiz)
        starsView.rating = Double(quiz.level)
    }
    
    func configureStarsView() {
        starsView.settings.updateOnTouch = false
        //Ne radi mi .withTintColor
        //starsView.settings.filledImage = UIImage(named: ratingImage)?.withTintColor(quizCategoryColor, renderingMode: .alwaysTemplate)
        starsView.settings.filledImage = UIImage(named: "ratingStarFilled.svg")
        starsView.settings.emptyImage = UIImage(named: ratingImage)
        
        starsView.settings.totalStars = totalNumberOfStars
        starsView.settings.starSize = starHeight
        starsView.settings.starMargin = starDistance
    }
    
    func configureImageView() {
        quizImageView.layer.cornerRadius = imageCornerRadius
        quizImageView.clipsToBounds = true
    }
    
    func configureTitleLabel() {
        quizTitleLabel.numberOfLines = 0
        
        //Nije napomenuto što u slučaju kada je ime duže od prostora za ispis naslova, ja sam pretpostavio da ovako treba, mogu lako promijeniti ako nije tako zamišljeno
        quizTitleLabel.lineBreakMode = .byWordWrapping
        //quizTitleLabel.adjustsFontSizeToFitWidth = true
        
        quizTitleLabel.font = UIFont(name: Fonts.mainBold, size: titleLabelSize)
        quizTitleLabel.textColor = .white
        quizTitleLabel.textAlignment = .left

    }
    
    func configureDescriptionLabel() {
        quizDescriptionLabel.numberOfLines = 0
        quizDescriptionLabel.lineBreakMode = .byWordWrapping
        
        quizDescriptionLabel.font = UIFont(name: Fonts.main, size: descriptionFontSize)
        quizDescriptionLabel.textColor = .white
        quizDescriptionLabel.textAlignment = .left
    }
    
    
    func setImageContstraints() {
        //Ovaj put neću koristiti snapkit zbog vježbe ostalih alata
        quizImageView.translatesAutoresizingMaskIntoConstraints = false
        quizImageView.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        quizImageView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20).isActive = true
        quizImageView.heightAnchor.constraint(equalToConstant: 103).isActive = true
        quizImageView.widthAnchor.constraint(equalTo: quizImageView.heightAnchor, multiplier: 1).isActive = true
    }
    
    func setTitleLabelContstraints() {
        //Ovaj put neću koristiti snapkit zbog vježbe ostalih alata
        quizTitleLabel.translatesAutoresizingMaskIntoConstraints = false
        quizTitleLabel.topAnchor.constraint(equalTo: quizImageView.topAnchor, constant: 6).isActive = true
        //quizTitleLabel.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        quizTitleLabel.leadingAnchor.constraint(equalTo: quizImageView.trailingAnchor, constant: 18).isActive = true //mozda je constant: 40
        quizTitleLabel.heightAnchor.constraint(equalToConstant: 25).isActive = true
        quizTitleLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -33).isActive = true
    }
    
    func setDescriptionLabelContstraints() {
        //Ovaj put neću koristiti snapkit zbog vježbe ostalih alata
        quizDescriptionLabel.translatesAutoresizingMaskIntoConstraints = false
        quizDescriptionLabel.topAnchor.constraint(equalTo: quizTitleLabel.bottomAnchor, constant: -12).isActive = true
        //quizDescriptionLabel.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        quizDescriptionLabel.leadingAnchor.constraint(equalTo: quizImageView.trailingAnchor, constant: 18).isActive = true
        quizDescriptionLabel.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -35).isActive = true
        quizDescriptionLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -18).isActive = true
    }
    
    func setRatingConstraints() {
        //starsView.centerInSuperview()
        starsView.translatesAutoresizingMaskIntoConstraints = false
        starsView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -18).isActive = true
        starsView.bottomAnchor.constraint(equalTo: quizTitleLabel.topAnchor).isActive = true
    }
    
    
    //MARK: Constants
    let imageCornerRadius: CGFloat = 6
    let descriptionFontSize: CGFloat = 14
    let ratingImage: String = "ratingStar.svg"
    let ratingImageFilledColor: UIColor = UIColor(red: 242/255, green: 201/255, blue: 76/255, alpha: 1)
    let unfilledRatingColor: UIColor = UIColor.white.withAlphaComponent(0.3)
    
    let totalNumberOfStars: Int = 3
    let starHeight: Double = 9.71
    let starDistance: Double = 4.29
}

extension UIImageView {
    func load(url: URL) {
        DispatchQueue.global().async { [weak self] in
            if let data = try? Data(contentsOf: url) {
                if let image = UIImage(data: data) {
                    DispatchQueue.main.async {
                        self?.image = image
                    }
                }
            }
        }
    }
}
