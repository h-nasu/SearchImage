//
//  AddToImageGalleryViewController.swift
//  SearchImage
//
//  Created by Hiroshi Nasu on 7/9/19.
//  Copyright © 2019 Hiroshi Nasu. All rights reserved.
//

import UIKit

protocol AddToImageGalleryDelegate {
    func didfinish(addToImageGalleryViewController: AddToImageGalleryViewController, saveGalleries: [Gallery]?, imageUrl: ImageUrl?)
}

class AddToImageGalleryViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    var delegate: AddToImageGalleryDelegate! = nil
    let galleryManger = Gallery.shared()
    var galleries: [Gallery]!
    var galleryIndex = [Int]()
    let imageUrlManager = ImageUrl.shared()
    var imageUrlString: String! {
        didSet {
            configure()
        }
    }
    var imageUrl: ImageUrl!
    
    // cell reuse id (cells that scroll out of view can be reused)
    let cellReuseIdentifier = "cell"
    
    @IBOutlet weak var tableView: UITableView!
    
    func configure() {
        let imageUrls = self.imageUrlManager.get(withPredicate: NSPredicate(format: "%@ == urlString", argumentArray: [self.imageUrlString ?? ""]))
        self.imageUrl = imageUrls[0]
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        self.galleries = self.galleryManger.getAll()
        
        // Register the table view cell class and its reuse id
        self.tableView.register(UITableViewCell.self, forCellReuseIdentifier: cellReuseIdentifier)
        self.tableView.delegate = self
        self.tableView.dataSource = self

    }
    
    @IBAction func tapSave(_ sender: UIBarButtonItem) {
        var saveGalleries = [Gallery]()
        for index in self.galleryIndex {
            saveGalleries.append(self.galleries[index])
        }
        self.delegate.didfinish(addToImageGalleryViewController: self, saveGalleries: saveGalleries, imageUrl: self.imageUrl)
        
    }
    
    @IBAction func tapCancel(_ sender: UIBarButtonItem) {
        self.delegate.didfinish(addToImageGalleryViewController: self, saveGalleries: nil, imageUrl: nil)
    }
    
    // number of rows in table view
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.galleries.count
    }
    
    // create a cell for each table view row
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellReuseIdentifier, for: indexPath)
        
        // set the text from the data model
        let galleryName = self.galleries[indexPath.row].name
        cell.textLabel?.text = galleryName
        if let galleries = self.imageUrl?.gallerys?.allObjects  {
            for gallery in galleries as! [Gallery] {
                if gallery.name == galleryName {
                    cell.accessoryType = .checkmark
                    self.galleryIndex.append(indexPath.row)
                }
            }
        }
        if self.imageUrl == nil && galleryName == "All" {
            cell.accessoryType = .checkmark
            self.galleryIndex.append(indexPath.row)
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let cell = tableView.cellForRow(at: indexPath) {
            if cell.accessoryType == .checkmark {
                cell.accessoryType = .none
                if let index = self.galleryIndex.firstIndex(of: indexPath.row) {
                    self.galleryIndex.remove(at: index)
                }
            } else {
                cell.accessoryType = .checkmark
                self.galleryIndex.append(indexPath.row)
            }
            
        }
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
