//
//  PersonDetails+CoreDataClass.swift
//  Sammy
//
//  Created by Alexandru Solomon on 17.05.2025.
//
//

import CoreData
import Foundation

// MARK: - PersonDetails

@objc(PersonDetails)
public class PersonDetails: NSManagedObject {
    @nonobjc
    public class func fetchRequest() -> NSFetchRequest<PersonDetails> {
        NSFetchRequest<PersonDetails>(entityName: "PersonDetails")
    }

    @NSManaged public var personID: Int64
    @NSManaged public var comments: NSSet?
    @NSManaged public var posts: NSSet?
}

// MARK: Generated accessors for posts
extension PersonDetails {

    @objc(addPostsObject:)
    @NSManaged
    public func addToPosts(_ value: Post)

    @objc(removePostsObject:)
    @NSManaged
    public func removeFromPosts(_ value: Post)

    @objc(addPosts:)
    @NSManaged
    public func addToPosts(_ values: NSSet)

    @objc(removePosts:)
    @NSManaged
    public func removeFromPosts(_ values: NSSet)

}

// MARK: Identifiable

extension PersonDetails: Identifiable { }
