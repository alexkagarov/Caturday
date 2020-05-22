//
//  CatalogVM.swift
//  Caturday
//
//  Created by Oleksii Kaharov on 5/9/20.
//  Copyright © 2020 hialex. All rights reserved.
//

import Foundation
import UIKit

protocol CatalogVMProtocol {
    var breeds: [BreedModel] { get set }
}

class CatalogVM: CatalogVMProtocol {
    var breeds: [BreedModel] = []
    
    var selectedCellVM: CatalogItemVM?
    
    var breedsPage = 0
    var breedsCount = 0
    var paginationLimit = 20
}

extension CatalogVM {
    func getAllBreeds(success: (()->Void)?) {
        breedsPage = 0
        breedsCount = 0
        APIManager.shared.getItems(type: URLs.Breeds, limit: paginationLimit, success: { (data, paginationCount) in
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
        
        APIManager.shared.getMoreItems(type: URLs.Breeds, page: breedsPage, limit: paginationLimit,success: { (data, paginationCount) in
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
}

// MARK: - Get image URL for selected cat breed
extension CatalogVM {
    func getImageURL(breedID: String, success: ((ImageModel)->Void)?) {
        APIManager.shared.getImageURL(breedID: breedID, success: { (data) in
            let decoder = JSONDecoder()
            
            do {
                let decodedImgURL = try decoder.decode([ImageModel].self, from: data)
                
                guard let firstDecodedImage = decodedImgURL.first else { return }
                
                success?(firstDecodedImage)
            } catch let error {
                print(error)
            }
        })
    }
    
    func getImageForBreed(breedID: String, success: ((UIImage)->Void)?) {
        APIManager.shared.getSingleBreedImage(breedID: breedID, success: { (image) in
            success?(image)
        })
    }
}

// MARK: - Prepare ViewModel for selected catalog item
extension CatalogVM {
    func prepareVM(breedModel: BreedModel, success: (()->Void)?) {
        guard let name = breedModel.name else { return }
        
        guard var desc = breedModel.description else { return }
        
        if let altNames = breedModel.altNames, altNames.count > 1 {
            desc += "\n\nAlternative names: \(altNames)"
        }
        
        if let origin = breedModel.origin {
            desc += "\n\nCountry of origin: \(origin)"
            
            if let iso2 = breedModel.countryCode {
                desc += ISO2ToEmoji(iso2)
            }
        }
        
        if let lifeSpan = breedModel.lifeSpan {
            desc += "\n\nLife span: \(lifeSpan) years"
        }
        
        var boolCats = [BoolBreedCategoryProtocol]()
        
        if let cat = breedModel.experimental {
            let boolCat = BoolBreedCategory(name: "Experimental", state: cat == 0 ? false : true)
            boolCats.append(boolCat)
        }
        
        if let cat = breedModel.hairless {
            let boolCat = BoolBreedCategory(name: "Hairless", state: cat == 0 ? false : true)
            boolCats.append(boolCat)
        }
        
        if let cat = breedModel.natural {
            let boolCat = BoolBreedCategory(name: "Natural", state: cat == 0 ? false : true)
            boolCats.append(boolCat)
        }
        
        if let cat = breedModel.rare {
            let boolCat = BoolBreedCategory(name: "Rare", state: cat == 0 ? false : true)
            boolCats.append(boolCat)
        }
        
        if let cat = breedModel.rex {
            let boolCat = BoolBreedCategory(name: "Rex", state: cat == 0 ? false : true)
            boolCats.append(boolCat)
        }
        
        if let cat = breedModel.suppressedTail {
            let boolCat = BoolBreedCategory(name: "Suppressed tail", state: cat == 0 ? false : true)
            boolCats.append(boolCat)
        }
        
        if let cat = breedModel.shortLegs {
            let boolCat = BoolBreedCategory(name: "Short legs", state: cat == 0 ? false : true)
            boolCats.append(boolCat)
        }
        
        if let cat = breedModel.hypoallergenic {
            let boolCat = BoolBreedCategory(name: "Hypoallergenic", state: cat == 0 ? false : true)
            boolCats.append(boolCat)
        }
        
        var progCats = [FloatBreedCategoryProtocol]()
        
        if let cat = breedModel.adaptability {
            let progCat = FloatBreedCategory(name: "Adaptability", value: Float(cat)/5.0)
            progCats.append(progCat)
        }
        
        if let cat = breedModel.affectionLevel {
            let progCat = FloatBreedCategory(name: "Affection level", value: Float(cat)/5.0)
            progCats.append(progCat)
        }
        
        if let cat = breedModel.childFriendly {
            let progCat = FloatBreedCategory(name: "Child friendly", value: Float(cat)/5.0)
            progCats.append(progCat)
        }
        
        if let cat = breedModel.dogFriendly {
            let progCat = FloatBreedCategory(name: "Dog friendly", value: Float(cat)/5.0)
            progCats.append(progCat)
        }
        
        if let cat = breedModel.energyLevel {
            let progCat = FloatBreedCategory(name: "Energy level", value: Float(cat)/5.0)
            progCats.append(progCat)
        }
        
        if let cat = breedModel.grooming {
            let progCat = FloatBreedCategory(name: "Grooming", value: Float(cat)/5.0)
            progCats.append(progCat)
        }
        
        if let cat = breedModel.healthIssues {
            let progCat = FloatBreedCategory(name: "Health issues", value: Float(cat)/5.0)
            progCats.append(progCat)
        }
        
        if let cat = breedModel.intelligence {
            let progCat = FloatBreedCategory(name: "Intelligence", value: Float(cat)/5.0)
            progCats.append(progCat)
        }
        
        if let cat = breedModel.sheddingLevel {
            let progCat = FloatBreedCategory(name: "Shedding level", value: Float(cat)/5.0)
            progCats.append(progCat)
        }
        
        if let cat = breedModel.socialNeeds {
            let progCat = FloatBreedCategory(name: "Social needs", value: Float(cat)/5.0)
            progCats.append(progCat)
        }
        
        if let cat = breedModel.strangerFriendly {
            let progCat = FloatBreedCategory(name: "Stranger friendly", value: Float(cat)/5.0)
            progCats.append(progCat)
        }
        
        if let cat = breedModel.vocalisation {
            let progCat = FloatBreedCategory(name: "Vocalisation", value: Float(cat)/5.0)
            progCats.append(progCat)
        }
        
        var breedImageModel = ImageModel()
        
        if let id = breedModel.id {
            getImageForBreed(breedID: id, success: { (image) in
                let singleModel = SingleBreedModel(name: name, description: desc, imageURLObject: breedImageModel, boolCats: boolCats, progCats: progCats)

                singleModel.image = image
                self.selectedCellVM = CatalogItemVM(model: singleModel)
                success?()
            })
//            getImageURL(breedID: id, success: { (data) in
//                breedImageModel = data
//
//                let singleModel = SingleBreedModel(name: name, description: desc, imageURLObject: breedImageModel, boolCats: boolCats, progCats: progCats)
//
//                self.selectedCellVM = CatalogItemVM(model: singleModel)
//                success?()
//            })
        }
    }
}

extension CatalogVM {
    func ISO2ToEmoji(_ iso2: String) -> String {
        let base: UInt32 = 127397
        
        var s = ""
        
        if iso2 == "SP" {
            let singaporeCorrected = "SG" // still curious about this random Singapore misspelling
            for v in singaporeCorrected.unicodeScalars {
                s.unicodeScalars.append(UnicodeScalar(base + v.value)!)
            }
        } else {
            for v in iso2.uppercased().unicodeScalars {
                s.unicodeScalars.append(UnicodeScalar(base + v.value)!)
            }
        }
        return s
    }
}
