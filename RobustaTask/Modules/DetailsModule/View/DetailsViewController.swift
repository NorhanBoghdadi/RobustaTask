//
//  DetailsViewController.swift
//  RobustaTask
//
//  Created by Nourhan Boghdady on 08/04/2023.
//

import UIKit

class DetailsViewController: UIViewController {

    var repoData: ReposModelResponseElement
    private var detailsViewModel: DetailsViewModelProtocol?
    
    
    
    init(repoData: ReposModelResponseElement) {
        self.repoData = repoData
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        detailsViewModel?.getRepoDetails(url: repoData.url ?? "")
    }
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
}
