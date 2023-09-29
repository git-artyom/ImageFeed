//
//  Constants.swift
//  ImageFeed
//
//  Created by Артем Чебатуров on 02.08.2023.
//


//let accessKey = "orbCtm0t7AGUkZsz6MEkUQdLAfGc9gVD-mrAfBMdxVc"
//let secretKey = "w_3cz0xK8Z-qAtSDH9VD7CMmLLvKMyAMj2NRwK6Akcg"
//let redirectURI = "urn:ietf:wg:oauth:2.0:oob"
//let accessScope = "public+read_user+write_likes"
//let defaultBaseURL = URL(string: "https://api.unsplash.com")!

import Foundation

struct Constants {
    static let AccessKey = "orbCtm0t7AGUkZsz6MEkUQdLAfGc9gVD-mrAfBMdxVc"
    static let SecretKey = "w_3cz0xK8Z-qAtSDH9VD7CMmLLvKMyAMj2NRwK6Akcg"
    static let RedirectURI = "urn:ietf:wg:oauth:2.0:oob"
    static let AccessScope = "public+read_user+write_likes"
    
    static let DefaultBaseURL = URL(string: "https://api.unsplash.com")!
    static let UnsplashAuthorizeURLString = "https://unsplash.com/oauth/authorize"
}

struct AuthConfiguration {
    let accessKey: String
    let secretKey: String
    let redirectURI: String
    let accessScope: String
    let defaultBaseURL: URL
    let authURLString: String
    
    init(accessKey: String, secretKey: String, redirectURI: String, accessScope: String, authURLString: String, defaultBaseURL: URL) {
        self.accessKey = accessKey
        self.secretKey = secretKey
        self.redirectURI = redirectURI
        self.accessScope = accessScope
        self.defaultBaseURL = defaultBaseURL
        self.authURLString = authURLString
    }
    
    static var standard: AuthConfiguration {
        return AuthConfiguration(accessKey: Constants.AccessKey,
                                 secretKey: Constants.SecretKey,
                                 redirectURI: Constants.RedirectURI,
                                 accessScope: Constants.AccessScope,
                                 authURLString: Constants.UnsplashAuthorizeURLString,
                                 defaultBaseURL: Constants.DefaultBaseURL)
    }
}
