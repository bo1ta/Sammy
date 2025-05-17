//
//  CommunityAttributes+CoreDataClass.swift
//  Sammy
//
//  Created by Alexandru Solomon on 17.05.2025.
//
//

import CoreData
import Foundation

// MARK: - CommunityAttributes

@objc(CommunityAttributes)
public class CommunityAttributes: NSManagedObject {
    @nonobjc
    public class func fetchRequest() -> NSFetchRequest<CommunityAttributes> {
        NSFetchRequest<CommunityAttributes>(entityName: "CommunityAttributes")
    }

    @NSManaged public var uniqueID: Int64
    @NSManaged public var name: String?
    @NSManaged public var title: String?
    @NSManaged public var communityDescription: String?
    @NSManaged public var publishedAt: String?
    @NSManaged public var updatedAt: String?
    @NSManaged public var icon: String?
    @NSManaged public var banner: String?
    @NSManaged public var visibility: String?
    @NSManaged public var community: Community?
    @NSManaged public var comments: NSSet?
    @NSManaged public var posts: Post?
}

// MARK: Identifiable

extension CommunityAttributes: Identifiable { }
