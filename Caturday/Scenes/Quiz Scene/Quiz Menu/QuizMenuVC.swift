//
//  QuizMenuVC.swift
//  Caturday
//
//  Created by Oleksii Kaharov on 5/9/20.
//  Copyright © 2020 hialex. All rights reserved.
//

import UIKit

// MARK: - Main Quiz VC protocol delegate - to check the stats state after dismissing of other quiz related VCs
protocol QuizMenuVCDelegate: class {
    func checkUserStats()
}

class QuizMenuVC: UIViewController {

    // MARK: - IBOutlets
    @IBOutlet weak var guideLbl: UILabel!
    @IBOutlet weak var startQuizBtn: UIButton!
    @IBOutlet weak var checkMyStatsBtn: UIButton!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    // MARK: - Variables
    var viewModel: QuizMenuVM = QuizMenuVM()
    
    // MARK: - VC Life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        setupView()
    }
    
    override func viewDidLayoutSubviews() {
        startQuizBtn.layer.cornerRadius = startQuizBtn.frame.size.height/2
    }
    
    // MARK: - Internal functions
    private func setupView() {
        guideLbl.text = viewModel.guide
        
        startQuizBtn.layer.borderColor = UIColor.lightGray.cgColor
        startQuizBtn.layer.borderWidth = 2
        
        startQuizBtn.alpha = 0.5
        startQuizBtn.isEnabled = false
        
        viewModel.getAllBreeds(success: {
            DispatchQueue.main.async {
                self.startQuizBtn.alpha = 1
                self.startQuizBtn.isEnabled = true
            }
        })
        
        checkStats()
    }
    
    private func checkStats() {
        viewModel.setStatsFromUserDefaults()
        checkMyStatsBtn.isHidden = viewModel.statsAreNotEmpty ? false : true
    }
    
    // MARK: - Prepare for segue
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == Segues.StartSingleQuiz {
            guard let destVC = segue.destination as? SingleQuizVC else { return }
            
            let vm = SingleQuizVM(quizModel: self.viewModel.quiz)
            destVC.viewModel = vm
            destVC.delegate = self
        }
        
        if segue.identifier == Segues.ShowStatsPopUp {
            guard let destVC = segue.destination as? QuizStatsPopupVC else { return }
            
            let vm = QuizStatsPopupVM()
            vm.actualAllGames = viewModel.gamesPlayed
            vm.actualWonGames = viewModel.gamesWon
            vm.actualProgress = viewModel.successRate
            
            destVC.viewModel = vm
            destVC.delegate = self
        }
    }
    
    // MARK: - IBActions
    @IBAction func onStartQuizTapped(_ sender: UIButton?) {
        startQuizBtn.isHidden = true
        activityIndicator.isHidden = false
        
        viewModel.setQuiz(success: {
            DispatchQueue.main.async {
                self.startQuizBtn.isHidden = false
                self.activityIndicator.isHidden = true
                self.performSegue(withIdentifier: Segues.StartSingleQuiz, sender: self)
            }
        })
    }
    
    @IBAction func onCheckStatsTapped(_ sender: UIButton?) {
        viewModel.setStatsFromUserDefaults()
        
        performSegue(withIdentifier: Segues.ShowStatsPopUp, sender: self)
    }
}

// MARK: - Main Quiz VC protocol delegate - to check the stats state after dismissing of other quiz related VCs
extension QuizMenuVC: QuizMenuVCDelegate {
    func checkUserStats() {
        self.checkStats()
    }
}
