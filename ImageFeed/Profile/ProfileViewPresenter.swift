//
//  ProfileViewPresenter.swift
//  ImageFeed
//
//  Created by Артем Чебатуров on 28.09.2023.
//

import Foundation
import Kingfisher
import UIKit

protocol ProfileViewPresenterProtocol {
    var profileService: ProfileService { get }
    var profileViewController: ProfileViewControllerProtocol? { get set }
    func controllerDidLoad()
    func updateProfileDetails(profile: Profile?)

}

final class ProfileViewPresenter: ProfileViewPresenterProtocol {

    var profileViewController: ProfileViewControllerProtocol?
    var profileImageService = ProfileImageService.shared
    var profileService = ProfileService.shared
    private var profileImageServiceObserver: NSObjectProtocol?

    func controllerDidLoad() {
        updateProfileDetails(profile: profileService.profile)
    }

    func updateProfileDetails(profile: Profile?) {
        guard let profile = profile else { print("error in update profile details"); return }
        profileViewController?.nameLabel.text = profile.name
        profileViewController?.loginLabel.text = profile.login
        profileViewController?.descriptionLabel.text = profile.bio

        profileImageServiceObserver = NotificationCenter.default.addObserver(
            forName: ProfileImageService.DidChangeNotification,
            object: nil,
            queue: .main) { [weak self] _ in guard let self = self else { return }
                self.updateProfileImage()
            }
        self.updateProfileImage()

    }

    func updateProfileImage() {
        guard let avatarUrl = profileImageService.avatarURL, let url = URL(string: avatarUrl) else { print("error in update profile image"); return }

        let processor = RoundCornerImageProcessor (cornerRadius: 100)
                let cache = ImageCache.default
                cache.clearMemoryCache()
                cache.clearDiskCache()
        profileViewController?.avatarImageView.kf.indicatorType = .activity
        profileViewController?.avatarImageView.kf.setImage(
            with: url,
            placeholder: UIImage(named: "placeholder.jpeg"),
            options: [.processor(processor)] )
    }

    //    func updateProfileImage() {
    //        guard let avatarUrl = profileImageService.avatarURL, let url = URL(string: avatarUrl) else { print("error in update profile image"); return }
    //        let cache = ImageCache.default
    //        cache.clearMemoryCache()
    //        cache.clearDiskCache()
    //        let processor = RoundCornerImageProcessor (cornerRadius: 100)
    //
    //        avatarImageView.kf.indicatorType = .activity
    //        avatarImageView.kf.setImage(
    //            with: url,
    //            placeholder: UIImage(named: "placeholder.jpeg"),
    //            options: [.processor(processor)] )
    //    }
}


