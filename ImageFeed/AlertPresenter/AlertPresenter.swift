//
//  AlertModel.swift
//  ImageFeed
//
//  Created by Артем Чебатуров on 22.08.2023.
//

import Foundation
import UIKit


//класс для вызова алерта
class AlertPresenter: AlertPresenterProtocol {
    
    private weak var viewController: UIViewController?
    
    func show(in model: AlertModel) {
        let alert = UIAlertController(title: model.title,
                                      message: model.message,
                                      preferredStyle: .alert)
        
        alert.view.accessibilityIdentifier = "Game results"
        
        let action = UIAlertAction(title: model.buttonText, style: .default) { _ in
            model.completion()
        }
        alert.addAction(action)
        viewController?.present(alert, animated: true, completion: nil)
    }
    
    init(viewController: UIViewController? ) {
        self.viewController = viewController
    }
}

// модель для алертов
struct AlertModel {
    let title: String
    let message: String
    let buttonText: String
    let completion: () -> Void
}
