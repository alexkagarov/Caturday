//
//  SinglePhotoVM.swift
//  Caturday
//
//  Created by Oleksii Kaharov on 5/9/20.
//  Copyright © 2020 hialex. All rights reserved.
//

import Foundation
import UIKit

protocol SinglePhotoVMProtocol {
    var image: UIImage { get }
}

class SinglePhotoVM: SinglePhotoVMProtocol {
    var image: UIImage
    
    init(image: UIImage) {
        self.image = image
    }
}
