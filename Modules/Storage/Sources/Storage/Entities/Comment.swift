//
//  Comment+CoreDataClass.swift
//  Sammy
//
//  Created by Alexandru Solomon on 17.05.2025.
//
//

import CoreData
import Foundation

// MARK: - Comment

@objc(Comment)
public class Comment: NSManagedObject {
    @nonobjc
    public class func fetchRequest() -> NSFetchRequest<Comment> {
        NSFetchRequest<Comment>(entityName: "Comment")
    }

    @NSManaged public var commentID: Int64
    @NSManaged public var commentAttributes: CommentAttributes?
    @NSManaged public var creatorAttributes: PersonAttributes?
    @NSManaged public var postAttributes: PostAttributes?
    @NSManaged public var communityAttributes: CommunityAttributes?
    @NSManaged public var commentCounts: CommentCounts?
}

// MARK: Identifiable

extension Comment: Identifiable { }
