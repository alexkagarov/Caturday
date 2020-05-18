//
//  PhotoGalleryVM.swift
//  Caturday
//
//  Created by Oleksii Kaharov on 5/9/20.
//  Copyright © 2020 hialex. All rights reserved.
//

import Foundation
import UIKit

protocol PhotoGalleryVMProtocol {
    var images: [CatCollectionImageModel] { get set }
}

class PhotoGalleryVM: PhotoGalleryVMProtocol {
    var images: [CatCollectionImageModel] = []
    
    var imagesPage = 0
    var imagesCount = 0
    var paginationLimit = 20
}

extension PhotoGalleryVM {
    func getImages(success: (()->Void)?) {
        imagesPage = 0
        imagesCount = 0
        APIManager.shared.getItems(type: URLs.Images, limit: paginationLimit, success: { (data, paginationCount) in
            self.imagesCount = paginationCount
            
            let decoder = JSONDecoder()
            
            do {
                let decodedImages = try decoder.decode([ImageModel].self, from: data)
                
                var finImages = [CatCollectionImageModel]()
                for decImage in decodedImages {
                    finImages.append(CatCollectionImageModel(imageURLObject: decImage))
                }
                
                self.images = finImages
                success?()
            } catch let error {
                print(error)
            }
        }, failure: { (error) in
            print(error)
        })
    }
    
    func getMoreImages(success: (()->Void)?) {
        imagesPage += 1
        
        APIManager.shared.getMoreItems(type: URLs.Images, page: imagesPage, limit: paginationLimit,success: { (data, paginationCount) in
            self.imagesCount = paginationCount
            
            let decoder = JSONDecoder()
            decoder.keyDecodingStrategy = .convertFromSnakeCase
            
            do {
                let decodedImages = try decoder.decode([ImageModel].self, from: data)
                
                var finImages = [CatCollectionImageModel]()
                for decImage in decodedImages {
                    finImages.append(CatCollectionImageModel(imageURLObject: decImage))
                }
                
                self.images += finImages
                
                success?()
            } catch let error {
                print(error)
            }
        }, failure: { (error) in
            print(error)
        })
    }
    
    func getImage(url: String, success: ((UIImage)->Void)?) {
        APIManager.shared.getImage(urlString: url, success: { (image) in
            success?(image)
        })
    }
}
