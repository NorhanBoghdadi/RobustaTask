//
//  HomeViewModelProtocol.swift
//  RobustaTask
//
//  Created by Nourhan Boghdady on 07/04/2023.
//

import Foundation

protocol HomeViewModelProtocol: AnyObject {
    func getAllRepos()
    var numberOfRepos: Int {get}
    var allRepos: ReposModelResponse {get}
    var searchActive: Bool {get set}
    var filteredRepos: ReposModelResponse {get}
}

