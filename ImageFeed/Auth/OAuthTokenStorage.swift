
import Foundation


final class OAuthTokenStorage {
    
    private enum Keys: String {
            case token
        }
    
    private let userDefaults = UserDefaults.standard
    
    // сохраняем и читаем значение в юзер дефолтс по ключу token
    var token: String? {
        get {
            userDefaults.string(forKey: Keys.token.rawValue)
        }
        set {
            userDefaults.set(newValue, forKey: Keys.token.rawValue)
        }
    }

    
}
