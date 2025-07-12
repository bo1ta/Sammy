import CoreData
import Foundation
import Models
import Principle

// MARK: - PersonDetailsEntity

@objc(PersonDetailsEntity)
public class PersonDetailsEntity: NSManagedObject {
  @nonobjc
  public class func fetchRequest() -> NSFetchRequest<PersonDetailsEntity> {
    NSFetchRequest<PersonDetailsEntity>(entityName: "PersonDetailsEntity")
  }

  @NSManaged public var personID: Int
  @NSManaged public var comments: Set<CommentEntity>
  @NSManaged public var posts: Set<PostEntity>
  @NSManaged public var moderates: Set<PersonModeratesEntity>
  @NSManaged public var personProfile: PersonProfileEntity
  @NSManaged public var siteAttributes: SiteAttributesEntity
}

// MARK: Generated accessors for comments
extension PersonDetailsEntity {

  @objc(addCommentsObject:)
  @NSManaged
  public func addToComments(_ value: CommentEntity)

  @objc(removeCommentsObject:)
  @NSManaged
  public func removeFromComments(_ value: CommentEntity)

  @objc(addComments:)
  @NSManaged
  public func addToComments(_ values: Set<CommentEntity>)

  @objc(removeComments:)
  @NSManaged
  public func removeFromComments(_ values: Set<CommentEntity>)

}

// MARK: Generated accessors for posts
extension PersonDetailsEntity {

  @objc(addPostsObject:)
  @NSManaged
  public func addToPosts(_ value: PostEntity)

  @objc(removePostsObject:)
  @NSManaged
  public func removeFromPosts(_ value: PostEntity)

  @objc(addPosts:)
  @NSManaged
  public func addToPosts(_ values: Set<PostEntity>)

  @objc(removePosts:)
  @NSManaged
  public func removeFromPosts(_ values: Set<PostEntity>)

}

// MARK: Generated accessors for moderates
extension PersonDetailsEntity {

  @objc(addModeratesObject:)
  @NSManaged
  public func addToModerates(_ value: PersonModeratesEntity)

  @objc(removeModeratesObject:)
  @NSManaged
  public func removeFromModerates(_ value: PersonModeratesEntity)

  @objc(addModerates:)
  @NSManaged
  public func addToModerates(_ values: Set<PersonModeratesEntity>)

  @objc(removeModerates:)
  @NSManaged
  public func removeFromModerates(_ values: Set<PersonModeratesEntity>)

}

// MARK: ReadOnlyConvertible

extension PersonDetailsEntity: ReadOnlyConvertible {
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

extension PersonDetailsEntity: SyncableEntity {
  public static func predicateForModel(_ model: Models.PersonDetails) -> NSPredicate {
    \PersonDetailsEntity.personID == model.personProfile.person.id
  }

  public func updateEntityFrom(_ model: Models.PersonDetails, on storage: StorageType) throws {
    _ = try personProfile.updateEntityFrom(model.personProfile, on: storage)
    _ = try siteAttributes.updateEntityFrom(model.siteAttributes, on: storage)

    try storage.updateToManyRelationship(
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

    try storage.updateToManyRelationship(
      models: model.posts,
      currentEntities: posts,
      compare: { model, entity in
        model.attributes.id == entity.postAttributes.uniqueID
      },
      add: { [weak self] posts in
        self?.addToPosts(posts)
      },
      remove: { [weak self] posts in
        self?.removeFromPosts(posts)
      })

    try storage.updateToManyRelationship(
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
  }

  public func populateEntityFrom(_ model: PersonDetails, on storage: any StorageType) throws {
    self.personID = model.personProfile.person.id
    self.personProfile = try storage.findOrInsert(of: PersonProfileEntity.self, usingDTO: model.personProfile)
    self.siteAttributes = try storage.findOrInsert(of: SiteAttributesEntity.self, usingDTO: model.siteAttributes)

    for comment in model.comments {
      let commentEntity = try storage.findOrInsert(of: CommentEntity.self, usingDTO: comment)
      self.comments.insert(commentEntity)
    }

    for post in model.posts {
      let postEntity = try storage.findOrInsert(of: PostEntity.self, usingDTO: post)
      self.posts.insert(postEntity)
    }

    for moderate in model.moderates {
      let moderatesEntity = try storage.findOrInsert(of: PersonModeratesEntity.self, usingDTO: moderate)
      self.moderates.insert(moderatesEntity)
    }
  }
}
