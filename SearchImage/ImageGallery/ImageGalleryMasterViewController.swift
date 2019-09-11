//
//  MasterViewController.swift
//  MaterialDetail
//
//  Created by Hiroshi Nasu on 7/8/19.
//  Copyright © 2019 Hiroshi Nasu. All rights reserved.
//

import UIKit

class ImageGalleryMasterViewController: UITableViewController, AddGalleryDelegate {

    var detailViewController: ImageGalleryDetailViewController? = nil
    let galleryManager = Gallery.shared()
    var galleries = [Gallery]()
    let addGalleryVC = AddGalleryViewController(nibName: "AddGalleryViewController", bundle: nil)

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        //navigationItem.leftBarButtonItem = editButtonItem

        let addButton = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(insertNewObject(_:)))
        navigationItem.rightBarButtonItem = addButton
        
        self.addGalleryVC.delegate = self
        
        self.galleries = self.galleryManager.getAll()
        /*
        if let split = splitViewController {
            let controllers = split.viewControllers
            detailViewController = (controllers[controllers.count-1] as! UINavigationController).topViewController as? DetailViewController
        }
 */
    }

    override func viewWillAppear(_ animated: Bool) {
        //clearsSelectionOnViewWillAppear = splitViewController!.isCollapsed
        super.viewWillAppear(animated)
    }
    
    func didfinish(addGalleryViewController: AddGalleryViewController, galleryName: String?) {
        if let name = galleryName {
            let gallery = self.galleryManager.getCreate()
            gallery.name = name
            self.galleryManager.saveChanges()
            self.galleries = self.galleryManager.getAll()
        }
        addGalleryViewController.dismiss(animated: true, completion: nil)
        self.tableView.reloadData()
    }

    @objc
    func insertNewObject(_ sender: Any) {
        /*
        objects.insert(NSDate(), at: 0)
        let indexPath = IndexPath(row: 0, section: 0)
        tableView.insertRows(at: [indexPath], with: .automatic)
        */
        self.present(self.addGalleryVC, animated: true, completion: nil)
    }

    // MARK: - Segues

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showDetail" {
            if let indexPath = tableView.indexPathForSelectedRow {
                let gallery = self.galleries[indexPath.row]
                guard let imageGalleryVC = segue.destination as? ImageGalleryDetailViewController else {
                    fatalError("Unexpected destination: \(segue.destination)")
                }
                imageGalleryVC.gallery = gallery
            }
        }
    }

    // MARK: - Table View

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.galleries.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)

        let gallery = self.galleries[indexPath.row]
        cell.textLabel!.text = gallery.name
        return cell
    }

    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }

    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let gallery = self.galleries[indexPath.row]
            self.galleryManager.delete(id: gallery.objectID)
            galleries.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
            galleryManager.saveChanges()
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view.
        }
    }


}

