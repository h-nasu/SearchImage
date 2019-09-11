//
//  ImageUrl+CoreDataProperties.swift
//  SearchImage
//
//  Created by Hiroshi Nasu on 7/9/19.
//  Copyright © 2019 Hiroshi Nasu. All rights reserved.
//
//

import Foundation
import CoreData


extension ImageUrl {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<ImageUrl> {
        return NSFetchRequest<ImageUrl>(entityName: "ImageUrl")
    }

    @NSManaged public var urlString: String?
    @NSManaged public var gallerys: NSSet?

}

// MARK: Generated accessors for gallerys
extension ImageUrl {

    @objc(addGallerysObject:)
    @NSManaged public func addToGallerys(_ value: Gallery)

    @objc(removeGallerysObject:)
    @NSManaged public func removeFromGallerys(_ value: Gallery)

    @objc(addGallerys:)
    @NSManaged public func addToGallerys(_ values: NSSet)

    @objc(removeGallerys:)
    @NSManaged public func removeFromGallerys(_ values: NSSet)

}
