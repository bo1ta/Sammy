//
//  PersonModerates+CoreDataClass.swift
//  Sammy
//
//  Created by Alexandru Solomon on 17.05.2025.
//
//

import CoreData
import Foundation

// MARK: - PersonModerates

@objc(PersonModerates)
public class PersonModerates: NSManagedObject {
    @nonobjc
    public class func fetchRequest() -> NSFetchRequest<PersonModerates> {
        NSFetchRequest<PersonModerates>(entityName: "PersonModerates")
    }

    @NSManaged public var personID: Int64
    @NSManaged public var communities: NSSet?
    @NSManaged public var moderator: PersonAttributes?
}

// MARK: Generated accessors for communities
extension PersonModerates {

    @objc(addCommunitiesObject:)
    @NSManaged
    public func addToCommunities(_ value: Community)

    @objc(removeCommunitiesObject:)
    @NSManaged
    public func removeFromCommunities(_ value: Community)

    @objc(addCommunities:)
    @NSManaged
    public func addToCommunities(_ values: NSSet)

    @objc(removeCommunities:)
    @NSManaged
    public func removeFromCommunities(_ values: NSSet)

}

// MARK: Identifiable

extension PersonModerates: Identifiable { }
