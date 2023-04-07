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
}

class HomeViewController: UIViewController {
    private var homeViewModel: HomeViewModel
    var subscriptions = Set<AnyCancellable>()

    private lazy var reposTableView: UITableView = {
        let tableView = UITableView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(ReposTableViewCell.self, forCellReuseIdentifier: HomeViewConstants.homeTableViewReuseId)
        return tableView

    }()
    
    let refreshControl = UIRefreshControl()

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
        
        setupConstraints()

    }

    private func setupConstraints() {
        //TODO: add searchbar
        
        NSLayoutConstraint.activate([
            reposTableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
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
        return homeViewModel.numberOfRepos
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 200
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = reposTableView.dequeueReusableCell(withIdentifier: HomeViewConstants.homeTableViewReuseId, for: indexPath) as! ReposTableViewCell
    
        let model = homeViewModel.searchActive ? homeViewModel.filteredRepos[indexPath.row] : homeViewModel.allRepos[indexPath.row]
        cell.configure(for: model)
        
        return cell
    }

}

// MARK: - Handle SearchBar
