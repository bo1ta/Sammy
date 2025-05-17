//
//  Post+CoreDataClass.swift
//  Sammy
//
//  Created by Alexandru Solomon on 17.05.2025.
//
//

import CoreData
import Foundation

// MARK: - Post

@objc(Post)
public class Post: NSManagedObject {
    @nonobjc
    public class func fetchRequest() -> NSFetchRequest<Post> {
        NSFetchRequest<Post>(entityName: "Post")
    }

    @NSManaged public var postID: Int64
    @NSManaged public var postAttributes: PostAttributes?
    @NSManaged public var creatorAttributes: PersonAttributes?
    @NSManaged public var postCounts: PostCounts?
    @NSManaged public var communityAttributes: CommunityAttributes?
}

// MARK: Identifiable

extension Post: Identifiable { }
