//
//  PersonCounts+CoreDataClass.swift
//  Sammy
//
//  Created by Alexandru Solomon on 17.05.2025.
//
//

import CoreData
import Foundation

// MARK: - PersonCounts

@objc(PersonCounts)
public class PersonCounts: NSManagedObject {
    @nonobjc
    public class func fetchRequest() -> NSFetchRequest<PersonCounts> {
        NSFetchRequest<PersonCounts>(entityName: "PersonCounts")
    }

    @NSManaged public var personID: Int64
    @NSManaged public var postCount: Int64
    @NSManaged public var commentCount: Int64
    @NSManaged public var personProfile: PersonProfile?
}

// MARK: Identifiable

extension PersonCounts: Identifiable { }
