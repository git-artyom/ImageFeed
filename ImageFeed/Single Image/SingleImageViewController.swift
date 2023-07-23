

import UIKit


final class SingleImageViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        SingleImageView.image = image
    }
    
    var image: UIImage! {
        didSet {
            guard isViewLoaded else { return }
            SingleImageView.image = image
        }
    }
    
    @IBOutlet private var SingleImageView: UIImageView!
    
    @IBAction func didTapBackButton(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    
    
    
}
