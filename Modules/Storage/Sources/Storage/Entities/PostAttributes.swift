//
//  PostAttributes+CoreDataClass.swift
//  Sammy
//
//  Created by Alexandru Solomon on 17.05.2025.
//
//

import CoreData
import Foundation

// MARK: - PostAttributes

@objc(PostAttributes)
public class PostAttributes: NSManagedObject {
    @nonobjc
    public class func fetchRequest() -> NSFetchRequest<PostAttributes> {
        NSFetchRequest<PostAttributes>(entityName: "PostAttributes")
    }

    @NSManaged public var uniqueID: Int64
    @NSManaged public var name: String?
    @NSManaged public var url: String?
    @NSManaged public var body: String?
    @NSManaged public var creatorID: Int64
    @NSManaged public var communityID: Int64
    @NSManaged public var publishedAt: String?
    @NSManaged public var comments: NSSet?
    @NSManaged public var post: Post?
}

// MARK: Generated accessors for comments
extension PostAttributes {

    @objc(addCommentsObject:)
    @NSManaged
    public func addToComments(_ value: Comment)

    @objc(removeCommentsObject:)
    @NSManaged
    public func removeFromComments(_ value: Comment)

    @objc(addComments:)
    @NSManaged
    public func addToComments(_ values: NSSet)

    @objc(removeComments:)
    @NSManaged
    public func removeFromComments(_ values: NSSet)

}

// MARK: Identifiable

extension PostAttributes: Identifiable { }
