//
//  ReposTableViewCell.swift
//  RobustaTask
//
//  Created by Nourhan Boghdady on 07/04/2023.
//

import UIKit

class ReposTableViewCell: UITableViewCell {
    
    private lazy var avatarImageView: UIImageView = {
        let imgView = UIImageView()
        imgView.translatesAutoresizingMaskIntoConstraints = false
        imgView.layer.cornerRadius = Constants.padding
        imgView.clipsToBounds = true
        imgView.layer.borderWidth = 1
        imgView.layer.masksToBounds = false
        return imgView
    }()
    

    private lazy var repoNameLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: Constants.fontSize, weight: .bold)
        label.textColor = .black
        label.textAlignment = .left
        label.numberOfLines = 0

        return label
    }()
    
    private lazy var repoOwnerLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: Constants.fontSize, weight: .regular)
        label.textColor = .black
        label.textAlignment = .left
        label.numberOfLines = 0
        return label
    }()
    
    private lazy var dateCreatedLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: Constants.fontSize, weight: .regular)
        label.textColor = .darkGray
        label.textAlignment = .left
        label.numberOfLines = 0

        return label
    }()
    

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupView() {
        contentView.addSubview(avatarImageView)
        contentView.addSubview(repoNameLabel)
        contentView.addSubview(repoOwnerLabel)
        contentView.addSubview(dateCreatedLabel)
        
        setupConstraints()
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            avatarImageView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            avatarImageView.leadingAnchor.constraint(equalTo: contentView.safeAreaLayoutGuide.leadingAnchor, constant: Constants.padding),
            avatarImageView.heightAnchor.constraint(equalTo: contentView.safeAreaLayoutGuide.heightAnchor, multiplier: Constants.largeMultiplier),
            avatarImageView.widthAnchor.constraint(equalTo: avatarImageView.heightAnchor)
        ])
        
        NSLayoutConstraint.activate([
            repoNameLabel.leadingAnchor.constraint(equalTo: avatarImageView.trailingAnchor, constant: Constants.padding),
            repoNameLabel.trailingAnchor.constraint(equalTo: contentView.safeAreaLayoutGuide.trailingAnchor, constant: -(Constants.padding)),
            repoNameLabel.topAnchor.constraint(equalTo: avatarImageView.topAnchor, constant: Constants.padding)
            
        ])
        
        NSLayoutConstraint.activate([
            repoOwnerLabel.leadingAnchor.constraint(equalTo: repoNameLabel.leadingAnchor),
            repoOwnerLabel.trailingAnchor.constraint(equalTo: contentView.safeAreaLayoutGuide.trailingAnchor, constant: -(Constants.padding)),
            repoOwnerLabel.topAnchor.constraint(equalTo: repoNameLabel.bottomAnchor, constant: Constants.padding)
        ])
        
        NSLayoutConstraint.activate([
            dateCreatedLabel.leadingAnchor.constraint(equalTo: repoNameLabel.leadingAnchor),
            dateCreatedLabel.trailingAnchor.constraint(equalTo: contentView.safeAreaLayoutGuide.trailingAnchor, constant: -(Constants.padding)),
            dateCreatedLabel.topAnchor.constraint(equalTo: repoOwnerLabel.bottomAnchor, constant: Constants.padding)
        ])
    }
    
    func configure(for repo: ReposModelResponseElement) {
        avatarImageView.image = UIImage(systemName: "heart.fill") //TODO: image loader function
        repoNameLabel.text = "Repository Name: \(repo.name ?? "")"
        repoOwnerLabel.text = "Repository Owner: \(repo.owner?.login ?? "")"
        dateCreatedLabel.text = "Date of creation: 4 month ago." //TODO: Find the date
        
    }
}


