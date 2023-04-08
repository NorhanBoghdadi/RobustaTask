//
//  DetailsViewController.swift
//  RobustaTask
//
//  Created by Nourhan Boghdady on 08/04/2023.
//

import UIKit
import Combine

struct DetailsViewConstants {
    static let padding = 10.0
    static let largeFontSize = 20.0
    static let smallFontSize = 15.0
}
class DetailsViewController: UIViewController {

    var repoData: ReposModelResponseElement
    private var detailsViewModel: DetailsViewModel
    var subscriptions = Set<AnyCancellable>()
    
    private lazy var avatarImageView: UIImageView = {
        let imgView = UIImageView()
        imgView.translatesAutoresizingMaskIntoConstraints = false
        imgView.layer.cornerRadius = imgView.bounds.width / 2
        imgView.clipsToBounds = true
        imgView.layer.borderWidth = 1
//        imgView.layer.masksToBounds = false
        return imgView
    }()
    

    private lazy var repoNameLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: DetailsViewConstants.largeFontSize, weight: .bold)
        label.textColor = .black
        label.textAlignment = .left
        label.numberOfLines = 0
        label.text = repoData.fullName ?? ""
        return label
    }()

    private lazy var descriptionLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: DetailsViewConstants.smallFontSize, weight: .regular)
        label.textColor = .black
        label.textAlignment = .left
        label.numberOfLines = 0
        label.text = repoData.description ?? ""
        return label
    }()
    
    private lazy var languageLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: DetailsViewConstants.smallFontSize, weight: .regular)
        label.textColor = .black
        label.textAlignment = .left
        label.numberOfLines = 0
        return label
    }()
    
    private lazy var lineView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.layer.borderWidth = 1.0
        view.layer.borderColor = UIColor.black.cgColor
        return view
    }()
    
    private lazy var forksNumberLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: DetailsViewConstants.smallFontSize, weight: .regular)
        label.textColor = .black
        label.textAlignment = .left
        label.numberOfLines = 0
        return label
    }()
    
    
    init(repoData: ReposModelResponseElement, detailsViewModel: DetailsViewModel) {
        self.repoData = repoData
        self.detailsViewModel = detailsViewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        detailsViewModel.getRepoDetails(url: repoData.url ?? "")
        setupViews()
        bindData()
    }
    
    private func setupViews() {
        view.backgroundColor = .white
//        view.addSubview(avatarImageView)
        view.addSubview(repoNameLabel)
        view.addSubview(descriptionLabel)
        view.addSubview(languageLabel)
        view.addSubview(lineView)
        view.addSubview(forksNumberLabel)
        
        setupConstraints()
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            repoNameLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: DetailsViewConstants.padding),
            repoNameLabel.centerXAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerXAnchor)
        ])
        
        NSLayoutConstraint.activate([
            descriptionLabel.topAnchor.constraint(equalTo: repoNameLabel.bottomAnchor, constant: DetailsViewConstants.padding),
            descriptionLabel.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: DetailsViewConstants.padding),
            descriptionLabel.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -(DetailsViewConstants.padding))
        ])
        
        NSLayoutConstraint.activate([
            lineView.topAnchor.constraint(equalTo: descriptionLabel.bottomAnchor, constant: DetailsViewConstants.padding),
            lineView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: DetailsViewConstants.padding),
            lineView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -(DetailsViewConstants.padding)),
            lineView.heightAnchor.constraint(equalToConstant: 1)
        ])
        
        NSLayoutConstraint.activate([
            languageLabel.topAnchor.constraint(equalTo: lineView.bottomAnchor, constant: DetailsViewConstants.padding),
            languageLabel.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: DetailsViewConstants.padding),
            languageLabel.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -(DetailsViewConstants.padding))
        ])
        
        NSLayoutConstraint.activate([
            forksNumberLabel.topAnchor.constraint(equalTo: languageLabel.bottomAnchor, constant: DetailsViewConstants.padding),
            forksNumberLabel.leadingAnchor.constraint(equalTo: languageLabel.leadingAnchor),
            forksNumberLabel.trailingAnchor.constraint(equalTo: languageLabel.trailingAnchor)
        ])
    }
    
    private func bindData() {
        detailsViewModel.$repoDetails
            .receive(on: DispatchQueue.main)
            .sink { [weak self] items in
                self?.languageLabel.text = "Language: \(self?.detailsViewModel.repoDetails?.language ?? "")"
                self?.forksNumberLabel.text = "Forks: \(self?.detailsViewModel.repoDetails?.forksCount ?? 0)"
            }
            .store(in: &subscriptions)
        
    }
}
