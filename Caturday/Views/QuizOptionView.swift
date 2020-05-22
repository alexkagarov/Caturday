//
//  QuizOptionView.swift
//  Caturday
//
//  Created by Cryptoshell on 21.05.2020.
//  Copyright © 2020 hialex. All rights reserved.
//

import UIKit

class QuizOptionView: UIView {

    @IBOutlet weak var contentView: UIView!
    @IBOutlet weak var bgView: UIView!
    @IBOutlet weak var buttonLabel: UILabel!
    @IBOutlet weak var actionButton: UIButton!

    var buttonAction: ((QuizOptionView)->())?
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        commonInit()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    
    func commonInit() {
        let bundle = Bundle(for: QuizOptionView.self)
        bundle.loadNibNamed("QuizOptionView", owner: self, options: nil)
        
        addSubview(contentView)
        contentView.frame = self.bounds
        contentView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
    }
    
    @IBAction func onButtonTapped(_ sender: UIButton?) {
        buttonAction?(self)
    }
}
