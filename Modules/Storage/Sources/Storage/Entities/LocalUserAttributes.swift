//
//  LocalUserAttributes+CoreDataClass.swift
//  Sammy
//
//  Created by Alexandru Solomon on 17.05.2025.
//
//

import CoreData
import Foundation

// MARK: - LocalUserAttributes

@objc(LocalUserAttributes)
public class LocalUserAttributes: NSManagedObject {
    @nonobjc
    public class func fetchRequest() -> NSFetchRequest<LocalUserAttributes> {
        NSFetchRequest<LocalUserAttributes>(entityName: "LocalUserAttributes")
    }

    @NSManaged public var uniqueID: Int64
    @NSManaged public var personID: Int64
    @NSManaged public var email: String?
    @NSManaged public var showNSFW: Bool
    @NSManaged public var theme: String?
    @NSManaged public var defaultSortType: String?
    @NSManaged public var defaultListingType: String?
    @NSManaged public var interfaceLanguage: String?
    @NSManaged public var showAvatars: Bool
    @NSManaged public var localUser: LocalUser?
}

// MARK: Identifiable

extension LocalUserAttributes: Identifiable { }
