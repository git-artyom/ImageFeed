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
final class UIBlockingProgressHUD {
    private static var window: UIWindow? {
        return UIApplication.shared.windows.first
    }
    
    static func show() {
        window?.isUserInteractionEnabled = false
        ProgressHUD.show()
    }
    
    static func dismiss() {
        window?.isUserInteractionEnabled = true
        ProgressHUD.dismiss()
    }
    
}
