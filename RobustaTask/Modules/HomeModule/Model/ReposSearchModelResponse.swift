//
//  ReposSearchModelResponse.swift
//  RobustaTask
//
//  Created by Nourhan Boghdady on 07/04/2023.
//

import Foundation

struct ReposSearchModelResponse: Codable {
    let totalCount: Int?
    let isIncomplete: Bool?
    let repos: ReposModelResponse?
    
    enum CodingKeys: String, CodingKey {
        case totalCount = "total_count"
        case isIncomplete = "incomplete_results"
        case repos = "items"
    }
}
