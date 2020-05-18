//
//  SinglePhotoVC.swift
//  Caturday
//
//  Created by Oleksii Kaharov on 5/9/20.
//  Copyright © 2020 hialex. All rights reserved.
//

import UIKit

class SinglePhotoVC: UIViewController {

    @IBOutlet weak var imageView: UIImageView!
    
    var viewModel: SinglePhotoVM!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        imageView.image = viewModel.image
    }
    
    @IBAction func onCloseButtonTapped(_ sender: UIButton?) {
        self.dismiss(animated: true, completion: nil)
    }
}
