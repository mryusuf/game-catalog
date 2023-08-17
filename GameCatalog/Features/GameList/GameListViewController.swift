//
//  GameListViewController.swift
//  GameCatalog
//
//  Created by Indra Permana on 14/08/23.
//

import UIKit

final class GameListViewController: UIViewController {
    
    private lazy var searchBar: UISearchBar = {
        let view = UISearchBar()
        view.showsCancelButton = true
        view.delegate = self
        return view
    }()
    
    private lazy var tableView: UITableView = {
        let view = UITableView(frame: .zero)
        view.backgroundColor = .clear
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
    
    private var viewModel: GameListViewModel
    
    private var timer: Timer?

    init(viewModel: GameListViewModel = GameListViewModelDefault()) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("Error while initialize HomeViewController")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "Games For You"
        
        let newNavBarAppearance = customNavBarAppearance()
        self.navigationController?.navigationBar.scrollEdgeAppearance = newNavBarAppearance
        self.navigationController?.navigationBar.compactAppearance = newNavBarAppearance
        self.navigationController?.navigationBar.standardAppearance = newNavBarAppearance
        self.navigationController?.navigationBar.tintColor = .white
        
        self.view.backgroundColor = .secondarySystemBackground
        setupView()
        
        Task {
            await fetchData()
        }
    }
}

/// Private functions
extension GameListViewController {
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
    
    private func fetchData(next: Bool = false, query: String = "") async {
        
        if next {
            if viewModel.isSearchMode {
                guard (viewModel.nextSearchURL != nil) else { return }
            } else {
                guard (viewModel.nextURL != nil) else { return }
            }
        }
        
        DispatchQueue.main.async { [weak self] in
            self?.loadingIndicator.startAnimating()
            self?.loadingIndicator.isHidden = false
            self?.errorView.isHidden = true
        }
        
        if next {
            viewModel.isSearchMode ? await viewModel.fetchNextSearchGame(query: query) : await viewModel.fetchNextGameList()
        } else {
            viewModel.isSearchMode ? await viewModel.fetchSearchGame(query: query) : await viewModel.fetchGameList()
        }
        
        if viewModel.errorMessage != "" {
            DispatchQueue.main.async { [weak self] in
                self?.loadingIndicator.stopAnimating()
                self?.errorView.isHidden = false
            }
        } else {
            DispatchQueue.main.async { [weak self] in
                self?.tableView.reloadData()
                self?.loadingIndicator.stopAnimating()
                self?.errorView.isHidden = true
            }
        }
    }

    private func setupView() {
        setupSearchBar()
        setupTableView()
        setupLoadingIndicator()
        setupErrorView()
    }
    
    private func setupSearchBar() {
        view.addSubview(searchBar)
        searchBar.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            searchBar.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            searchBar.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            searchBar.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor)
        ])
    }
    
    private func setupTableView() {
        view.addSubview(tableView)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            tableView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            tableView.topAnchor.constraint(equalTo: searchBar.bottomAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
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
        tableView.addSubview(errorView)
        NSLayoutConstraint.activate([
            errorView.heightAnchor.constraint(equalToConstant: 80),
            errorView.widthAnchor.constraint(equalToConstant: 200),
            errorView.centerXAnchor.constraint(equalTo: tableView.centerXAnchor),
            errorView.centerYAnchor.constraint(equalTo: tableView.centerYAnchor),
        ])
    }
    
}

extension GameListViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        140
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        viewModel.isSearchMode ? viewModel.gameSearchResults.count : viewModel.gameList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: GameTVCell.identifier, for: indexPath) as? GameTVCell {
            if viewModel.isSearchMode {
                guard viewModel.gameSearchResults.count - 1 > indexPath.row else { return UITableViewCell() }
                cell.setup(with: viewModel.gameSearchResults[indexPath.row])
                
            } else {
                guard viewModel.gameList.count - 1 > indexPath.row else { return UITableViewCell() }
                cell.setup(with: viewModel.gameList[indexPath.row])

            }
            cell.selectionStyle = .none
            return cell
        }
        
        return UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        let lastIndex = viewModel.isSearchMode ? viewModel.gameSearchResults.count - 2 : viewModel.gameList.count - 2
        if indexPath.row == lastIndex {
            Task {
                await fetchData(next: true)
            }
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.searchBar.searchTextField.endEditing(true)
        
        /// navigate to GameDetail
        let selectedGame = viewModel.isSearchMode ? viewModel.gameSearchResults[indexPath.row] : viewModel.gameList[indexPath.row]
        let gameDetailVM = GameDetailViewModelDefault(gameId: selectedGame.id)
        let gameDetailVC = GameDetailViewController(viewModel: gameDetailVM)
        
        gameDetailVC.hidesBottomBarWhenPushed = true
        self.navigationController?.pushViewController(gameDetailVC, animated: true)
        
    }
}

extension GameListViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {

        if searchText.count >= 3 {
            Task {
                /// wait for 1,5 second
                try await Task.sleep(nanoseconds: 1_500_000_000)
                
                await fetchData(query: searchText)
            }
        }
    }
    
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        viewModel.isSearchMode = true
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        viewModel.isSearchMode = false
    }
}
