//
//  ImageLoaderTest.swift
//  RobustaTaskTests
//
//  Created by Nourhan Boghdady on 08/04/2023.
//

import XCTest
@testable import RobustaTask

final class ImageLoaderTest: XCTestCase {

    func testImageLoader() {
        let sut = ImageLoader.shared
        let imageUrl = "https://avatars.githubusercontent.com/u/1?v=4"
        let img = UIImage(named: "testImage")
        let imgData = img?.pngData()
        sut.loadImageData(url: URL(string: imageUrl)!) { results in
            switch results {
            case .failure(let error):
                XCTAssertThrowsError(error)
            case .success(let data):
                XCTAssertEqual(data, imgData)
            }
                
        }
    }


}
