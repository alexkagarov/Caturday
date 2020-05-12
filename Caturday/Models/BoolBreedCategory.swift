//
//  BoolBreedCategory.swift
//  Caturday
//
//  Created by Mac on 5/12/20.
//  Copyright © 2020 hialex. All rights reserved.
//

import Foundation

protocol BoolBreedCategoryProtocol {
    var name: String { get }
    var state: Bool { get }
}

class BoolBreedCategory: BoolBreedCategoryProtocol {
    var name: String
    var state: Bool
    
    init(name: String, state: Bool) {
        self.name = name
        self.state = state
    }
}
