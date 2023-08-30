//
//  AuthViewControllerDelegate.swift
//  ImageFeed
//
//  Created by Артем Чебатуров on 24.08.2023.
//

import Foundation

protocol AuthViewControllerDelegate: AnyObject {
    func authViewController(_ vc: AuthViewController, didAuthenticateWithCode code: String)
}
