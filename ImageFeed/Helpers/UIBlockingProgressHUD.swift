//
//  UIBlockingProgressHUD.swift
//  ImageFeed
//
//  Created by Артем Чебатуров on 18.08.2023.
//

import Foundation
import UIKit
import ProgressHUD

// устраняем гонку, блокируя UI
//final class UIBlockingProgressHUD {
//    private static var window: UIWindow? {
//        return UIApplication.shared.windows.first
//    }
//
//    static func show() {
//        window?.isUserInteractionEnabled = false
//        ProgressHUD.show()
//    }
//
//    static func dismiss() {
//        window?.isUserInteractionEnabled = true
//        ProgressHUD.dismiss()
//    }
//
//}
//

final class UIBlockingProgressHUD {
    
    static var isShowing: Bool = false
    
    private static var window: UIWindow? {
        guard let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
              let window = windowScene.windows.first
        else {
            return nil
        }
        return window
    }

    static func show() {
        isShowing = true
        window?.isUserInteractionEnabled = false
        ProgressHUD.show()
    }

    static func dismiss() {
        isShowing = false
        window?.isUserInteractionEnabled = true
        ProgressHUD.dismiss()
    }
}
