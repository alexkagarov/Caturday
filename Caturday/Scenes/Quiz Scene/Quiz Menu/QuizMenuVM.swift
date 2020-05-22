//
//  QuizMenuVM.swift
//  Caturday
//
//  Created by Oleksii Kaharov on 5/9/20.
//  Copyright © 2020 hialex. All rights reserved.
//

import Foundation
import UIKit

protocol QuizMenuVMProtocol {
    var successRate: Double { get set }
    var gamesPlayed: Int { get set }
    var gamesWon: Int { get set }
    var breeds: [BreedModel] { get }
    var quiz: QuizModel { get set }
}

class QuizMenuVM: QuizMenuVMProtocol {
    var statsAreNotEmpty = false
    var successRate: Double = 0.0
    var gamesPlayed: Int = 0
    var gamesWon: Int = 0
    
    let guide: String = "Tap \"Start Quiz\" button (when it is active) to try guessing the cat breed, based on its photo.\n\nYou can choose from 4 (four) different options, only ONE of which is correct. Choose wisely!\n\nIf the image is bad or you are unsure about your answer, you can tap \"Request another image\" button below the cat's photo. The answer will remain the same.\n\nAfter your first game your stats will be available by tapping \"Check my stats\" button on the bottom of this screen. The pop up with stats will appear immediately.\n\nIf you are unhappy with your stats, you can tap \"Clear user statistics\" button in stats pop up. Be careful, this action can't be undone!"
    
    var breeds: [BreedModel] = []
    var quiz: QuizModel = QuizModel()
    
    init() {
        setStatsFromUserDefaults()
    }
    
    func setStatsFromUserDefaults() {
        let defaults = UserDefaults.standard
        
        gamesPlayed = defaults.integer(forKey: UDKeys.AllGames)
        gamesWon = defaults.integer(forKey: UDKeys.WonGames)
        
        successRate = Double(gamesWon)/Double(gamesPlayed)
        
        statsAreNotEmpty = (gamesPlayed > 0)
    }
}

extension QuizMenuVM {
    func setQuiz(success: (()->Void)?) {
        print("Setting quiz up . . . ")
        let shuffledBreeds = breeds.shuffled()
        let quizElements = shuffledBreeds.suffix(4)
        
        quiz.options = quizElements.map({ $0.name! })
        print("Quiz options are: \(quiz.options)")
        
        if let randomElement = quizElements.randomElement() {
            guard let name = randomElement.name  else { return }
            guard let answerBreedID = randomElement.id  else { return }
            
            quiz.answer = name
            quiz.answerID = answerBreedID
            print("Answer is: \(quiz.answer)")
            
            getImageForBreed(breedID: answerBreedID, success: { (image) in
                self.quiz.image = image
                print("Quiz is set!")
                success?()
            })
        }
    }
}

extension QuizMenuVM {
    func getAllBreeds(success: (()->Void)?) {
        APIManager.shared.getItems(type: URLs.Breeds, limit: 80, success: { (data, _) in
            let decoder = JSONDecoder()
            decoder.keyDecodingStrategy = .convertFromSnakeCase
            
            do {
                let decodedBreeds = try decoder.decode([BreedModel].self, from: data)
                self.breeds = decodedBreeds
                success?()
            } catch let error {
                print(error)
            }
        }, failure: { (error) in
            print(error)
        })
    }
    
    func getImageForBreed(breedID: String, success: ((UIImage)->Void)?) {
        APIManager.shared.getSingleBreedImage(breedID: breedID, success: { (image) in
            success?(image)
        })
    }
}
