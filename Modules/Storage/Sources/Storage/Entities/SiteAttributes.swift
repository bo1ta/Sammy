//
//  SiteAttributes+CoreDataClass.swift
//  Sammy
//
//  Created by Alexandru Solomon on 17.05.2025.
//
//

import CoreData
import Foundation

// MARK: - SiteAttributes

@objc(SiteAttributes)
public class SiteAttributes: NSManagedObject {
    @nonobjc
    public class func fetchRequest() -> NSFetchRequest<SiteAttributes> {
        NSFetchRequest<SiteAttributes>(entityName: "SiteAttributes")
    }

    @NSManaged public var uniqueID: Int64
    @NSManaged public var name: String?
    @NSManaged public var sidebar: String?
    @NSManaged public var publishedAt: String?
    @NSManaged public var updatedAt: String?
    @NSManaged public var icon: String?
    @NSManaged public var banner: String?
    @NSManaged public var siteDescription: String?
    @NSManaged public var actorID: String?
    @NSManaged public var lastRefreshedAt: String?
    @NSManaged public var inboxURL: String?
    @NSManaged public var contentWarning: String?
    @NSManaged public var publicKey: String?
    @NSManaged public var instanceID: Int64
}

// MARK: Identifiable

extension SiteAttributes: Identifiable { }
