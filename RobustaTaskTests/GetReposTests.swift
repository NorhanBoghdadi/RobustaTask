//
//  GetReposTests.swift
//  RobustaTaskTests
//
//  Created by Nourhan Boghdady on 08/04/2023.
//

import XCTest
import Combine
@testable import RobustaTask

class MockRequestable: Requestable {
    var requestTimeOut: Float = 20
    
    func request<T>(_ req: RobustaTask.NetworkRequest) -> AnyPublisher<T, RobustaTask.NetworkError> where T : Decodable, T : Encodable {
        result as! AnyPublisher<T, NetworkError>
    }
    
    var result: AnyPublisher<ReposModelResponse, NetworkError> = Fail(error: NetworkError.unknown(code: 1, error: "")).eraseToAnyPublisher()
    
}

class GetReposServiceTests: XCTestCase {
    var service: GetReposService!
    var mockRequestable: MockRequestable!
    var cancellables: Set<AnyCancellable>!
    
    override func setUp() {
        super.setUp()
        mockRequestable = MockRequestable()
        service = GetReposService()
        service.networkRequest = mockRequestable
        cancellables = []
    }
    
    override func tearDown() {
        super.tearDown()
        cancellables = nil
        service = nil
        mockRequestable = nil
    }
    
    func testGetRepos() {
        let expectedResponse: ReposModelResponse = []
        mockRequestable.result = Just(expectedResponse).setFailureType(to: NetworkError.self).eraseToAnyPublisher()
        
        let expectation = XCTestExpectation(description: "Get repos expectation")
        
        service.getRepos()
            .sink(receiveCompletion: { completion in
                switch completion {
                case .failure(_):
                    XCTFail("Expected repos but got error")
                case .finished:
                    expectation.fulfill()
                }
            }, receiveValue: { response in
                XCTAssertEqual(response.count, 0)
            })
            .store(in: &cancellables)
        
        wait(for: [expectation], timeout: 1.0)
    }
    
}
