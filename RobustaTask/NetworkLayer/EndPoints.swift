//
//  EndPoints.swift
//  RobustaTask
//
//  Created by Nourhan Boghdady on 07/04/2023.
//

import Foundation
import Combine

typealias Headers = [String: String]

// if you wish you can have multiple services like this in a project
enum Endpoints {
    
  // organise all the end points here for clarity
    case getRepos
    case searchRepo(by: String)
    
  // gave a default timeout but can be different for each.
    var requestTimeOut: Int {
        return 20
    }
    
  //specify the type of HTTP request
    var httpMethod: HTTPMethod {
        switch self {
        case .getRepos:
            return .GET
        case .searchRepo:
            return .GET
        }
    }
    
  // compose the NetworkRequest
    func createRequest(token: String) -> NetworkRequest {
        var headers: Headers = [:]
//        headers["Content-Type"] = "application/json"
//        headers["Authorization"] = "Bearer \(token)"
        return NetworkRequest(url: getURL(), headers: headers, reqBody: requestBody, httpMethod: httpMethod)
    }
    
  // encodable request body for POST
    var requestBody: Encodable? {
        switch self {
        default:
            return nil
        }
    }
    
  // compose urls for each request
    func getURL() -> String {
        let baseUrl = "https://api.github.com"
        switch self {
        case .getRepos:
            return "\(baseUrl)/repositories"
        case .searchRepo(let text):
            return "\(baseUrl)/search/repositories?q=\(text)+in:name"
        }
    }
}
