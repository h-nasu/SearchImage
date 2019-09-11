//
//  ImageUrl+CoreDataClass.swift
//  SearchImage
//
//  Created by Hiroshi Nasu on 6/9/19.
//  Copyright © 2019 Hiroshi Nasu. All rights reserved.
//
//

import Foundation
import CoreData

@objc(ImageUrl)
public class ImageUrl: NSManagedObject {
    private static var imageUrlManager = CoreDataManager<ImageUrl>(entityName: "ImageUrl")
    class func shared() -> CoreDataManager<ImageUrl> {
        return imageUrlManager
    }
}
