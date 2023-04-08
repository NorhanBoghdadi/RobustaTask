//
//  DetailsViewModel.swift
//  RobustaTask
//
//  Created by Nourhan Boghdady on 08/04/2023.
//

import Foundation
import Combine

protocol DetailsViewModelProtocol: AnyObject {
    func getRepoDetails(url: String)
    var repoDetails: RepoDetailsResponse? {get}
}

class DetailsViewModel: DetailsViewModelProtocol {
    var repoDetails: RepoDetailsResponse?
    var subscriptions = Set<AnyCancellable>()
    
    func getRepoDetails(url: String) {
        let service = GetRepoDetailsService()
        service.getRepoDetails(url: url)
            .receive(on: DispatchQueue.main)
            .sink { (completion) in
                switch completion {
                    case .failure(let error):
                        print("oops got an error \(error.localizedDescription)")
                    case .finished:
                        print("nothing much to do here")
                    }
                } receiveValue: { [weak self] (response) in
                    print("got my response here \(response)")
                    self?.repoDetails = response
                }
                .store(in: &subscriptions)

    }
    
}
