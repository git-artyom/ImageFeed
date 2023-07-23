

import UIKit


final class SingleImageViewController: UIViewController {
    
    var image: UIImage! {
        didSet {
            guard isViewLoaded else { return }
            SingleImageView.image = image
        }
    }
    
    @IBOutlet var SingleImageView: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        SingleImageView.image = image
    }
    
}
