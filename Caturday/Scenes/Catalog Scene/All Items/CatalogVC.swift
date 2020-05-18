//
//  CatalogVC.swift
//  Caturday
//
//  Created by Oleksii Kaharov on 5/9/20.
//  Copyright © 2020 hialex. All rights reserved.
//

import UIKit

class CatalogVC: UIViewController {
    
    // MARK: - IBOutlets
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var loadingView: UIView!
    @IBOutlet weak var loadingIndicator: UIActivityIndicatorView!
    
    // MARK: - Variables
    var viewModel = CatalogVM()
    
    // MARK: - VC Life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        loadingIndicator.startAnimating()
        tableView.isHidden = true
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        if viewModel.breeds.count == 0 {
            loadingIndicator.startAnimating()
            tableView.isHidden = true
            viewModel.getAllBreeds(success: {
                DispatchQueue.main.async {
                    self.loadingIndicator.stopAnimating()
                    self.tableView.isHidden = false
                    self.tableView.reloadData()
                }
            })
        }
    }
    
    // MARK: - Prepare for segue
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == Segues.ToSingleBreed {
            guard let vc = segue.destination as? CatalogItemVC else { return }
            
            if let vm = viewModel.selectedCellVM {
                vc.viewModel = vm
            }
        }
    }
}

// MARK: - TableView Extensions
extension CatalogVC: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        let selectedBreed = viewModel.breeds[indexPath.row]
        
        viewModel.prepareVM(breedModel: selectedBreed, success: {
            DispatchQueue.main.async {
                self.performSegue(withIdentifier: Segues.ToSingleBreed, sender: self)
            }
        })
    }
}

extension CatalogVC: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.breeds.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "CatalogCell", for: indexPath) as? CatalogTVC else { return UITableViewCell() }
        
        cell.cellLabel.text = viewModel.breeds[indexPath.row].name
        
        if indexPath.row == viewModel.breeds.count - 1 && viewModel.breeds.count < viewModel.breedsCount {
            viewModel.getMoreBreeds(success: {
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                }
            })
        }
        
        return cell
    }
}
