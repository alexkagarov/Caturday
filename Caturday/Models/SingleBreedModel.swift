//
//  SingleBreedModel.swift
//  Caturday
//
//  Created by Mac on 5/12/20.
//  Copyright © 2020 hialex. All rights reserved.
//

import Foundation
import UIKit

protocol SingleBreedModelProtocol {
    var name: String { get }
    var description: String { get }
    var image: BreedImageModel { get }
    var boolCats: [BoolBreedCategoryProtocol] { get }
    var progCats: [FloatBreedCategoryProtocol] { get }
}

class SingleBreedModel: SingleBreedModelProtocol {
    var name: String
    var description: String
    var image: BreedImageModel
    var boolCats: [BoolBreedCategoryProtocol]
    var progCats: [FloatBreedCategoryProtocol]
    
    init(name: String, description: String, image: BreedImageModel, boolCats: [BoolBreedCategoryProtocol], progCats: [FloatBreedCategoryProtocol]) {
        self.name = name
        self.description = description
        self.image = image
        self.boolCats = boolCats
        self.progCats = progCats
    }
}
