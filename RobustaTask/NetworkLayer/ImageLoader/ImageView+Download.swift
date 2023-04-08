//
//  ImageView+Download.swift
//  RobustaTask
//
//  Created by Nourhan Boghdady on 08/04/2023.
//

import UIKit

extension UIImageView {
    func setImage(url: String, placeHolder: UIImage) throws {
        self.image = placeHolder
        let downloader = ImageLoader.shared
        guard let url = URL(string: url) else {
            throw ImageLoaderError.urlNotCorrect
        }
        downloader.loadImageData(url: url) { results in
            switch results {
            case .success(let imageData):
                guard let image = self.resize(imageData) else { return }
                self.image = UIImage(cgImage: image)
            case .failure:
                self.image = placeHolder
            }
        }
    }
    
    
    fileprivate func resize(_ imageData: Data) -> CGImage? {
        let image: CGImage?
        if self.bounds.size.equalTo(.zero) {
            let screenBounds = UIScreen.main.bounds
            image = ImageDataUtility.resize(data: imageData, for: CGSize(width: screenBounds.width, height: screenBounds.height))
        } else {
            image = ImageDataUtility.resize(data: imageData, for: CGSize(width: self.bounds.width, height: self.bounds.height))
        }
        return image
    }
}
