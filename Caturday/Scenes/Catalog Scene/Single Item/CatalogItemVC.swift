//
//  CatalogItemVC.swift
//  Caturday
//
//  Created by Oleksii Kaharov on 5/9/20.
//  Copyright © 2020 hialex. All rights reserved.
//

import UIKit

class CatalogItemVC: UIViewController {

    // MARK: - IBOutlets
    @IBOutlet weak var tableView: UITableView!
    
    // MARK: - Variables
    var viewModel: CatalogItemVM!
    
    // MARK: - VC Life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "\(viewModel?.model.name ?? "")"
    }
}

// MARK: - Table View Data Source VC Extension
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
            
            if viewModel.model.image != UIImage() {
                cell.catImage.isHidden = false
                cell.catImage.image = viewModel.model.image
            } else {
                if let vm = viewModel, let url = vm.model.imageURLObject.url {
                    vm.getImage(url: url, success: {
                        DispatchQueue.main.async {
                            cell.catImage.isHidden = false
                            cell.loadingView.isHidden = true
                            cell.catImage.image = self.viewModel.model.image
                            tableView.reloadData()
                        }
                    })
                }
            }
            
            return cell
        case 1:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "DescriptionCell", for: indexPath) as? CatalogItemDescrTVC else { return UITableViewCell() }
            
            if let vm = viewModel {
                cell.descrLabel.text = vm.model.description
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

extension CatalogItemVC: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.section == 0 {
            if viewModel.model.image != UIImage() {
                if viewModel.model.image.size.height != 0 || viewModel.model.image.size.height != 0 {
                    let aspectRatio = viewModel.model.image.size.width / viewModel.model.image.size.height
                    return tableView.frame.width / aspectRatio
                } else {
                    return 100
                }
            } else {
                return 100
            }
        }
        
        return UITableView.automaticDimension
    }
}
