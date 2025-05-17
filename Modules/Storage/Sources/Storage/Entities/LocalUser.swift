//
//  LocalUser+CoreDataClass.swift
//  Sammy
//
//  Created by Alexandru Solomon on 17.05.2025.
//
//

import CoreData
import Foundation

// MARK: - LocalUser

@objc(LocalUser)
public class LocalUser: NSManagedObject {

    @nonobjc
    public class func fetchRequest() -> NSFetchRequest<LocalUser> {
        NSFetchRequest<LocalUser>(entityName: "LocalUser")
    }

    @NSManaged public var userID: Int64
    @NSManaged public var personID: Int64
    @NSManaged public var localUserAttributes: LocalUserAttributes?
    @NSManaged public var personAttributes: PersonAttributes?
}

// MARK: Identifiable

extension LocalUser: Identifiable { }
