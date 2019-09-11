//
//  ViewController.swift
//  SearchImage
//
//  Created by Hiroshi Nasu on 8/8/19.
//  Copyright © 2019 Hiroshi Nasu. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        //let ium = ImageUrl.shared()
        //ium.deleteAll()
        
        let galleryManager = Gallery.shared()
        let galleryAll = galleryManager.get(withPredicate: NSPredicate(format: "%@ == name", argumentArray: ["All"]))
        if galleryAll.count == 0 {
            let newGallery = galleryManager.getCreate()
            newGallery.name = "All"
            galleryManager.saveChanges()
        }
    }

    /*
    @IBAction func goToWebBrowser(_ sender: UIButton) {
        let storyboard = UIStoryboard(name: "WebBrowser", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "WebBrowserViewController") as! WebBrowserViewController
        present(vc, animated: true, completion: nil)
    }
 */
    
}

