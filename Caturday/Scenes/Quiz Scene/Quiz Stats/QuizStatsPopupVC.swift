//
//  QuizStatsPopupVC.swift
//  Caturday
//
//  Created by Cryptoshell on 22.05.2020.
//  Copyright © 2020 hialex. All rights reserved.
//

import UIKit

class QuizStatsPopupVC: UIViewController {

    // MARK: - IBOutlets
    @IBOutlet weak var popupView: UIView!
    @IBOutlet weak var wonGamesCountLbl: UILabel!
    @IBOutlet weak var allGamesCountLbl: UILabel!
    @IBOutlet weak var progressBar: UIProgressView!
    @IBOutlet weak var clearStats: UIButton!
    
    // MARK: - Variables
    var viewModel: QuizStatsPopupVM = QuizStatsPopupVM()
    weak var delegate: QuizMenuVCDelegate?
    var timer: Timer!
    
    // MARK: - VC Life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        setupView()
        performAnimations()
    }
    
    // MARK: - Internal functions
    private func setupView() {
        popupView.layer.cornerRadius = 10
        
        progressBar.subviews.forEach({
            $0.clipsToBounds = true
            $0.layer.cornerRadius = 5
        })
        
        clearStats.isHidden = viewModel.actualAllGames < 1
        
        setupGestureRecognizer()
    }
    
    private func closeStatsPopup() {
        delegate?.checkUserStats()
        dismiss(animated: true, completion: nil)
    }
    
    // MARK: - IBActions
    @IBAction func onClearUserStatsTapped(_ sender: UIButton?) {
        clearUserStats()
    }
    
    @IBAction func close(_ sender: UIButton?) {
        closeStatsPopup()
    }
}

// MARK: - Kinda animating the values
extension QuizStatsPopupVC {
    @objc private func performAnimations() {
        viewModel.initialAllGames = 0
        viewModel.initialWonGames = 0
        
        allGamesCountLbl.text = String(viewModel.initialAllGames)
        wonGamesCountLbl.text = String(viewModel.initialWonGames)
        
        progressBar.setProgress(Float(viewModel.actualProgress), animated: true)
        progressBar.progress = Float(viewModel.actualProgress)
        
        timer = Timer.scheduledTimer(timeInterval: 0.01, target: self, selector: #selector(incrementValues), userInfo: nil, repeats: true)
    }
    
    @objc func incrementValues() {
        if viewModel.initialAllGames < viewModel.actualAllGames && viewModel.initialWonGames < viewModel.actualWonGames {
            viewModel.initialAllGames += 1
            viewModel.initialWonGames += 1
            
            allGamesCountLbl.text = String(viewModel.initialAllGames)
            wonGamesCountLbl.text = String(viewModel.initialWonGames)
        } else if viewModel.initialAllGames < viewModel.actualAllGames && viewModel.initialWonGames == viewModel.actualWonGames {
            viewModel.initialAllGames += 1
            
            allGamesCountLbl.text = String(viewModel.initialAllGames)
        } else {
            timer.invalidate()
        }
    }
}

// MARK: - Gestures related functions
extension QuizStatsPopupVC {
    private func setupGestureRecognizer() {
        let gestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(performAnimations))
        popupView.addGestureRecognizer(gestureRecognizer)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        let touch = touches.first
        guard let location = touch?.location(in: self.view) else { return }
        if !popupView.frame.contains(location) {
            print("Tapped outside the view")
            closeStatsPopup()
        } else {
            print("Tapped inside the view")
        }
    }
}

// MARK: - Clear user stats
extension QuizStatsPopupVC {
    private func clearUserStats() {
        let alert = UIAlertController(title: "Clear user stats", message: "Are you sure that you want to clear all user stats?\nThis action can't be undone!", preferredStyle: .alert)
        
        let yesAction = UIAlertAction(title: "Yes", style: .destructive, handler: {(_) in
            let defaults = UserDefaults.standard
            
            defaults.set(0, forKey: UDKeys.WonGames)
            defaults.set(0, forKey: UDKeys.AllGames)
            
            self.closeStatsPopup()
        })
        let noAction = UIAlertAction(title: "No", style: .cancel, handler: nil)
        
        alert.addAction(yesAction)
        alert.addAction(noAction)
        
        alert.view.tintColor = .systemGray
        
        self.present(alert, animated: true, completion: nil)
    }
}
