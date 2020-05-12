//
//  CatalogVM.swift
//  Caturday
//
//  Created by Oleksii Kaharov on 5/9/20.
//  Copyright © 2020 hialex. All rights reserved.
//

import Foundation

protocol CatalogVMProtocol {
    var breeds: [BreedModel] { get set }
}

class CatalogVM: CatalogVMProtocol {
    var breeds: [BreedModel] = []
    
    var breedsPage = 0
    var breedsCount = 0
    var paginationLimit = 20
}

extension CatalogVM {
    func getAllBreeds(success: (()->Void)?) {
        breedsPage = 0
        breedsCount = 0
        APIManager.shared.getBreeds(limit: paginationLimit, success: { (data, paginationCount) in
            self.breedsCount = paginationCount
            
            let decoder = JSONDecoder()
            decoder.keyDecodingStrategy = .convertFromSnakeCase
            
            do {
                let decodedBreeds = try decoder.decode([BreedModel].self, from: data)
                self.breeds = decodedBreeds
                success?()
            } catch let error {
                print(error)
            }
        }, failure: { (error) in
            print(error)
        })
    }
    
    func getMoreBreeds(success: (()->Void)?) {
        breedsPage += 1
        
        APIManager.shared.getMoreBreeds(page: breedsPage, limit: paginationLimit,success: { (data, paginationCount) in
            self.breedsCount = paginationCount
            
            let decoder = JSONDecoder()
            decoder.keyDecodingStrategy = .convertFromSnakeCase
            
            do {
                let decodedBreeds = try decoder.decode([BreedModel].self, from: data)
                self.breeds += decodedBreeds
                
                success?()
            } catch let error {
                print(error)
            }
        }, failure: { (error) in
            print(error)
        })
    }
    
    func getBreedImage(id: String, success: (()->Void)?) {
        
    }
}

extension CatalogVM {
    func getImageURL(breedID: String, success: ((BreedImageModel)->Void)?) {
        APIManager.shared.getImageURL(breedID: breedID, success: { (data) in
            let decoder = JSONDecoder()
            
            do {
                let decodedImgURL = try decoder.decode([BreedImageModel].self, from: data)
                success?(decodedImgURL.first!)
            } catch let error {
                print(error)
            }
        })
            
    }
}
