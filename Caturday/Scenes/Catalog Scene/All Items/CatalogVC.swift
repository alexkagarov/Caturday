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
    
    // MARK: - Variables
    var viewModel = CatalogVM()
    var selectedCellVM: CatalogItemVM?
    
    // MARK: - VC Life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        viewModel.getAllBreeds(success: {
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        })
    }
    
    // MARK: - Prepare for segue
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == Segues.ToSingleBreed {
            guard let vc = segue.destination as? CatalogItemVC else { return }
            
            if let vm = selectedCellVM {
                vc.viewModel = vm
            }
        }
    }
}

extension CatalogVC {
    func prepareVM(breedModel: BreedModel, success: (()->Void)?) {
        guard let name = breedModel.name else { return }
        guard let desc = breedModel.description else { return }
        
        var boolCats = [BoolBreedCategoryProtocol]()
        
        if let cat = breedModel.experimental {
            let boolCat = BoolBreedCategory(name: "Experimental", state: cat == 0 ? false : true)
            boolCats.append(boolCat)
        }
        
        if let cat = breedModel.hairless {
            let boolCat = BoolBreedCategory(name: "Hairless", state: cat == 0 ? false : true)
            boolCats.append(boolCat)
        }
        
        if let cat = breedModel.natural {
            let boolCat = BoolBreedCategory(name: "Natural", state: cat == 0 ? false : true)
            boolCats.append(boolCat)
        }
        
        if let cat = breedModel.rare {
            let boolCat = BoolBreedCategory(name: "Rare", state: cat == 0 ? false : true)
            boolCats.append(boolCat)
        }
        
        if let cat = breedModel.rex {
            let boolCat = BoolBreedCategory(name: "Rex", state: cat == 0 ? false : true)
            boolCats.append(boolCat)
        }
        
        if let cat = breedModel.suppressedTail {
            let boolCat = BoolBreedCategory(name: "Suppressed tail", state: cat == 0 ? false : true)
            boolCats.append(boolCat)
        }
        
        if let cat = breedModel.shortLegs {
            let boolCat = BoolBreedCategory(name: "Short legs", state: cat == 0 ? false : true)
            boolCats.append(boolCat)
        }
        
        if let cat = breedModel.hypoallergenic {
            let boolCat = BoolBreedCategory(name: "Hypoallergenic", state: cat == 0 ? false : true)
            boolCats.append(boolCat)
        }
        
        var progCats = [FloatBreedCategoryProtocol]()
        
        if let cat = breedModel.adaptability {
            let progCat = FloatBreedCategory(name: "Adaptability", value: Float(cat)/5.0)
            progCats.append(progCat)
        }
        
        if let cat = breedModel.affectionLevel {
            let progCat = FloatBreedCategory(name: "Affection level", value: Float(cat)/5.0)
            progCats.append(progCat)
        }
        
        if let cat = breedModel.childFriendly {
            let progCat = FloatBreedCategory(name: "Child friendly", value: Float(cat)/5.0)
            progCats.append(progCat)
        }
        
        if let cat = breedModel.dogFriendly {
            let progCat = FloatBreedCategory(name: "Dog friendly", value: Float(cat)/5.0)
            progCats.append(progCat)
        }
        
        if let cat = breedModel.energyLevel {
            let progCat = FloatBreedCategory(name: "Energy level", value: Float(cat)/5.0)
            progCats.append(progCat)
        }
        
        if let cat = breedModel.grooming {
            let progCat = FloatBreedCategory(name: "Grooming", value: Float(cat)/5.0)
            progCats.append(progCat)
        }
        
        if let cat = breedModel.healthIssues {
            let progCat = FloatBreedCategory(name: "Health issues", value: Float(cat)/5.0)
            progCats.append(progCat)
        }
        
        if let cat = breedModel.intelligence {
            let progCat = FloatBreedCategory(name: "Intelligence", value: Float(cat)/5.0)
            progCats.append(progCat)
        }
        
        if let cat = breedModel.sheddingLevel {
            let progCat = FloatBreedCategory(name: "Shedding level", value: Float(cat)/5.0)
            progCats.append(progCat)
        }
        
        if let cat = breedModel.socialNeeds {
            let progCat = FloatBreedCategory(name: "Social needs", value: Float(cat)/5.0)
            progCats.append(progCat)
        }
        
        if let cat = breedModel.strangerFriendly {
            let progCat = FloatBreedCategory(name: "Stranger friendly", value: Float(cat)/5.0)
            progCats.append(progCat)
        }
        
        if let cat = breedModel.vocalisation {
            let progCat = FloatBreedCategory(name: "Vocalisation", value: Float(cat)/5.0)
            progCats.append(progCat)
        }
        
        var breedImageModel = ImageModel()
        
        if let id = breedModel.id {
//            let singleModel = SingleBreedModel(name: name, description: desc, image: breedImageModel, boolCats: boolCats, progCats: progCats)

//            self.selectedCellVM = CatalogItemVM(model: singleModel)
//            success?()
            // TODO:
            viewModel.getImageURL(breedID: id, success: { (data) in
                breedImageModel = data

                let singleModel = SingleBreedModel(name: name, description: desc, imageURLObject: breedImageModel, boolCats: boolCats, progCats: progCats)

                self.selectedCellVM = CatalogItemVM(model: singleModel)
                success?()
            })
        }
    }
}

// MARK: - TableView Extensions
extension CatalogVC: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
//        guard let cell = tableView.dequeueReusableCell(withIdentifier: "CatalogCell", for: indexPath) as? CatalogTVC else { return }
        
        let selectedBreed = viewModel.breeds[indexPath.row]
        
        prepareVM(breedModel: selectedBreed, success: {
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
        
        cell.breed = viewModel.breeds[indexPath.row]
        
        if let breed = cell.breed {
            cell.cellLabel.text = breed.name
        }
        
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
