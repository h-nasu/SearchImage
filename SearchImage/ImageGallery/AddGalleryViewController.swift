//
//  AddGalleryViewController.swift
//  SearchImage
//
//  Created by Hiroshi Nasu on 6/9/19.
//  Copyright © 2019 Hiroshi Nasu. All rights reserved.
//

import UIKit

protocol AddGalleryDelegate {
    func didfinish(addGalleryViewController: AddGalleryViewController, galleryName: String?)
}

class AddGalleryViewController: UIViewController {
    
    var delegate: AddGalleryDelegate! = nil

    @IBOutlet weak var galleryNameTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
    }

    @IBAction func tapSaveButton(_ sender: UIButton) {
        if let galleryName = galleryNameTextField.text {
            self.delegate.didfinish(addGalleryViewController: self, galleryName: galleryName)
        }
    }
    
    @IBAction func tapCancelButton(_ sender: UIButton) {
        self.delegate.didfinish(addGalleryViewController: self, galleryName: nil)
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
