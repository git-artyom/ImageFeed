//
//  AlertPresenterProtocol.swift
//  ImageFeed
//
//  Created by Артем Чебатуров on 22.08.2023.
//

import Foundation
import UIKit


protocol AlertPresenterProtocol: AnyObject {
    func show(in model: AlertModel)
}
