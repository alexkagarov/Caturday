//
//  CatalogItemVM.swift
//  Caturday
//
//  Created by Oleksii Kaharov on 5/9/20.
//  Copyright © 2020 hialex. All rights reserved.
//

import Foundation
import UIKit

protocol CatalogItemVMProtocol {
    var model: SingleBreedModel { get }
}

class CatalogItemVM: CatalogItemVMProtocol {
    var model: SingleBreedModel
    
    init(model: SingleBreedModel) {
        self.model = model
    }
}

extension CatalogItemVM {
    func setImage(url: String, element: UIImageView) {
        DispatchQueue.main.async {
            APIManager.shared.getImage(urlString: url, success: { (image) in
                element.image = image
            })
        }
        
    }
}
