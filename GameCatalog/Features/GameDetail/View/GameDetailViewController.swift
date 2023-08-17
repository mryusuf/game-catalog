//
//  GameDetailViewController.swift
//  GameCatalog
//
//  Created by Indra Permana on 16/08/23.
//

import UIKit

class GameDetailViewController: UIViewController {

    @IBOutlet weak var gameImageView: UIImageView!
    @IBOutlet weak var publisherLabel: UILabel!
    @IBOutlet weak var gameNameLabel: UILabel!
    @IBOutlet weak var gameReleaseLabel: UILabel!
    @IBOutlet weak var gameRatingLabel: UILabel!
    @IBOutlet weak var gamePlayedCountLabel: UILabel!
    @IBOutlet weak var gameDescriptionLabel: UILabel!

    @IBOutlet weak var loadingIndicator: UIActivityIndicatorView!

    @IBOutlet weak var errorView: UILabel!
    
    @IBOutlet weak var topStackView: UIStackView!
    
    private let viewModel: GameDetailViewModel
    
    init(viewModel: GameDetailViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("Error while initialize GameDetailViewController")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Game Detail"
        self.view.backgroundColor = .secondarySystemBackground
        
        Task {
            await fetchData()
        }
        
        setupFavoriteButton()
    }

}

/// Private functions
extension GameDetailViewController {
    private func fetchData() async {
        DispatchQueue.main.async { [weak self] in
            self?.loadingIndicator.startAnimating()
            self?.topStackView.isHidden = true
            self?.loadingIndicator.isHidden = false
            self?.errorView.isHidden = true
        }
        
        await viewModel.fetchGameDetail()
        
        if viewModel.errorMessage != "" {
            DispatchQueue.main.async { [weak self] in
                self?.loadingIndicator.stopAnimating()
                self?.errorView.isHidden = false
            }
        } else {
            DispatchQueue.main.async { [weak self] in
                self?.setupView()
                self?.loadingIndicator.stopAnimating()
                self?.errorView.isHidden = true
                self?.topStackView.isHidden = false
            }
        }
    }
    
    private func setupFavoriteButton() {
        
        let gameIsFavorite = viewModel.checkGameIsFavorite()
        let rightBarButton = UIBarButtonItem(image: .init(systemName: gameIsFavorite ? "heart.fill" : "heart"), style: .plain, target: self, action: #selector(favouriteButtonTapped))
        self.navigationItem.rightBarButtonItem = rightBarButton
    }
    
    private func setupView() {
        if let imageData = viewModel.gameDetail?.imageData, let image = UIImage(data: imageData) {
            gameImageView.image = image
        } else {
            gameImageView.load(url: viewModel.gameDetail?.imageURL)
        }
        publisherLabel.text = viewModel.gameDetail?.publisher
        gameNameLabel.text = viewModel.gameDetail?.name
        gameReleaseLabel.text = "Released \(viewModel.gameDetail?.releaseDate ?? "")"
        gameRatingLabel.text = viewModel.gameDetail?.rating
        gamePlayedCountLabel.text = "\(viewModel.gameDetail?.playedCount ?? "") played"
        gameDescriptionLabel.text = viewModel.gameDetail?.description
    }
    
    @objc private func favouriteButtonTapped() {
        print("favouriteButtonTapped")
        
        if !viewModel.isFavorite {
            viewModel.saveFavoriteGame()
        } else {
            viewModel.deleteFavoriteGame()
        }
        
        let rightBarButton = UIBarButtonItem(image: .init(systemName: viewModel.isFavorite ? "heart.fill" : "heart"), style: .plain, target: self, action: #selector(favouriteButtonTapped))
        self.navigationItem.rightBarButtonItem = rightBarButton
    }
}
