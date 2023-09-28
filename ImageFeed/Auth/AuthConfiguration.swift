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

let AccessKey = "orbCtm0t7AGUkZsz6MEkUQdLAfGc9gVD-mrAfBMdxVc"
let SecretKey = "w_3cz0xK8Z-qAtSDH9VD7CMmLLvKMyAMj2NRwK6Akcg"
let RedirectURI = "urn:ietf:wg:oauth:2.0:oob"
let AccessScope = "public+read_user+write_likes"

let DefaultBaseURL = URL(string: "https://api.unsplash.com")!
let UnsplashAuthorizeURLString = "https://unsplash.com/oauth/authorize"

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
        return AuthConfiguration(accessKey: AccessKey,
                                 secretKey: SecretKey,
                                 redirectURI: RedirectURI,
                                 accessScope: AccessScope,
                                 authURLString: UnsplashAuthorizeURLString,
                                 defaultBaseURL: DefaultBaseURL)
    }
}
