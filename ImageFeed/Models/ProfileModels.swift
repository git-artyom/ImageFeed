//
//  ProfileModels.swift
//  ImageFeed
//
//  Created by Артем Чебатуров on 23.08.2023.
//

import Foundation


// структура для ответа с пользовательским инфо с unsplash
struct ProfileResult: Codable {
    
    let username: String
    let firstName: String
    let lastName: String
    let bio: String?
    
    enum CodingKeys: String, CodingKey {
        case username = "username"
        case firstName = "first_name"
        case lastName = "last_name"
        case bio = "bio"
    }
    
}

// структура для ui эллементов
struct Profile {
    let username: String
    let name: String
    let bio: String
    var login: String {
        get { "@\(username)" }
    }
    
}
