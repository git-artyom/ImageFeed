
import UIKit
import Kingfisher

final class ProfileViewController: UIViewController {
    
    private let nameLabel = UILabel()
    private let loginLabel = UILabel()
    private let descriptionLabel = UILabel()
    private let profileServiсe = ProfileService.shared
    private let OAuthToken = OAuthTokenStorage()
    private var profileImageServiceObserver: NSObjectProtocol?
    private let profileImageService = ProfileImageService.shared
    private let avatarImageView : UIImageView = {
    let profileImage = UIImageView(image: UIImage(named: "avatar"))
                            return profileImage }()
    
    let logoutButton = UIButton.systemButton(
        with: UIImage(named: "logout_button")!,
        target: ProfileViewController.self,
        action: #selector(Self.didTapButton)
    )
    
    override func viewDidLoad() {
        super.viewDidLoad()
        addViews()
        updateProfileImage()
        updateProfileDetails(profile: profileServiсe.profile)
        
    }
    
    @objc
    private func didTapButton(){
        
    }
    
}

extension ProfileViewController {
    
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
        
        logoutButton.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(logoutButton)
        logoutButton.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -16).isActive = true
        logoutButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 55).isActive = true
        logoutButton.leadingAnchor.constraint(greaterThanOrEqualTo: avatarImageView.trailingAnchor, constant: 0).isActive = true
        
    }
}
// блок методов обновления информации о пользователе и аватаре
extension ProfileViewController {
    
    func updateProfileDetails(profile: Profile?) {

        guard let profile = profile else { print("error1"); return }
        nameLabel.text = profile.name
        loginLabel.text = profile.login
        descriptionLabel.text = profile.bio

        profileImageServiceObserver = NotificationCenter.default.addObserver(
            forName: ProfileImageService.DidChangeNotification,
            object: nil,
            queue: .main) { [weak self] _ in guard let self = self else { return }
            self.updateProfileImage()
        }
        updateProfileImage()
    }
    
    private func updateProfileImage() {
        guard let avatarUrl = profileImageService.avatarURL, let url = URL(string: avatarUrl) else { print("error2"); return }
        let cache = ImageCache.default
        cache.clearMemoryCache()
        cache.clearDiskCache()
        let processor = RoundCornerImageProcessor (cornerRadius: 100)
        
        avatarImageView.kf.indicatorType = .activity
        avatarImageView.kf.setImage(
            with: url,
            placeholder: UIImage(named: "placeholder.jpeg"),
            options: [.processor(processor)] )
    }
    
}
