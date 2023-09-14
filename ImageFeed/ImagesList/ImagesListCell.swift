
import UIKit


protocol ImagesListCellDelegate: AnyObject {
    func imageListCellDidTapLike(_ cell: ImagesListCell)
}

final class ImagesListCell: UITableViewCell {
    
    private struct Keys {
        static let reuseIdentifier = "ImagesListCell"
        static let placeholderImage = "scribble.variable"
        static let likedImage = "like_button_on"
        static let unlikedImage = "like_button_off"
    }
    
    static let reuseIdentifier = Keys.reuseIdentifier
    private let gradientLayer = CAGradientLayer()
    weak var delegate: ImagesListCellDelegate?
    
    @IBOutlet var cellImage: UIImageView!
    @IBOutlet var likeButton: UIButton!
    @IBOutlet var dateLabel: UILabel!
    
    @IBAction private func likeButtonClicked() {
        delegate?.imageListCellDidTapLike(self)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        addGradient()
        gradientLayer.frame = cellImage.bounds
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        cellImage.kf.cancelDownloadTask()
    }
    
}

// метод отображения градиента
extension ImagesListCell {
    
    func addGradient() {
        gradientLayer.startPoint = CGPoint (x: 0.5, y: 0.0)
        gradientLayer.endPoint = CGPoint (x: 0.5, y: 1.0)
        gradientLayer.colors = [
            UIColor(red: 0/255, green: 0/255, blue: 0/255, alpha: 0).cgColor, UIColor(red: 0/255, green: 0/255, blue: 0/255, alpha: 0.7).cgColor]
        
        gradientLayer.locations = [0.9, 1.0]
        cellImage.layer.addSublayer (gradientLayer)
    }
    
}

extension ImagesListCell {
    func configureCell(using photoStringURL: String, with indexPath: IndexPath, date: Date?) -> Bool {
        dateLabel.text = DateService.shared.stringFromDate(date: date)
        var state = false
        guard let photoURL = URL(string: photoStringURL) else { return state }
        let placeholderImage = UIImage(named: Keys.placeholderImage)
        
        cellImage.kf.indicatorType = .activity
        cellImage.kf.setImage(with: photoURL, placeholder: placeholderImage) { [weak self] result in
            guard let self = self else { return }
            
            switch result {
            case .success(_):
                state = true
            case .failure:
                cellImage.image = placeholderImage
            }
        }
        return state
    }
    
}

extension ImagesListCell {
    func setIsLiked(_ isLiked: Bool) {
        let likedImage = isLiked ? Keys.likedImage : Keys.unlikedImage
        guard let likeImage = UIImage(named: likedImage) else { return }
        likeButton.setImage(likeImage, for: .normal)
    }
    
}
