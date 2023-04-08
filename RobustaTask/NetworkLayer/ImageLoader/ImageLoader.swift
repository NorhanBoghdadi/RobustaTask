//
//  ImageLoader.swift
//  RobustaTask
//
//  Created by Nourhan Boghdady on 08/04/2023.
//

import UIKit

typealias ImageDataResponse = ((Result<Data, Error>) -> ())

class ImageLoader {
    var urlSession: URLSession
    var cache = [String: Data]()
    
    static let shared = ImageLoader()
    
    init(urlSession: URLSession = .shared) {
        self.urlSession = urlSession
    }

    fileprivate func loadFromNetwork(_ url: URL, _ completion: ImageDataResponse?) {
        loadWith(urlSession, url: url) {[weak self] data, urlResponse, error in
            guard let self = self else { return }
            completion?(self.handleDataTaskResponse(data: data,
                                                    urlResponse: urlResponse,
                                                    error: error))
        }
    }
    
    fileprivate func loadFromCache(_ url: URL) -> Data? {
        cache[url.absoluteString]
    }
    
    fileprivate func storeToCache(_ url: String, _ data: Data) {
        cache[url] = data
    }
    
    func loadFromCache(_ url: URL, completion: ImageDataResponse?) -> Data? {
       
        guard let data = loadFromCache(url) else {
            return nil
        }
        completion?(.success(data))
        return data
    }
    
    func loadImageData(url: URL, completion: ImageDataResponse?) {
        // if image exists in the cache, return it, else make the call.
        if loadFromCache(url, completion: completion) != nil{
            return
        } else {
            loadFromNetwork(url, completion)
        }
    }
    
    private func loadWith(_ session: URLSession, url: URL, completion: ((_ data: Data?, _ urlResponse: URLResponse?, _ error: Error?)->())?) {
        let dataTask = session.dataTask(with: url) {data, urlResponse, error in
            DispatchQueue.main.async {
                completion?(data, urlResponse, error)
            }
        }
        dataTask.resume()
    }
    
    private func handleDataTaskResponse(data: Data?, urlResponse: URLResponse?, error: Error?) -> Result<Data, Error> {
        if let data = data, let url = urlResponse?.url?.absoluteString {
            storeToCache(url, data)
            return .success(data)
        } else if let error = error {
            return .failure(error)
        }
        return .failure(ImageLoaderError.unknown)
    }
}


enum ImageLoaderError: Error {
    case unknown
    case imageNotDecoded
    case urlNotCorrect
    case imageNotResized
}
