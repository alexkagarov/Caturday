//
//  PhotoGalleryVC.swift
//  Caturday
//
//  Created by Oleksii Kaharov on 5/9/20.
//  Copyright © 2020 hialex. All rights reserved.
//

import UIKit

class PhotoGalleryVC: UIViewController {

    @IBOutlet weak var collectionView: UICollectionView!
    
    var viewModel: PhotoGalleryVM = PhotoGalleryVM()
    var selectedImage: UIImage?
    
    override func viewDidLoad() {
        super.viewDidLoad()

    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        viewModel.getImages(success: {
            DispatchQueue.main.async {
                self.collectionView.reloadData()
            }
        })
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        collectionView.collectionViewLayout.invalidateLayout()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "ShowSingleImage" {
            guard let destVC = segue.destination as? SinglePhotoVC else { return }
            
            if let selectedImage = selectedImage {
                let vm = SinglePhotoVM(image: selectedImage)
                
                destVC.viewModel = vm
            }
        }
    }
}

extension PhotoGalleryVC: UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.images.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "GalleryItem", for: indexPath) as? GalleryItemCVC else { return UICollectionViewCell() }

        cell.imageView.image = viewModel.images[indexPath.item].image
        
        if cell.imageView.image == nil {
            cell.activityIndicator.startAnimating()
            if let imageURL = viewModel.images[indexPath.item].imageURLObject.url {
                viewModel.getImage(url: imageURL, success: { (image) in
                    DispatchQueue.main.async {
                        self.viewModel.images[indexPath.item].image = image
                        cell.activityIndicator.stopAnimating()
                        collectionView.reloadItems(at: [indexPath])
                    }
                })
            }
        }
        
        if indexPath.row == viewModel.images.count - 1 && viewModel.images.count < viewModel.imagesCount {
            viewModel.getMoreImages(success: {
                DispatchQueue.main.async {
                    collectionView.reloadData()
                }
            })
        }
        
        return cell
    }
}

extension PhotoGalleryVC: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if let image = viewModel.images[indexPath.item].image {
            self.selectedImage = image
            performSegue(withIdentifier: "ShowSingleImage", sender: self)
        }
    }
}

extension PhotoGalleryVC: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let screenWidth = UIScreen.main.bounds.width
        
        let itemWidth = (screenWidth-3)/3
        
        return CGSize(width: itemWidth, height: itemWidth)
    }
    
    
}
