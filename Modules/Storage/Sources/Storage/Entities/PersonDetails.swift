import CoreData
import Foundation
import Models
import Principle

// MARK: - PersonDetails

@objc(PersonDetails)
public class PersonDetails: NSManagedObject {
    @nonobjc
    public class func fetchRequest() -> NSFetchRequest<PersonDetails> {
        NSFetchRequest<PersonDetails>(entityName: "PersonDetails")
    }

    @NSManaged public var personID: Int
    @NSManaged public var comments: Set<Comment>
    @NSManaged public var posts: Set<Post>
    @NSManaged public var moderates: Set<PersonModerates>
    @NSManaged public var personProfile: PersonProfile
    @NSManaged public var siteAttributes: SiteAttributes
}

// MARK: Generated accessors for comments
extension PersonDetails {

    @objc(addCommentsObject:)
    @NSManaged
    public func addToComments(_ value: Comment)

    @objc(removeCommentsObject:)
    @NSManaged
    public func removeFromComments(_ value: Comment)

    @objc(addComments:)
    @NSManaged
    public func addToComments(_ values: Set<Comment>)

    @objc(removeComments:)
    @NSManaged
    public func removeFromComments(_ values: Set<Comment>)

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
    public func addToPosts(_ values: Set<Post>)

    @objc(removePosts:)
    @NSManaged
    public func removeFromPosts(_ values: Set<Post>)

}

// MARK: Generated accessors for moderates
extension PersonDetails {

    @objc(addModeratesObject:)
    @NSManaged
    public func addToModerates(_ value: PersonModerates)

    @objc(removeModeratesObject:)
    @NSManaged
    public func removeFromModerates(_ value: PersonModerates)

    @objc(addModerates:)
    @NSManaged
    public func addToModerates(_ values: Set<PersonModerates>)

    @objc(removeModerates:)
    @NSManaged
    public func removeFromModerates(_ values: Set<PersonModerates>)

}

// MARK: ReadOnlyConvertible

extension PersonDetails: ReadOnlyConvertible {
    public func toReadOnly() -> Models.PersonDetails {
        Models.PersonDetails(
            personProfile: personProfile.toReadOnly(),
            siteAttributes: siteAttributes.toReadOnly(),
            comments: comments.map { $0.toReadOnly() },
            posts: posts.map { $0.toReadOnly() },
            moderates: moderates.map { $0.toReadOnly() })
    }
}

// MARK: SyncableEntity

extension PersonDetails: SyncableEntity {
    public static func predicateForModel(_ model: Models.PersonDetails) -> NSPredicate {
        \PersonDetails.personID == model.personProfile.person.id
    }

    public func updateEntityFrom(_ model: Models.PersonDetails) throws -> Self {
        _ = try personProfile.updateEntityFrom(model.personProfile)
        _ = try siteAttributes.updateEntityFrom(model.siteAttributes)

        try updateToManyRelationship(
            models: model.comments,
            currentEntities: comments,
            compare: { model, entity in
                model.commentAttributes.id == entity.commentID
            },
            add: { [weak self] comments in
                self?.addToComments(comments)
            },
            remove: { [weak self] comments in
                self?.removeFromComments(comments)
            })

        try updateToManyRelationship(
            models: model.posts,
            currentEntities: posts,
            compare: { model, entity in
                model.postData.id == entity.postID
            },
            add: { [weak self] posts in
                self?.addToPosts(posts)
            },
            remove: { [weak self] posts in
                self?.removeFromPosts(posts)
            })

        try updateToManyRelationship(
            models: model.moderates,
            currentEntities: moderates,
            compare: { model, entity in
                model.moderator.id == entity.personID
            },
            add: { [weak self] moderates in
                self?.addToModerates(moderates)
            },
            remove: { [weak self] moderates in
                self?.removeFromModerates(moderates)
            })

        return self
    }
}

// MARK: - Models.PersonDetails + Storable

extension Models.PersonDetails: Storable {
    public func toEntity(in context: NSManagedObjectContext) throws -> PersonDetails {
        let entity = PersonDetails(context: context)
        entity.personID = personProfile.person.id
        entity.personProfile = try PersonProfile.findOrInsert(model: personProfile, on: context)
        entity.siteAttributes = try SiteAttributes.findOrInsert(model: siteAttributes, on: context)

        for comment in self.comments {
            let commentEntity = try Comment.findOrInsert(model: comment, on: context)
            entity.comments.insert(commentEntity)
        }

        for post in self.posts {
            let postEntity = try Post.findOrInsert(model: post, on: context)
            entity.posts.insert(postEntity)
        }

        for moderate in self.moderates {
            let moderatesEntity = try PersonModerates.findOrInsert(model: moderate, on: context)
            entity.moderates.insert(moderatesEntity)
        }

        return entity
    }
}
