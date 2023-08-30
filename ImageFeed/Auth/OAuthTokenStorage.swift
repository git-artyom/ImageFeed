
import Foundation
import SwiftKeychainWrapper

final class OAuthTokenStorage {
    
    private enum Keys: String {
            case token
        }
    
    private let userDefaults = UserDefaults.standard
    
    // раньше сохраняли и читали значение в юзер дефолтс по ключу token
    // теперь используем keyChainWrapper
    var token: String? {
        get {
            KeychainWrapper.standard.string(forKey: Keys.token.rawValue)
        }
        set {
            guard let newValue = newValue else {
                KeychainWrapper.standard.removeObject(forKey: Keys.token.rawValue)
                return
            }
            let isSuccess = KeychainWrapper.standard.set(newValue, forKey: Keys.token.rawValue)
            guard isSuccess else {
                return
            }
        }
    }

}
