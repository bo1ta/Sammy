import struct Models.LocalUser

public enum CurrentUserState {
    case authenticated(LocalUser)
    case anonymous
    case unauthenticated
}
