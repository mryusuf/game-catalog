//
//  GameTVCell.swift
//  GameCatalog
//
//  Created by Indra Permana on 15/08/23.
//

import UIKit

final class GameTVCell: UITableViewCell {
    
    private lazy var gameImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.layer.cornerRadius = 10
        imageView.layer.masksToBounds = true
        imageView.contentMode = .scaleAspectFill
        return imageView
    }()
    
    private lazy var nameLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .systemFont(ofSize: 16, weight: .heavy)
        label.numberOfLines = 2
        return label
    }()
    
    private lazy var releaseDateLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .preferredFont(forTextStyle: .caption1)
        label.textColor = .darkGray
        return label
    }()
    
    private lazy var ratingLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .preferredFont(forTextStyle: .caption1)
        label.textColor = .darkGray
        return label
    }()
    
    private lazy var ratingIcon: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.image = .init(systemName: "star.fill")
        imageView.tintColor = .systemYellow
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func setup(with model: GameTVModel) {
        gameImageView.load(url: model.imageURL)
        nameLabel.text = model.name
        releaseDateLabel.text = "Release date: \(model.releaseDate)"
        ratingLabel.text = model.rating
        
        setupView()
    }

    
    func setup(with favoriteGame: FavoriteGame) {
        if let imageData = favoriteGame.image {
            gameImageView.image = UIImage(data: imageData)
        }
        nameLabel.text = favoriteGame.name
        releaseDateLabel.text = "Release date: \(favoriteGame.releaseDate ?? "")"
        ratingLabel.text = favoriteGame.rating
        
        setupView()
    }
    
    private func setupView() {
        
        contentView.addSubview(gameImageView)
        contentView.addSubview(nameLabel)
        contentView.addSubview(releaseDateLabel)
        contentView.addSubview(ratingIcon)
        contentView.addSubview(ratingLabel)
        
        NSLayoutConstraint.activate([
            gameImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            gameImageView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 10),
            gameImageView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -10),
            gameImageView.heightAnchor.constraint(equalToConstant: 120),
            
            nameLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 10),
            nameLabel.leadingAnchor.constraint(equalTo: gameImageView.trailingAnchor, constant: 8),
            nameLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -10),
            nameLabel.widthAnchor.constraint(equalToConstant: 180),
            
            releaseDateLabel.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: 2),
            releaseDateLabel.leadingAnchor.constraint(equalTo: gameImageView.trailingAnchor, constant: 8),
            releaseDateLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -10),
            releaseDateLabel.heightAnchor.constraint(equalToConstant: 20),
            releaseDateLabel.widthAnchor.constraint(equalToConstant: 180),
            
            ratingIcon.topAnchor.constraint(equalTo: releaseDateLabel.bottomAnchor, constant: 4),
            ratingIcon.leadingAnchor.constraint(equalTo: gameImageView.trailingAnchor, constant: 8),
            ratingIcon.heightAnchor.constraint(equalToConstant: 15),
            ratingIcon.widthAnchor.constraint(equalToConstant: 14),
           
            ratingLabel.topAnchor.constraint(equalTo: releaseDateLabel.bottomAnchor, constant: 4),
            ratingLabel.leadingAnchor.constraint(equalTo: ratingIcon.trailingAnchor, constant: 2),
            ratingLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -10),
        ])
    }

}
