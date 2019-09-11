//
//  Gallery+CoreDataProperties.swift
//  SearchImage
//
//  Created by Hiroshi Nasu on 7/9/19.
//  Copyright © 2019 Hiroshi Nasu. All rights reserved.
//
//

import Foundation
import CoreData


extension Gallery {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Gallery> {
        return NSFetchRequest<Gallery>(entityName: "Gallery")
    }

    @NSManaged public var name: String?
    @NSManaged public var imageUrls: NSSet?

}

// MARK: Generated accessors for imageUrls
extension Gallery {

    @objc(addImageUrlsObject:)
    @NSManaged public func addToImageUrls(_ value: ImageUrl)

    @objc(removeImageUrlsObject:)
    @NSManaged public func removeFromImageUrls(_ value: ImageUrl)

    @objc(addImageUrls:)
    @NSManaged public func addToImageUrls(_ values: NSSet)

    @objc(removeImageUrls:)
    @NSManaged public func removeFromImageUrls(_ values: NSSet)

}
