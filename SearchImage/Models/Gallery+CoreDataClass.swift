//
//  Gallery+CoreDataClass.swift
//  SearchImage
//
//  Created by Hiroshi Nasu on 6/9/19.
//  Copyright © 2019 Hiroshi Nasu. All rights reserved.
//
//

import Foundation
import CoreData

@objc(Gallery)
public class Gallery: NSManagedObject {
    private static var galleryManager = CoreDataManager<Gallery>(entityName: "Gallery")
    class func shared() -> CoreDataManager<Gallery> {
        return galleryManager
    }
}
