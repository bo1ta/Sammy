//
//  CommentAttributes+CoreDataClass.swift
//  Sammy
//
//  Created by Alexandru Solomon on 17.05.2025.
//
//

import CoreData
import Foundation

// MARK: - CommentAttributes

@objc(CommentAttributes)
public class CommentAttributes: NSManagedObject {
    @nonobjc
    public class func fetchRequest() -> NSFetchRequest<CommentAttributes> {
        NSFetchRequest<CommentAttributes>(entityName: "CommentAttributes")
    }

    @NSManaged public var uniqueID: Int64
    @NSManaged public var creatorID: Int64
    @NSManaged public var postID: Int64
    @NSManaged public var content: String?
    @NSManaged public var isRemoved: Bool
    @NSManaged public var publishedAt: String?
    @NSManaged public var updatedAt: String?
    @NSManaged public var isCommentDeleted: Bool
    @NSManaged public var isLocal: Bool
    @NSManaged public var commentPath: String?
    @NSManaged public var isDistinguished: Bool
    @NSManaged public var languageID: Int64
    @NSManaged public var comment: Comment?
}

// MARK: Identifiable

extension CommentAttributes: Identifiable { }
