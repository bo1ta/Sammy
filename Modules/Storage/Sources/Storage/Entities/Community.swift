//
//  Community+CoreDataClass.swift
//  Sammy
//
//  Created by Alexandru Solomon on 17.05.2025.
//
//

import CoreData
import Foundation

// MARK: - Community

@objc(Community)
public class Community: NSManagedObject {
    @nonobjc
    public class func fetchRequest() -> NSFetchRequest<Community> {
        NSFetchRequest<Community>(entityName: "Community")
    }

    @NSManaged public var subscribed: String?
    @NSManaged public var blocked: Bool
    @NSManaged public var bannedFromCommunity: Bool
    @NSManaged public var communityAttributes: CommunityAttributes?
    @NSManaged public var communityCounts: CommunityCounts?
    @NSManaged public var personModerates: NSSet?
}

// MARK: Identifiable

extension Community: Identifiable { }
