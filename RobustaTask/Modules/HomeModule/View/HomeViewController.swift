//
//  ViewController.swift
//  RobustaTask
//
//  Created by Nourhan Boghdady on 07/04/2023.
//

import UIKit
import Combine

struct HomeViewConstants {
    static let padding = 10.0
    static let smallMultiplier = 0.3
    static let largeMultiplier = 0.75
    static let fontSize = 15.0
    static let homeTableViewReuseId = "HOMEVIEWIDEN"
    static let placeHolder = "Search by repo's name"
    static let barHeight = 40.0
}

class HomeViewController: UIViewController {
    private var homeViewModel: HomeViewModel
    var subscriptions = Set<AnyCancellable>()
    var searchActive : Bool = false

    private lazy var reposTableView: UITableView = {
        let tableView = UITableView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(ReposTableViewCell.self, forCellReuseIdentifier: HomeViewConstants.homeTableViewReuseId)
        return tableView

    }()
    
    let refreshControl = UIRefreshControl()

    private lazy var reposSearchBar: UISearchBar = {
        let searchBar = UISearchBar()
        searchBar.translatesAutoresizingMaskIntoConstraints = false
        searchBar.searchTextField.borderStyle = .none
        searchBar.searchTextField.layer.cornerRadius = HomeViewConstants.padding
        searchBar.searchTextField.backgroundColor = UIColor(red: 1, green: 1, blue: 1, alpha: 0.45)
        searchBar.searchTextField.textColor = .black
        searchBar.searchTextField.tintColor = .black
        searchBar.returnKeyType = .search
        searchBar.enablesReturnKeyAutomatically = true
        searchBar.autocapitalizationType = .none
        searchBar.searchTextField.attributedPlaceholder = NSAttributedString(string: HomeViewConstants.placeHolder)
        searchBar.delegate = self
        return searchBar
    }()
    
    init(homeViewModel: HomeViewModel) {
        self.homeViewModel = homeViewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        homeViewModel.getAllRepos()
        setupViews()
        
        
    }
    
    private func setupViews() {
        view.addSubview(reposTableView)
        reposTableView.addSubview(refreshControl)
        refreshControl.addTarget(self, action: #selector(refresh), for: .valueChanged)

        homeViewModel.$allRepos
            .receive(on: DispatchQueue.main)
            .sink { [weak self] items in
               self?.reposTableView.reloadData()
            }
            .store(in: &subscriptions)
        
        homeViewModel.$filteredRepos
            .receive(on: DispatchQueue.main)
            .sink { [weak self] items in
               self?.reposTableView.reloadData()
            }
            .store(in: &subscriptions)
        
        view.addSubview(reposSearchBar)
        setupConstraints()

    }

    private func setupConstraints() {
        NSLayoutConstraint.activate([
            reposSearchBar.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: HomeViewConstants.padding),
            reposSearchBar.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: HomeViewConstants.padding),
            reposSearchBar.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -(HomeViewConstants.padding)),
            reposSearchBar.heightAnchor.constraint(equalToConstant: HomeViewConstants.barHeight)
        ])
        
        NSLayoutConstraint.activate([
            reposTableView.topAnchor.constraint(equalTo: reposSearchBar.bottomAnchor, constant: HomeViewConstants.padding),
            reposTableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            reposTableView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            reposTableView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
        ])
    }
    @objc private func refresh() {
        homeViewModel.getAllRepos()
    }

}

// MARK: - Handle TableView
extension HomeViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return searchActive ? homeViewModel.filteredRepos.count : homeViewModel.allRepos.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 200
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = reposTableView.dequeueReusableCell(withIdentifier: HomeViewConstants.homeTableViewReuseId, for: indexPath) as! ReposTableViewCell
    
        let model = searchActive ? homeViewModel.filteredRepos[indexPath.row] : homeViewModel.allRepos[indexPath.row]
        cell.configure(for: model)
        
        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let model = searchActive ? homeViewModel.filteredRepos[indexPath.row] : homeViewModel.allRepos[indexPath.row]

        let vc = DetailsViewController(repoData: model)
        present(vc, animated: true)
    }
}

// MARK: - Handle SearchBar

extension HomeViewController: UISearchBarDelegate {
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        searchBar.showsCancelButton = true
    }

    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchActive = false
        reposSearchBar.text = ""
        searchBar.resignFirstResponder()
        searchBar.showsCancelButton = false
        self.reposTableView.reloadData()
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        
        if searchBar.text?.count ?? 0 >= 2 {
            searchActive = true
            searchBar.resignFirstResponder()
            homeViewModel.searchRepos(by: searchBar.text ?? "")
            self.reposTableView.reloadData()
            searchBar.showsCancelButton = false
            
        }
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchBar.text?.count ?? 0 >= 2 {
            searchActive = true
            searchBar.resignFirstResponder()
            homeViewModel.searchRepos(by: searchBar.text ?? "")
            self.reposTableView.reloadData()

        } else {
            searchActive = false
            self.reposTableView.reloadData()
        }
    }
}

