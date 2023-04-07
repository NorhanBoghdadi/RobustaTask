//
//  HomeViewModel.swift
//  RobustaTask
//
//  Created by Nourhan Boghdady on 07/04/2023.
//

import Foundation
import Combine

class HomeViewModel: HomeViewModelProtocol {
    @Published var allRepos: ReposModelResponse = []
    @Published var filteredRepos: ReposModelResponse = []

    var subscriptions = Set<AnyCancellable>()
    
    func getAllRepos() {
        let service = GetReposService()
        service.getRepos()
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
                    self?.allRepos = response.self
                }
                .store(in: &subscriptions)

    }
    
    func searchRepos(by text: String) {
        let service = GetReposService()
        service.searchRepos(by: text)
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
                    self?.filteredRepos = response.repos ?? []
                }
                .store(in: &subscriptions)

    }

    
     

}
