//
//  BreedModel.swift
//  Caturday
//
//  Created by Oleksii Kaharov on 5/12/20.
//  Copyright © 2020 hialex. All rights reserved.
//

import Foundation

class BreedModel: Decodable {
    var id: String?
    var name: String?
    var origin: String?
    var altNames: String?
    var temperament: String?
    var lifeSpan: String?
    var description: String?
    var countryCode: String?
    
    var experimental: Int?
    var hairless: Int?
    var natural: Int?
    var rare: Int?
    var rex: Int?
    var suppressedTail: Int?
    var shortLegs: Int?
    var hypoallergenic: Int?
    
    var adaptability: Int?
    var affectionLevel: Int?
    var childFriendly: Int?
    var dogFriendly: Int?
    var energyLevel: Int?
    var grooming: Int?
    var healthIssues: Int?
    var intelligence: Int?
    var sheddingLevel: Int?
    var socialNeeds: Int?
    var strangerFriendly: Int?
    var vocalisation: Int?
}
