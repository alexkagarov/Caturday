//
//  SingleQuizVM.swift
//  Caturday
//
//  Created by Oleksii Kaharov on 21.05.2020.
//  Copyright © 2020 hialex. All rights reserved.
//

import Foundation
import UIKit

protocol SingleQuizVMProtocol {
    var quizModel: QuizModel { get set }
}

class SingleQuizVM: SingleQuizVMProtocol {
    var quizModel: QuizModel
    
    init(quizModel: QuizModel) {
        self.quizModel = quizModel
    }
}

extension SingleQuizVM {
    func getImageForBreed(breedID: String, success: ((UIImage)->Void)?) {
        APIManager.shared.getSingleBreedImage(breedID: breedID, success: { (image) in
            success?(image)
        })
    }
}
