//
//  CatalogItemVC.swift
//  Caturday
//
//  Created by Oleksii Kaharov on 5/9/20.
//  Copyright © 2020 hialex. All rights reserved.
//

import UIKit

class CatalogItemVC: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    
    var viewModel: CatalogItemVM?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
}

extension CatalogItemVC: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 4
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let vm = viewModel {
            switch section {
            case 0: return 1
            case 1: return 1
            case 2: return vm.model.boolCats.count
            case 3: return vm.model.progCats.count
            default: return 0
            }
        }
        
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.section {
        case 0:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "ImageCell", for: indexPath) as? CatalogItemImageTVC else { return UITableViewCell() }
            
            DispatchQueue.main.async {
                cell.catImage.image = UIImage(named: "push-\(Int.random(in: 0...4))")
            }
//            if let vm = viewModel, let url = vm.model.image.url {
//                vm.setImage(url: url, element: cell.catImage)
//            }
            
            return cell
        case 1:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "DescriptionCell", for: indexPath) as? CatalogItemDescrTVC else { return UITableViewCell() }
            
            if let vm = viewModel {
                cell.label.text = vm.model.description
            }
            
            return cell
        case 2:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "BooleanCell", for: indexPath) as? CatalogItemBoolTVC else { return UITableViewCell() }
            
            if let vm = viewModel {
                cell.categoryName.text = vm.model.boolCats[indexPath.row].name
                cell.categoryValue.text = vm.model.boolCats[indexPath.row].state ? "✅" : "❌"
            }
            
            return cell
        case 3:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "PercentageCell", for: indexPath) as? CatalogItemProgTVC else { return UITableViewCell() }
            
            if let vm = viewModel {
                cell.categoryName.text = vm.model.progCats[indexPath.row].name
                cell.percentage.progress = vm.model.progCats[indexPath.row].value
            }
            
            return cell
        default:
            return UITableViewCell()
        }
    }
}
