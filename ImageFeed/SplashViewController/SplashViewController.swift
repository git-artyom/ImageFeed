//
//  SplashViewController.swift
//  ImageFeed
//
//  Created by Артем Чебатуров on 02.08.2023.
//

import Foundation
import UIKit
import ProgressHUD

final class SplashViewController: UIViewController {

   // private let ShowAuthenticationScreenSegueIdentifier = "ShowAuthenticationScreen"
    private let oauth2Service = OAuthService()
    private let oauth2TokenStorage = OAuthTokenStorage()
    private let profileService = ProfileService.shared
    private var alertPresenter: AlertPresenterProtocol?
    private let profileImageService = ProfileImageService.shared
    private var authViewController: AuthViewController?
    private struct Keys {
        static let main = "Main"
        static let authViewControllerID = "AuthViewController"
    }
    
    private let splashScreenImageView: UIImageView = {
        let imageView = UIImageView(image: UIImage(named: "splash_screen_logo"))
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        addView()
        view.backgroundColor = UIColor(red: 26/255, green: 27/255, blue: 34/255, alpha: 100)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        // проверяем авторизовался ли пользователь, если да переходим на экран с картинками
        if let authToken = oauth2TokenStorage.token{
            self.fetchProfile(token: authToken)
//            switchToTabBarController()
        } else {
            switchToAuthViewController()
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
   //     setNeedsStatusBarAppearanceUpdate()
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        .lightContent
    }

    // здесь запрашиваем токен и передаем в функцию запроса пользовательской информации
    private func fetchOAuthToken(_ code: String) {
        oauth2Service.fetchOAuthToken(code) { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let token):
                self.fetchProfile(token: token)
                UIBlockingProgressHUD.dismiss()
            case .failure:
                UIBlockingProgressHUD.dismiss()
                assertionFailure("no access")
                break
            }
        }
    }
    
    // запрашиваем профиль и переходим во флоу после авторизации
    private func fetchProfile(token: String) {
        profileService.fetchProfile(token) { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success (let data):
                profileImageService.fetchProfileImageURL(
                    token: token,
                    username: data.username) { _ in }
                UIBlockingProgressHUD.dismiss()
                self.switchToTabBarController()
            case .failure:
                UIBlockingProgressHUD.dismiss()
                showAlert()
                break
            }
        }
    }
    
    func authViewController(_ vc: AuthViewController, didAuthenticateWithCode code: String) {
        UIBlockingProgressHUD.show()
        dismiss(animated: true) { [weak self] in
            guard let self = self else { return }
            self.fetchOAuthToken(code)
        }
    }
    
    private func switchToTabBarController() {
        guard let window = UIApplication.shared.windows.first else {
            assertionFailure("error in configuration tab bar controller")
            return
        }
        let tapBarController = UIStoryboard(name: "Main", bundle: .main).instantiateViewController(withIdentifier: "TabBarViewController")
        window.rootViewController = tapBarController
    }
    
}
extension SplashViewController: AuthViewControllerDelegate{
    private func switchToAuthViewController() {
        let storyboard = UIStoryboard(name: "Main", bundle: .main)
        authViewController = storyboard.instantiateViewController(withIdentifier: Keys.authViewControllerID) as? AuthViewController
        authViewController?.delegate = self
        guard let authViewController = authViewController else { return }
        
        authViewController.modalPresentationStyle = .fullScreen
        present(authViewController, animated: true)
    }
}

extension SplashViewController {
    private func showAlert(){
        let alert = AlertModel(title: "Что-то пошло не так(",
                               message: "Не удалось войти в систему",
                               buttonText: "Ок",
                               completion: { [weak self] in
            guard let self = self else { return }
            oauth2TokenStorage.token = nil
        })
        alertPresenter = AlertPresenter(viewController: self)
        alertPresenter?.show(in: alert)
    }
    
}

extension SplashViewController {
    private func addView() {
        view.addSubview(splashScreenImageView)
        NSLayoutConstraint.activate([
            splashScreenImageView.heightAnchor.constraint(equalToConstant: 76),
            splashScreenImageView.widthAnchor.constraint(equalToConstant: 74),
            splashScreenImageView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            splashScreenImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        ])
    }
 
}

