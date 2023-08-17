//
//  FavoriteGameListViewController.swift
//  GameCatalog
//
//  Created by Indra Permana on 17/08/23.
//

import UIKit
import CoreData

final class FavoriteGameListViewController: UIViewController {
    
    private lazy var tableView: UITableView = {
        let view = UITableView(frame: .zero)
        view.separatorStyle = .none
        view.dataSource = self
        view.delegate = self
        view.rowHeight = UITableView.automaticDimension
        view.estimatedRowHeight = 220
        view.register(GameTVCell.self, forCellReuseIdentifier: GameTVCell.identifier)
        return view
    }()
    
    private lazy var loadingIndicator: UIActivityIndicatorView = {
        let view = UIActivityIndicatorView(style: .large)
        view.hidesWhenStopped = true
        view.isHidden = true
        return view
    }()
    
    private var errorView: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 0;
        label.textAlignment = .center
        return label
    }()
    
    private lazy var repository: FavoriteGameRepository = {
       FavoriteGameRepositoryDefault(fetchedResultsControllerDelegate: self)
    }()
    
    private lazy var fetchedResultController: NSFetchedResultsController<FavoriteGame>? = {
        repository.fetchFavoriteGames()
    }()

    init() {
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("Error while initialize HomeViewController")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "Favorite Games"
        
        let newNavBarAppearance = customNavBarAppearance()
        self.navigationController?.navigationBar.scrollEdgeAppearance = newNavBarAppearance
        self.navigationController?.navigationBar.compactAppearance = newNavBarAppearance
        self.navigationController?.navigationBar.standardAppearance = newNavBarAppearance
        self.navigationController?.navigationBar.tintColor = .white
        
        self.view.backgroundColor = .secondarySystemBackground
        setupView()
        
    }
}

/// Private functions
extension FavoriteGameListViewController {
    func customNavBarAppearance() -> UINavigationBarAppearance {
        let customNavBarAppearance = UINavigationBarAppearance()
        
        // Apply a red background.
        customNavBarAppearance.configureWithOpaqueBackground()
        customNavBarAppearance.backgroundColor = .systemBrown
        
        // Apply white colored normal and large titles.
        customNavBarAppearance.titleTextAttributes = [.foregroundColor: UIColor.white]
        customNavBarAppearance.largeTitleTextAttributes = [.foregroundColor: UIColor.white]


        // Apply white color to all the nav bar buttons.
        let barButtonItemAppearance = UIBarButtonItemAppearance(style: .plain)
        barButtonItemAppearance.normal.titleTextAttributes = [.foregroundColor: UIColor.white]
        barButtonItemAppearance.disabled.titleTextAttributes = [.foregroundColor: UIColor.lightText]
        barButtonItemAppearance.highlighted.titleTextAttributes = [.foregroundColor: UIColor.label]
        barButtonItemAppearance.focused.titleTextAttributes = [.foregroundColor: UIColor.white]
        
        customNavBarAppearance.buttonAppearance = barButtonItemAppearance
        customNavBarAppearance.backButtonAppearance = barButtonItemAppearance
        customNavBarAppearance.doneButtonAppearance = barButtonItemAppearance
        
        return customNavBarAppearance
    }
    
    private func setupView() {
        setupTableView()
        setupLoadingIndicator()
        setupErrorView()
    }
    
    private func setupTableView() {
        view.addSubview(tableView)
        tableView.backgroundColor = .white
        tableView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            tableView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
        
    }
    
    private func setupLoadingIndicator() {
        view.addSubview(loadingIndicator)
        loadingIndicator.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            loadingIndicator.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            loadingIndicator.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
    }
    
    private func setupErrorView() {
        if fetchedResultController?.fetchedObjects?.count == 0 {
            errorView.text = "No Favorite Games"
        }
        tableView.addSubview(errorView)
        NSLayoutConstraint.activate([
            errorView.heightAnchor.constraint(equalToConstant: 80),
            errorView.widthAnchor.constraint(equalToConstant: 200),
            errorView.centerXAnchor.constraint(equalTo: tableView.centerXAnchor),
            errorView.centerYAnchor.constraint(equalTo: tableView.centerYAnchor),
        ])
    }
}

extension FavoriteGameListViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        140
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        fetchedResultController?.fetchedObjects?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: GameTVCell.identifier, for: indexPath) as? GameTVCell {
            
            guard (fetchedResultController?.fetchedObjects?.count ?? 0) >= indexPath.row,
                  let favoriteGame = fetchedResultController?.fetchedObjects?[indexPath.row]
            else {
                return UITableViewCell()
            }
            
            cell.setup(with: favoriteGame)
            
            cell.selectionStyle = .none
            return cell
        }
        
        return UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        guard (fetchedResultController?.fetchedObjects?.count ?? 0) >= indexPath.row,
              let favoriteGame = fetchedResultController?.fetchedObjects?[indexPath.row]
        else {
            return
        }
        /// navigate to GameDetail
        let gameDetail = GameDetailModel(
            id: Int(favoriteGame.gameId),
            name: favoriteGame.name ?? "",
            imageURL: nil,
            imageData: favoriteGame.image,
            publisher: favoriteGame.publishers ?? "",
            releaseDate: favoriteGame.releaseDate ?? "",
            rating: favoriteGame.rating ?? "",
            playedCount: favoriteGame.playedCount ?? "",
            description: favoriteGame.gameDescription ?? ""
        )
        
        let gameDetailVM = GameDetailViewModelDefault(gameId: Int(favoriteGame.gameId), gameDetail: gameDetail)
        let gameDetailVC = GameDetailViewController(viewModel: gameDetailVM)
        
        gameDetailVC.hidesBottomBarWhenPushed = true
        self.navigationController?.pushViewController(gameDetailVC, animated: true)
        
    }
    
}

extension FavoriteGameListViewController: NSFetchedResultsControllerDelegate {
    func controllerWillChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
            tableView.beginUpdates()
        }

        func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange sectionInfo: NSFetchedResultsSectionInfo, atSectionIndex sectionIndex: Int, for type: NSFetchedResultsChangeType) {
            switch type {
            case .insert:
                tableView.insertSections(IndexSet(integer: sectionIndex), with: .none)
            case .delete:
                tableView.deleteSections(IndexSet(integer: sectionIndex), with: .none)
            default:
                break
            }
        }

        func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {
            switch type {
            case .insert:
                tableView.insertRows(at: [newIndexPath!], with: .none)
            case .delete:
                tableView.deleteRows(at: [indexPath!], with: .none)
            case .move:
                tableView.deleteRows(at: [indexPath!], with: .none)
                tableView.insertRows(at: [newIndexPath!], with: .none)
            default:
                break
            }
            
            if fetchedResultController?.fetchedObjects?.count == 0 {
                errorView.text = "No Favorite Games"
            }
        }

        func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
            tableView.endUpdates()
        }
}
