//
//  NetworkRequestTests.swift
//  RobustaTaskTests
//
//  Created by Nourhan Boghdady on 08/04/2023.
//

import XCTest
import Combine
@testable import RobustaTask

class NativeRequestableTests: XCTestCase {

    var sut: NativeRequestable!

    override func setUp() {
        super.setUp()
        sut = NativeRequestable()
    }

    override func tearDown() {
        sut = nil
        super.tearDown()
    }

    func testRequest_WithValidRequest_ReturnsData() {
        
        let request = NetworkRequest(url: "https://example.com/api", headers: [:], httpMethod: .GET)
        let publisher: AnyPublisher<Data, NetworkError> = sut.request(request)

        // then
        let exp = expectation(description: "Wait for response")
        var receivedData: Data?
        var receivedError: NetworkError?
        let cancellable = publisher.sink(receiveCompletion: { completion in
            switch completion {
            case .failure(let error):
                receivedError = error
            case .finished:
                break
            }
            exp.fulfill()
        }, receiveValue: { data in
            receivedData = data
        })
        wait(for: [exp], timeout: 5)
        XCTAssertNotNil(receivedData)
        XCTAssertNil(receivedError)
        cancellable.cancel()
    }

    func testRequest_WithInvalidURL_ReturnsError() {
        // given
        let req = NetworkRequest(url: "invalid-url", headers: [:], httpMethod: .GET)

        // when
        let publisher: AnyPublisher<Data, NetworkError> = sut.request(req)

        // then
        let exp = expectation(description: "Wait for response")
        var receivedData: Data?
        var receivedError: NetworkError?
        let cancellable = publisher.sink(receiveCompletion: { completion in
            switch completion {
            case .failure(let error):
                receivedError = error
            case .finished:
                break
            }
            exp.fulfill()
        }, receiveValue: { data in
            receivedData = data
        })
        wait(for: [exp], timeout: 5)
        XCTAssertNil(receivedData)
        XCTAssertNotNil(receivedError)
        cancellable.cancel()
    }

}


