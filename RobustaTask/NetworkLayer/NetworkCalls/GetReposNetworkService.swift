//
//  GetReposNetworkService.swift
//  RobustaTask
//
//  Created by Nourhan Boghdady on 07/04/2023.
//

import Foundation
import Combine

protocol GetReposProtocol {
    func getRepos() -> AnyPublisher<ReposModelResponse, NetworkError>
    func searchRepos(by text: String) -> AnyPublisher<ReposSearchModelResponse, NetworkError>
}

class GetReposService: GetReposProtocol {
    var networkRequest: Requestable = NativeRequestable()  // inject this for testability

    func getRepos() -> AnyPublisher<ReposModelResponse, NetworkError> {
        let endpoint = Endpoints.getRepos
        let request = endpoint.createRequest(token: "")
        return self.networkRequest.request(request)
        
    }
    
    func searchRepos(by text: String) -> AnyPublisher<ReposSearchModelResponse, NetworkError> {
        let endpoint = Endpoints.searchRepo(by: text)
        let request = endpoint.createRequest(token: "")
        return self.networkRequest.request(request)

    }
}
