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

    public func updateEntityFrom(_: Models.PersonDetails) throws -> Self { }
}
