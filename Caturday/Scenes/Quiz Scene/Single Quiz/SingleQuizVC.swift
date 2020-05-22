//
//  SingleQuizVC.swift
//  Caturday
//
//  Created by Oleksii Kaharov on 21.05.2020.
//  Copyright © 2020 hialex. All rights reserved.
//

import UIKit

class SingleQuizVC: UIViewController {

    // MARK: - IBOutlets
    @IBOutlet weak var option1View: QuizOptionView!
    @IBOutlet weak var option2View: QuizOptionView!
    @IBOutlet weak var option3View: QuizOptionView!
    @IBOutlet weak var option4View: QuizOptionView!
    
    @IBOutlet weak var breedImage: UIImageView!
    
    // MARK: - Variables
    var quizOptions: [QuizOptionView] = []
    var viewModel: SingleQuizVM = SingleQuizVM(quizModel: QuizModel())
    weak var delegate: QuizMenuVCDelegate?
    
    var timer: Timer!
    
    // MARK: - VC Life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupView()
    }
    
    override func viewDidLayoutSubviews() {
        for index in 0..<quizOptions.count {
            quizOptions[index].layer.cornerRadius = quizOptions[index].bounds.height/2
        }
    }
    
    // MARK: - Internal functions
    private func setupView() {
        breedImage.image = viewModel.quizModel.image
        
        quizOptions.append(option1View)
        quizOptions.append(option2View)
        quizOptions.append(option3View)
        quizOptions.append(option4View)
        
        for index in 0..<quizOptions.count {
            quizOptions[index].layer.cornerRadius = quizOptions[index].bounds.height/2
            quizOptions[index].layer.borderColor = UIColor.lightGray.cgColor
            quizOptions[index].layer.borderWidth = 2
            
            quizOptions[index].buttonLabel.text = viewModel.quizModel.options[index]
            
            quizOptions[index].buttonAction = onAnswerTapped
        }
    }
    
    @objc private func customDismiss() {
        delegate?.checkUserStats()
        dismiss(animated: true, completion: nil)
    }
    
    // MARK: - IBActions
    @IBAction func onLoadAnotherImageTapped(_ sender: UIButton?) {
        viewModel.getImageForBreed(breedID: viewModel.quizModel.answerID, success: { (image) in
            DispatchQueue.main.async {
                self.breedImage.image = image
            }
        })
    }
    
    @IBAction func onCloseTapped(_ sender: UIButton?) {
        customDismiss()
    }
}

extension SingleQuizVC {
    private func onAnswerTapped(_ sender: QuizOptionView) {
        var answerIsCorrect = true
        
        if sender.buttonLabel.text != viewModel.quizModel.answer {
            sender.bgView.backgroundColor = .systemRed
            answerIsCorrect = false
        }
        
        for option in quizOptions {
            option.actionButton.isEnabled = false
            
            if option.buttonLabel.text == viewModel.quizModel.answer {
                option.bgView.backgroundColor = .systemGreen
            }
        }
        
        let defaults = UserDefaults.standard
        
        if answerIsCorrect {
            defaults.set(defaults.integer(forKey: UDKeys.WonGames)+1, forKey: UDKeys.WonGames)
        }
        
        defaults.set(defaults.integer(forKey: UDKeys.AllGames)+1, forKey: UDKeys.AllGames)
        
        timer = Timer.scheduledTimer(timeInterval: 3, target: self, selector: #selector(customDismiss), userInfo: nil, repeats: false)
    }
}
