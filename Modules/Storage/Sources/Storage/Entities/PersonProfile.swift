//
//  PersonProfile+CoreDataClass.swift
//  Sammy
//
//  Created by Alexandru Solomon on 17.05.2025.
//
//

import CoreData
import Foundation

// MARK: - PersonProfile

@objc(PersonProfile)
public class PersonProfile: NSManagedObject {
    @nonobjc
    public class func fetchRequest() -> NSFetchRequest<PersonProfile> {
        NSFetchRequest<PersonProfile>(entityName: "PersonProfile")
    }

    @NSManaged public var isAdmin: Bool
    @NSManaged public var personAttributes: PersonAttributes?
    @NSManaged public var personCounts: PersonCounts?

}

// MARK: Identifiable

extension PersonProfile: Identifiable { }
