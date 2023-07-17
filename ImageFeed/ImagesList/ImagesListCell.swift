

import UIKit


final class ImagesListCell: UITableViewCell {
    
    static let reuseIdentifier = "ImagesListCell"
    
    @IBOutlet var cellImage: UIImageView!
    @IBOutlet var likeButton: UIButton!
    @IBOutlet var dateLabel: UILabel!
    
    var gradientLayer: CAGradientLayer?
    
    override func layoutSublayers(of layer: CALayer) {
        super.layoutSublayers(of: self.layer)
        
        if gradientLayer == nil {
            gradientLayer = CAGradientLayer()
            guard let gradientLayer = gradientLayer else { return }
            gradientLayer.frame = self.bounds
            
            let colorSet = [UIColor(red: 255/255, green: 255/255, blue: 255/255, alpha: 0.01),
                            UIColor(red: 0/255, green: 0/255, blue: 0/255, alpha: 0.8)]
            let location = [0.2, 1.0]
            
            addGradient(with: gradientLayer, colorSet: colorSet, locations: location)
        }
    }
}


extension ImagesListCell {
    
    func addGradient(with layer: CAGradientLayer, gradientFrame: CGRect? = nil, colorSet: [UIColor],
                     locations: [Double], startEndPoints: (CGPoint, CGPoint)? = nil) {
        layer.frame = gradientFrame ?? self.bounds
        layer.frame.origin = .zero
        
        let layerColorSet = colorSet.map { $0.cgColor }
        let layerLocations = locations.map { $0 as NSNumber }
        
        layer.colors = layerColorSet
        layer.locations = layerLocations
        
        if let startEndPoints = startEndPoints {
            layer.startPoint = startEndPoints.0
            layer.endPoint = startEndPoints.1
        }
        
        cellImage.layer.insertSublayer(layer, above: self.layer)
    }
}
