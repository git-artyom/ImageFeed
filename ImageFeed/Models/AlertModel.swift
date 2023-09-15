//
//  AlertModel.swift
//  ImageFeed
//
//  Created by Артем Чебатуров on 15.09.2023.
//

import Foundation


// модель для алертов
struct AlertModel {
    let title: String
    let message: String
    let buttonText: String
    let completion: () -> Void
    var secondButtonText: String? = nil
    var secondCompletion: () -> Void = {}
}
