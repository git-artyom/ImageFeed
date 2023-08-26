//
//  ProfileImageModel.swift
//  ImageFeed
//
//  Created by Артем Чебатуров on 26.08.2023.
//

import Foundation

// структура для сохранения ответа изображения профиля
struct UserResult: Codable {
    let profileImage: ProfileImage?
    enum CodingKeys: String, CodingKey {
        case profileImage = "profile_image"
    }
}

// unspalsh "profile_image" response
struct ProfileImage: Codable {
    let small: String?
    let medium: String?
    let large: String?
}
