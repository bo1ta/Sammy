//
//  CommentCounts+CoreDataClass.swift
//  Sammy
//
//  Created by Alexandru Solomon on 17.05.2025.
//
//

import CoreData
import Foundation

// MARK: - CommentCounts

@objc(CommentCounts)
public class CommentCounts: NSManagedObject {
    @nonobjc
    public class func fetchRequest() -> NSFetchRequest<CommentCounts> {
        NSFetchRequest<CommentCounts>(entityName: "CommentCounts")
    }

    @NSManaged public var commentID: String?
    @NSManaged public var score: Int64
    @NSManaged public var upvotes: Int64
    @NSManaged public var publishedAt: String?
    @NSManaged public var childCount: Int64
    @NSManaged public var comment: Comment?
}

// MARK: Identifiable

extension CommentCounts: Identifiable { }
