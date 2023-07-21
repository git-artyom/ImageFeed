
import UIKit


final class ImagesListCell: UITableViewCell {
    
    static let reuseIdentifier = "ImagesListCell"
    private let gradientLayer = CAGradientLayer()
    
    
    @IBOutlet var cellImage: UIImageView!
    @IBOutlet var likeButton: UIButton!
    @IBOutlet var dateLabel: UILabel!
    
    
    override func layoutSubviews() {
        super.layoutSubviews()
        addGradient()
        gradientLayer.frame = cellImage.bounds
    }
    
    
}


extension ImagesListCell {
    
    func addGradient() {
        
        gradientLayer.startPoint = CGPoint (x: 0.5, y: 0.0)
        gradientLayer.endPoint = CGPoint (x: 0.5, y: 1.0)
        gradientLayer.colors = [
            UIColor(red: 0/255, green: 0/255, blue: 0/255, alpha: 0).cgColor, UIColor(red: 0/255, green: 0/255, blue: 0/255, alpha: 0.7).cgColor
        ]
        
        gradientLayer.locations = [0.9, 1.0]
        cellImage.layer.addSublayer (gradientLayer)
    }
    
}
