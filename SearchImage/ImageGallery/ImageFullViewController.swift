//
//  ImageFullViewController.swift
//  SearchImage
//
//  Created by Hiroshi Nasu on 7/9/19.
//  Copyright © 2019 Hiroshi Nasu. All rights reserved.
//

import UIKit

class ImageFullViewController: UIViewController, AddToImageGalleryDelegate {
    
    @IBOutlet weak var swipeImageView: UIImageView!
    
    var imagesArray: [String]!
    var currentImage = 0
    
    let addToImageGalleryVC = AddToImageGalleryViewController(nibName: "AddToImageGalleryViewController", bundle: nil)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // https://stackoverflow.com/questions/38529775/how-to-create-a-side-swiping-photo-gallery-in-swift-ios
        
        
        self.swipeImageView.downloaded(from: imagesArray[currentImage])
        
        let swipeRight = UISwipeGestureRecognizer(target: self, action: #selector(respondToSwipeGesture))
        swipeRight.direction = UISwipeGestureRecognizer.Direction.right
        self.view.addGestureRecognizer(swipeRight)
        
        let swipeLeft = UISwipeGestureRecognizer(target: self, action: #selector(respondToSwipeGesture))
        swipeLeft.direction = UISwipeGestureRecognizer.Direction.left
        self.view.addGestureRecognizer(swipeLeft)
        
        self.addToImageGalleryVC.delegate = self
        
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    @objc
    func respondToSwipeGesture(gesture: UIGestureRecognizer) {
        
        if let swipeGesture = gesture as? UISwipeGestureRecognizer {
            
            switch swipeGesture.direction {
            case UISwipeGestureRecognizer.Direction.left:
                if currentImage == imagesArray.count - 1 {
                    currentImage = 0
                    
                }else{
                    currentImage += 1
                }
                //self.swipeImageView.downloaded(from: imagesArray[currentImage])
                UIView.transition(with: self.swipeImageView,
                                  duration:0.2,
                                  options: .transitionCrossDissolve,
                                  animations: { self.swipeImageView.downloaded(from: self.imagesArray[self.currentImage]) },
                                  completion: nil)
                
            case UISwipeGestureRecognizer.Direction.right:
                if currentImage == 0 {
                    currentImage = imagesArray.count - 1
                }else{
                    currentImage -= 1
                }
                //self.swipeImageView.downloaded(from: imagesArray[currentImage])
                UIView.transition(with: self.swipeImageView,
                                  duration:0.2,
                                  options: .transitionCrossDissolve,
                                  animations: { self.swipeImageView.downloaded(from: self.imagesArray[self.currentImage]) },
                                  completion: nil)
            default:
                break
            }
        }
    }
    
    func didfinish(addToImageGalleryViewController: AddToImageGalleryViewController, saveGalleries: [Gallery]?, imageUrl: ImageUrl?) {
        if let galleries = saveGalleries, imageUrl != nil {
            imageUrl?.gallerys = nil
            for gallery in galleries {
                imageUrl?.addToGallerys(gallery)
            }
            let imageUrlManager = ImageUrl.shared()
            imageUrlManager.saveChanges()
        }
        addToImageGalleryViewController.dismiss(animated: true, completion: nil)
    }

    @IBAction func tapTrash(_ sender: UIBarButtonItem) {
        
        let deleteAlert = UIAlertController(title: "Delete", message: "Delete current image?", preferredStyle: UIAlertController.Style.alert)
        
        deleteAlert.addAction(UIAlertAction(title: "Ok", style: .default, handler: { (action: UIAlertAction!) in
            //print("Handle Ok logic here")
            let urlString = self.imagesArray[self.currentImage]
            let imageUrlManager = ImageUrl.shared()
            let imageUrls = imageUrlManager.get(withPredicate: NSPredicate(format: "%@ == urlString", argumentArray: [urlString]))
            imageUrlManager.delete(id: imageUrls[0].objectID)
            imageUrlManager.saveChanges()
            
            self.imagesArray.remove(at: self.currentImage)
            if self.currentImage == self.imagesArray.count {
                self.currentImage -= 1
            }
            if self.currentImage >= 0 {
                UIView.transition(with: self.swipeImageView,
                                  duration:0.2,
                                  options: .transitionCrossDissolve,
                                  animations: { self.swipeImageView.downloaded(from: self.imagesArray[self.currentImage]) },
                                  completion: nil)
            } else {
                self.navigationController?.popViewController(animated: true)
            }
        }))
        
        deleteAlert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: { (action: UIAlertAction!) in
            //print("Handle Cancel Logic here")
        }))
        
        present(deleteAlert, animated: true, completion: nil)
    }
    
    
    @IBAction func tapEdit(_ sender: UIBarButtonItem) {
        self.addToImageGalleryVC.imageUrlString = self.imagesArray[self.currentImage]
        self.present(self.addToImageGalleryVC, animated: true, completion: nil)
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
