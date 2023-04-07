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
}

class GetReposService: GetReposProtocol {
    private var networkRequest = NativeRequestable()  // inject this for testability

    func getRepos() -> AnyPublisher<ReposModelResponse, NetworkError> {
        let endpoint = Endpoints.getRepos
        let request = endpoint.createRequest(token: "")
        return self.networkRequest.request(request)
        
    }
  
}
