//
//  HomeViewModelProtocol.swift
//  RobustaTask
//
//  Created by Nourhan Boghdady on 07/04/2023.
//

import Foundation

protocol HomeViewModelProtocol: AnyObject {
    func getAllRepos()
    func searchRepos(by text: String)
    var allRepos: ReposModelResponse {get}
    var filteredRepos: ReposModelResponse {get}
}

