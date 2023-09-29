
import UIKit
import Kingfisher

protocol ProfileViewControllerProtocol: AnyObject {
    var presenter: ProfileViewPresenterProtocol { get set }
    var avatarImageView: UIImageView { get set }
    var nameLabel: UILabel { get set }
    var loginLabel: UILabel { get set }
    var descriptionLabel: UILabel { get set }
    
}

 class ProfileViewController: UIViewController, ProfileViewControllerProtocol {
    
    var nameLabel = UILabel()
    var loginLabel = UILabel()
    var descriptionLabel = UILabel()
    var presenter: ProfileViewPresenterProtocol = {
        return ProfileViewPresenter()
    }()
    private let profileServiсe = ProfileService.shared
    private let OAuthToken = OAuthTokenStorage()
    private var profileImageServiceObserver: NSObjectProtocol?
    private let profileImageService = ProfileImageService.shared
    private var alertPresenter: AlertPresenter?
    
    var avatarImageView : UIImageView = {
        let profileImage = UIImageView(image: UIImage(named: "avatar"))
        return profileImage }()
    
    private let logOutButton: UIButton = {
        let image = UIImage(named: "logout_button") ?? UIImage(systemName: "ipad.and.arrow.forward")!
        let button = UIButton(type: .custom)
        button.setImage(image, for: .normal)
        button.accessibilityIdentifier = "logOutButton"
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        addViews()
        addButtonAction()
        alertPresenter = AlertPresenter(delegate: self)
        presenter.profileViewController = self
        presenter.controllerDidLoad()
        
    }
    
    func logOut() {
        OAuthTokenStorage().token = nil
        WebViewViewController.cleanCookies()
        guard let window = UIApplication.shared.windows.first else {
            print("error in logout")
            assertionFailure("logout error")
            return
        }
        window.rootViewController = SplashViewController()
    }
    
    func showExitAlert() {
        DispatchQueue.main.async {
            let alert = AlertModel(title: "Выход",
                                   message: "Уже уходите?",
                                   buttonText: "Да",
                                   completion: { [weak self] in
                guard let self = self else { return }
                self.logOut()
            },
                                   secondButtonText: "Нет",
                                   secondCompletion: { [weak self] in
                guard let self = self else { return }
                self.dismiss(animated: true)
            })
            self.alertPresenter?.show(in: alert)
        }
    }
    
    private func addButtonAction() {
        if #available(iOS 14.0, *) {
            let logOutAction = UIAction(title: "showAlert") { [weak self] (ACTION) in
                guard let self = self else { return }
                self.showExitAlert()
            }
            logOutButton.addAction(logOutAction, for: .touchUpInside)
        } else {
            logOutButton.addTarget(ProfileViewController.self,
                                   action: #selector(didTapButton),
                                   for: .touchUpInside)
        }
    }
    
}

extension ProfileViewController {
    
    @objc
    func didTapButton() {
        showExitAlert()
    }
    
    private func addViews() {
        
        view.addSubview(avatarImageView)
        avatarImageView.heightAnchor.constraint(equalToConstant: 70).isActive = true
        avatarImageView.widthAnchor.constraint(equalToConstant: 70).isActive = true
        avatarImageView.translatesAutoresizingMaskIntoConstraints = false
        
        avatarImageView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 16).isActive = true
        avatarImageView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 32).isActive = true
        
        nameLabel.text = "Спасибо за ревью! 💕"
        view.addSubview(nameLabel)
        nameLabel.translatesAutoresizingMaskIntoConstraints = false
        
        nameLabel.topAnchor.constraint(equalTo: avatarImageView.bottomAnchor, constant: 8).isActive = true
        nameLabel.leadingAnchor.constraint(equalTo: avatarImageView.leadingAnchor).isActive = true
        nameLabel.font = UIFont.systemFont(ofSize: 23, weight: .semibold)
        nameLabel.textColor = .white
        
        loginLabel.text = "@katerina_nov"
        view.addSubview(loginLabel)
        loginLabel.translatesAutoresizingMaskIntoConstraints = false
        loginLabel.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: 8).isActive = true
        loginLabel.leadingAnchor.constraint(equalTo: nameLabel.leadingAnchor).isActive = true
        loginLabel.font = UIFont.systemFont(ofSize: 13, weight: .regular)
        loginLabel.textColor = UIColor(red: 174/255, green: 175/255, blue: 180/255, alpha: 100)
        
        descriptionLabel.text = "Hello, World!"
        view.addSubview(descriptionLabel)
        descriptionLabel.translatesAutoresizingMaskIntoConstraints = false
        descriptionLabel.topAnchor.constraint(equalTo: loginLabel.bottomAnchor, constant: 8).isActive = true
        descriptionLabel.leadingAnchor.constraint(equalTo: loginLabel.leadingAnchor).isActive = true
        descriptionLabel.font = UIFont.systemFont(ofSize: 13, weight: .regular)
        descriptionLabel.textColor = .white
        
        logOutButton.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(logOutButton)
        logOutButton.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -16).isActive = true
        logOutButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 55).isActive = true
        logOutButton.leadingAnchor.constraint(greaterThanOrEqualTo: avatarImageView.trailingAnchor, constant: 0).isActive = true
    }
    
}

extension ProfileViewController: AlertPresentableDelegate {
    func present(alert: UIAlertController, animated flag: Bool) {
        self.present(alert, animated: flag)
    }
    
}

