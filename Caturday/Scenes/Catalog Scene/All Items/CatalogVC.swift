//
//  CatalogVC.swift
//  Caturday
//
//  Created by Oleksii Kaharov on 5/9/20.
//  Copyright © 2020 hialex. All rights reserved.
//

import UIKit

class CatalogVC: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()

    }
}

extension CatalogVC: UITableViewDelegate {
    
}

extension CatalogVC: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "CatalogCell", for: indexPath) as? CatalogTVC else { return UITableViewCell() }
        return cell
    }
}
