//
//  SinglePhotoVC.swift
//  Caturday
//
//  Created by Oleksii Kaharov on 5/9/20.
//  Copyright © 2020 hialex. All rights reserved.
//

import UIKit

class SinglePhotoVC: UIViewController {

    // MARK: - IBOutlets
    @IBOutlet weak var imageView: UIImageView!
    
    // MARK: - Variables
    var viewModel: SinglePhotoVM!
    
    // MARK: - VC Life cycle
    override func viewDidLoad() {
        super.viewDidLoad()

        imageView.image = viewModel.image
    }
    
    // MARK: - IBActions
    @IBAction func onCloseButtonTapped(_ sender: UIButton?) {
        self.dismiss(animated: true, completion: nil)
    }
}
