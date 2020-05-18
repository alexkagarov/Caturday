//
//  CatCollectionImageModel.swift
//  Caturday
//
//  Created by Oleksii Kaharov on 17.05.2020.
//  Copyright © 2020 hialex. All rights reserved.
//

import Foundation
import UIKit

class CatCollectionImageModel {
    var image: UIImage?
    var imageURLObject: ImageModel
    
    init(imageURLObject: ImageModel) {
        self.imageURLObject = imageURLObject
    }
}
