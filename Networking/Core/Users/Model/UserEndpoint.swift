import Foundation

enum UserEndpoint {
    case list
    case byID(Int)
    case emailAvailability

    var path: String {
        switch self {
        case .list:
            return "users"
        case .byID(let id):
            return "users/\(id)"
        case .emailAvailability:
            return "users/is-available"
        }
    }
}
