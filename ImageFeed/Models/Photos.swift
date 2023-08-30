//
//  Photos.swift
//  ImageFeed
//
//  Created by Артем Чебатуров on 30.08.2023.
//

import Foundation


// структура для UI части
struct Photo {
    let id: String
    let size: CGSize
    let createdAt: Date?
    let welcomeDescription: String?
    let thumbImageURL: String
    let largeImageURL: String
    let isLiked: Bool
}
