//
//  CommunityCounts+CoreDataClass.swift
//  Sammy
//
//  Created by Alexandru Solomon on 17.05.2025.
//
//

import CoreData
import Foundation

// MARK: - CommunityCounts

@objc(CommunityCounts)
public class CommunityCounts: NSManagedObject {

    @nonobjc
    public class func fetchRequest() -> NSFetchRequest<CommunityCounts> {
        NSFetchRequest<CommunityCounts>(entityName: "CommunityCounts")
    }

    @NSManaged public var communityID: Int64
    @NSManaged public var subscribers: Int64
    @NSManaged public var posts: Int64
    @NSManaged public var comments: Int64
    @NSManaged public var published: String?
    @NSManaged public var usersActiveDay: Int64
    @NSManaged public var usersActiveWeek: Int64
    @NSManaged public var usersActiveHalfYear: Int64
    @NSManaged public var subscribersLocal: Int64
    @NSManaged public var attribute: NSObject?
    @NSManaged public var community: Community?
}

// MARK: Identifiable

extension CommunityCounts: Identifiable { }
