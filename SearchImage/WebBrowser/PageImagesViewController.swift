//
//  PageImagesViewController.swift
//  SearchImage
//
//  Created by Hiroshi Nasu on 19/8/19.
//  Copyright © 2019 Hiroshi Nasu. All rights reserved.
//

import UIKit

class PageImagesViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, AddToImageGalleryDelegate {
    
    var imagesArray: [String]!
    var selectedImageIndex: [Int] = []

    @IBOutlet weak var collectionView: UICollectionView!
    
    let addToImageGalleryVC = AddToImageGalleryViewController(nibName: "AddToImageGalleryViewController", bundle: nil)
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        //print(self.imagesArray)
        
        self.collectionView.dataSource = self
        self.collectionView.delegate = self
        
        self.addToImageGalleryVC.delegate = self
        
        let add = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addTapped))
        navigationItem.rightBarButtonItems = [add]
        
        
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
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath) as! PageImagesCollectionViewCell
        cell.layer.borderColor = UIColor.lightGray.cgColor
        cell.layer.borderWidth = 0.5
        
        if let imageUrl = self.imagesArray?[indexPath.row] {
            cell.imageView.downloaded(from: imageUrl)
            cell.imageView.contentMode = .scaleAspectFill
        }
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let cell = collectionView.cellForItem(at: indexPath)
        
        if (cell?.layer.borderColor == UIColor.lightGray.cgColor) {
            cell?.layer.borderColor = UIColor.gray.cgColor
            cell?.layer.borderWidth = 2
            self.selectedImageIndex.append(indexPath.row)
        } else {
            cell?.layer.borderColor = UIColor.lightGray.cgColor
            cell?.layer.borderWidth = 0.5
            if let index = self.selectedImageIndex.firstIndex(of: indexPath.row) {
                self.selectedImageIndex.remove(at: index)
            }
        }
    }
    
    /*
    func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        let cell = collectionView.cellForItem(at: indexPath)
        cell?.layer.borderColor = UIColor.lightGray.cgColor
        cell?.layer.borderWidth = 0.5
    }
 */
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    
    @objc func addTapped() {
        self.present(self.addToImageGalleryVC, animated: true, completion: nil)
        
        /*
        let imageUrlIndexs = self.selectedImageIndex.sorted()
        
        let galleryManager = Gallery.shared()
        let galleryResult = galleryManager.get(withPredicate: NSPredicate(format: "%@ == name", argumentArray: ["All"]))
        let galleryAll = galleryResult[0]
        let imageUrlManager = ImageUrl.shared()
        
        for imageUrlIndex in imageUrlIndexs {
            let urlString = self.imagesArray[imageUrlIndex]
            let old = imageUrlManager.get(withPredicate: NSPredicate(format: "%@ == urlString", argumentArray: [urlString]))
            if old.count == 0 {
                let newImage = imageUrlManager.getCreate()
                newImage.urlString = urlString
                galleryAll.addToImageUrls(newImage)
            }
        }
        imageUrlManager.saveChanges()
        galleryManager.saveChanges()
        
        let alert = UIAlertController(title: "Save Image", message: "Selected images have been saved.", preferredStyle: .alert)
        self.present(alert, animated: true)
        alert.addAction(UIAlertAction(title: "Close", style: .default, handler: nil))
 */
        
    }
    
    func didfinish(addToImageGalleryViewController: AddToImageGalleryViewController, saveGalleries: [Gallery]?, imageUrl: ImageUrl?) {
        if let galleries = saveGalleries {
            let imageUrlIndexs = self.selectedImageIndex.sorted()
            
            
            let imageUrlManager = ImageUrl.shared()
            
            for imageUrlIndex in imageUrlIndexs {
                let urlString = self.imagesArray[imageUrlIndex]
                let old = imageUrlManager.get(withPredicate: NSPredicate(format: "%@ == urlString", argumentArray: [urlString]))
                if old.count == 0 {
                    let newImage = imageUrlManager.getCreate()
                    newImage.urlString = urlString
                    for gallery in galleries {
                        newImage.addToGallerys(gallery)
                    }
                }
            }
            imageUrlManager.saveChanges()
            
            addToImageGalleryViewController.dismiss(animated: true, completion: nil)
            
            let alert = UIAlertController(title: "Save Image", message: "Selected images have been saved.", preferredStyle: .alert)
            self.present(alert, animated: true)
            alert.addAction(UIAlertAction(title: "Close", style: .default, handler: nil))
        } else {
            addToImageGalleryViewController.dismiss(animated: true, completion: nil)
        }
    }

}
