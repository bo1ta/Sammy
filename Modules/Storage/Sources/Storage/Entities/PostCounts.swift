//
//  PostCounts+CoreDataClass.swift
//  Sammy
//
//  Created by Alexandru Solomon on 17.05.2025.
//
//

import CoreData
import Foundation

// MARK: - PostCounts

@objc(PostCounts)
public class PostCounts: NSManagedObject {
    @nonobjc
    public class func fetchRequest() -> NSFetchRequest<PostCounts> {
        NSFetchRequest<PostCounts>(entityName: "PostCounts")
    }

    @NSManaged public var postID: Int64
    @NSManaged public var comments: Int64
    @NSManaged public var score: Int64
    @NSManaged public var upvotes: Int64
    @NSManaged public var downvotes: Int64
    @NSManaged public var publishedAt: String?
    @NSManaged public var newestCommentTime: String?
    @NSManaged public var post: Post?

}

// MARK: Identifiable

extension PostCounts: Identifiable { }
