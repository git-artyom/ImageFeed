//
//  AlertModel.swift
//  ImageFeed
//
//  Created by Артем Чебатуров on 22.08.2023.
//

import Foundation
import UIKit

protocol AlertPresentableDelegate: AnyObject {
    func present(alert: UIAlertController, animated flag: Bool)
}

//класс для вызова алерта
final class AlertPresenter: AlertPresenterProtocol {
    private weak var delegate: AlertPresentableDelegate?
    
    init(delegate: AlertPresentableDelegate?) {
        self.delegate = delegate
    }
    
    func show(in model: AlertModel) {
        let alert = UIAlertController(title: model.title,
                                      message: model.message,
                                      preferredStyle: .alert)
        
        let action = UIAlertAction(title: model.buttonText, style: .default) { _ in
            model.completion()
        }
        alert.addAction(action)
        
        if let secondButtonText = model.secondButtonText {
            let secondAction = UIAlertAction(title: secondButtonText, style: .default) { _ in
                model.secondCompletion()
            }
            alert.addAction(secondAction)
        }
        delegate?.present(alert: alert, animated: true)
    }
    
}
