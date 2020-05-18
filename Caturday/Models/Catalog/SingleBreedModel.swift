//
//  SingleBreedModel.swift
//  Caturday
//
//  Created by Oleksii Kaharov on 5/12/20.
//  Copyright © 2020 hialex. All rights reserved.
//

import Foundation
import UIKit

protocol SingleBreedModelProtocol {
    var name: String { get }
    var image: UIImage { get set }
    var description: String { get }
    var imageURLObject: ImageModel { get }
    var boolCats: [BoolBreedCategoryProtocol] { get }
    var progCats: [FloatBreedCategoryProtocol] { get }
}

class SingleBreedModel: SingleBreedModelProtocol {
    var name: String
    var image = UIImage()
    var description: String
    var imageURLObject: ImageModel
    var boolCats: [BoolBreedCategoryProtocol]
    var progCats: [FloatBreedCategoryProtocol]
    
    init(name: String, description: String, imageURLObject: ImageModel, boolCats: [BoolBreedCategoryProtocol], progCats: [FloatBreedCategoryProtocol]) {
        self.name = name
        self.description = description
        self.imageURLObject = imageURLObject
        self.boolCats = boolCats
        self.progCats = progCats
    }
}
