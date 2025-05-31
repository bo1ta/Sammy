import Foundation

public enum LastTimeUpdatedChecker {
    private static func getLastUpdatedKey(forType type: (some Object).Type, withID id: Int? = nil) -> String {
        if let id {
            String(format: "LAST_UPDATE_CHECKER_%@_%@", type.entityName, id)
        } else {
            String(format: "LAST_UPDATE_CHECKER_%@", type.entityName)
        }
    }

    public static func isDataOld(forType type: (some Object).Type, withID id: Int? = nil) -> Bool {
        let key = getLastUpdatedKey(forType: type, withID: id)

        guard let lastUpdated = UserDefaults.standard.object(forKey: key) as? Date else {
            return true /// No date stored means data is old/never fetched
        }

        return Date.now.timeIntervalSince(lastUpdated) > type.expirationDeadline.timeInterval
    }

    public static func storeLastUpdateDate(forType type: (some Object).Type, withID id: Int? = nil) {
        let key = getLastUpdatedKey(forType: type, withID: id)
        UserDefaults.standard.set(Date.now, forKey: key)
    }

    public static func resetLastUpdateDate(forType type: (some Object).Type, withID id: Int? = nil) {
        let key = getLastUpdatedKey(forType: type, withID: id)
        UserDefaults.standard.removeObject(forKey: key)
    }

    public static func checkIfCommentsOldForPostID(_ postID: Int) -> Bool {
        isDataOld(forType: Comment.self, withID: postID)
    }

    public static func storeLastUpdateDateForCommentsOfPostID(_ postID: Int) {
        storeLastUpdateDate(forType: Comment.self, withID: postID)
    }
}
