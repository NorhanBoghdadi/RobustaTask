//
//  GetRepoDetailsNetworkService.swift
//  RobustaTask
//
//  Created by Nourhan Boghdady on 08/04/2023.
//

import Foundation
import Combine 

protocol GetRepoDetailsProtocol {
    func getRepoDetails(url: String) -> AnyPublisher<RepoDetailsResponse, NetworkError>
}

class GetRepoDetailsService: GetRepoDetailsProtocol {
    private var networkRequest = NativeRequestable()  // inject this for testability
    
    func getRepoDetails(url: String) -> AnyPublisher<RepoDetailsResponse, NetworkError> {
        let endpoint = Endpoints.getRepoDetails(url: url)
        let request = endpoint.createRequest(token: "")
        return self.networkRequest.request(request)
        
    }
}
