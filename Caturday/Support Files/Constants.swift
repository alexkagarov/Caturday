//
//  Constants.swift
//  Caturday
//
//  Created by Oleksii Kaharov on 5/10/20.
//  Copyright © 2020 hialex. All rights reserved.
//

import Foundation

struct URLs {
    static let Server = "https://api.thecatapi.com/v1"
    
    static let Breeds = "/breeds"
    static let Images = "/images/search"
}

struct Segues {
    static let ToSingleBreed = "ToSingleBreedSegue"
}

struct UDKeys {
    static let AllGames = "UserDefaults.AllGamesCounter"
    static let WonGames = "UserDefaults.WonGamesCounter"
}
