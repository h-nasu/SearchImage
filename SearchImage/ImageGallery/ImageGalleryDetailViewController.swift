//
//  DetailViewController.swift
//  MaterialDetail
//
//  Created by Hiroshi Nasu on 7/8/19.
//  Copyright © 2019 Hiroshi Nasu. All rights reserved.
//

import UIKit

class ImageGalleryDetailViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    //var gallery: Gallery!
    var imagesArray: [String]!
    var gallery: Gallery!

    @IBOutlet weak var collectionView: UICollectionView!
    
    func configureView() {
        // Update the user interface for the detail item.
        self.imagesArray = []
        for imageUrl in self.gallery?.imageUrls?.allObjects as! [ImageUrl] {
            self.imagesArray.append(imageUrl.urlString ?? "")
        }
        if collectionView != nil {
            collectionView.reloadData()
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        self.collectionView.dataSource = self
        self.collectionView.delegate = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        configureView()
    }
    
    // layout
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        //return CGSize(width: (self.collectionView.frame.size.width-15) / 2, height: self.collectionView.frame.size.height / 3)
        let size = (self.collectionView.frame.size.width-15) / 2
        return CGSize(width:size, height: size)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 5, left: 5, bottom: 0, right: 0)
    }
    
    // Collection View
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.imagesArray.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath) as! ImageGalleryCollectionViewCell
        cell.layer.borderColor = UIColor.lightGray.cgColor
        cell.layer.borderWidth = 0.5
        
        if let imageUrl = self.imagesArray?[indexPath.row] {
            cell.imageView.downloaded(from: imageUrl)
            cell.imageView.contentMode = .scaleAspectFill
        }
        
        return cell
    }
    
    // MARK: - Segues
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "imageFull" {
            if let indexPath = collectionView.indexPathsForSelectedItems {
                let currentImage = indexPath[0].row
                guard let imageVC = segue.destination as? ImageFullViewController else {
                    fatalError("Unexpected destination: \(segue.destination)")
                }
                imageVC.imagesArray = self.imagesArray
                imageVC.currentImage = currentImage
            }
        }
    }


}

