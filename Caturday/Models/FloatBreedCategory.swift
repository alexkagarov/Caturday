//
//  FloatBreedCategory.swift
//  Caturday
//
//  Created by Oleksii Kaharov on 5/12/20.
//  Copyright © 2020 hialex. All rights reserved.
//

import Foundation

protocol FloatBreedCategoryProtocol {
    var name: String { get }
    var value: Float { get }
}

class FloatBreedCategory: FloatBreedCategoryProtocol {
    var name: String
    var value: Float
    
    init(name: String, value: Float) {
        self.name = name
        self.value = value
    }
}
