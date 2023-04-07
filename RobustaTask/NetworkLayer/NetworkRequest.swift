//
//  NetworkRequest.swift
//  RobustaTask
//
//  Created by Nourhan Boghdady on 07/04/2023.
//

import Combine
import Foundation

protocol Requestable {
    var requestTimeOut: Float { get }
    
    func request<T: Codable>(_ req: NetworkRequest) -> AnyPublisher<T, NetworkError>
}

class NativeRequestable: Requestable {
    
    var requestTimeOut: Float = 30

    func request<T>(_ req: NetworkRequest) -> AnyPublisher<T, NetworkError>
    where T: Codable {
        let sessionConfig = URLSessionConfiguration.default
         sessionConfig.timeoutIntervalForRequest = TimeInterval(req.requestTimeOut ?? requestTimeOut)
        
         guard let url = URL(string: req.url ) else {
            // Return a fail publisher if the url is invalid
            return AnyPublisher(
                Fail<T, NetworkError>(error: NetworkError.badURL("Invalid Url"))
            )
        }
        // We use the dataTaskPublisher from the URLSession which gives us a publisher to play around with.
        return URLSession.shared
             .dataTaskPublisher(for: req.buildURLRequest(with: url) )
             .tryMap { output in
                     // throw an error if response is nil
                guard output.response is HTTPURLResponse else {
                    throw NetworkError.serverError(code: 0, error: "Server error")
                }
                return output.data
            }
             .decode(type: T.self, decoder: JSONDecoder())
            .mapError { error in
                       // return error if json decoding fails
                NetworkError.invalidJSON(String(describing: error))
            }
            .eraseToAnyPublisher()
    }
}

struct NetworkRequest {
    let url: String
    let headers: [String: String]
    let body: Data?
    let requestTimeOut: Float?
    let httpMethod: HTTPMethod
    
    init(url: String,
                headers: [String: String],
                reqBody: Encodable? = nil,
                reqTimeout: Float? = nil,
                httpMethod: HTTPMethod
    ) {
        self.url = url
        self.headers = headers
        self.body = reqBody?.encode()
        self.requestTimeOut = reqTimeout
        self.httpMethod = httpMethod
    }
    
    init(url: String,
                headers: [String: String],
                reqBody: Data? = nil,
                reqTimeout: Float? = nil,
                httpMethod: HTTPMethod
    ) {
        self.url = url
        self.headers = headers
        self.body = reqBody
        self.requestTimeOut = reqTimeout
        self.httpMethod = httpMethod
    }
    
    func buildURLRequest(with url: URL) -> URLRequest {
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = httpMethod.rawValue
        urlRequest.allHTTPHeaderFields = headers
        urlRequest.httpBody = body
        return urlRequest
    }
}

enum HTTPMethod: String {
    case GET
    case POST
    case PUT
    case DELETE
}

enum NetworkError: Error, Equatable {
    case badURL(_ error: String)
    case apiError(code: Int, error: String)
    case invalidJSON(_ error: String)
    case unauthorized(code: Int, error: String)
    case badRequest(code: Int, error: String)
    case serverError(code: Int, error: String)
    case noResponse(_ error: String)
    case unableToParseData(_ error: String)
    case unknown(code: Int, error: String)
}

extension Encodable {
    func encode() -> Data? {
        do {
            return try JSONEncoder().encode(self)
        } catch {
            return nil
        }
    }
}
