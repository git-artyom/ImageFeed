//
//  OAuthTokenResponseBody.swift
//  ImageFeed
//
//  Created by Артем Чебатуров on 03.08.2023.
//

import Foundation

// структура для декодинга JSON-ответа от Unsplash
struct OAuthTokenResponseBody: Decodable {
    let accessToken: String
    let tokenType: String
    let scope: String
    let createdAt: Int
    
    // соотносим ответ с нашими константами
    enum CodingKeys: String, CodingKey {
        case accessToken = "access_token"
        case tokenType = "token_type"
        case scope 
        case createdAt = "created_at"
    }
    
}
