

import UIKit


final class SingleImageViewController: UIViewController {
    
    @IBOutlet private var backButton: UIButton!
    @IBOutlet private var SingleImageView: UIImageView!
    @IBOutlet private var shareButton: UIButton!
    @IBOutlet private var scrollView: UIScrollView!
    
    @IBAction func didTapBackButton(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func didTapShareButton(_ sender: UIButton) {
        //        present(activityController, animated: true, completion: nil)
        
        let share = UIActivityViewController(
            activityItems: [image as Any],
            applicationActivities: nil
        )
        present(share, animated: true, completion: nil)
    }
    
    var largeImageURL: URL?
    private var activityController = UIActivityViewController(activityItems: [], applicationActivities: nil)
    private var alertPresenter: AlertPresenter?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //      SingleImageView.image = image
        alertPresenter = AlertPresenter(delegate: self)
        
        scrollView.minimumZoomScale = 0.1
        scrollView.maximumZoomScale = 1.25
        //        rescaleAndCenterImageInScrollView(image: image)
        UIBlockingProgressHUD.show()
        downloadImage()
    }
    
    // дополнительный метод позиционирования вью показанный наставником на семинаре
    override func viewDidLayoutSubviews () {
        super.viewDidLayoutSubviews ()
        if let image = SingleImageView.image {
            rescaleAndCenterImageInScrollView(image: image)
            //  anotherRescaleAndCenterImageInScrollView()
        }
    }
    
    // дополнительно проверяем создание вью
    var image: UIImage! {
        didSet {
            guard isViewLoaded else { return }
            SingleImageView.image = image
            rescaleAndCenterImageInScrollView(image: image)
        }
    }
    
}

extension SingleImageViewController: UIScrollViewDelegate {
    
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        SingleImageView
    }
    
    func scrollViewDidEndZooming(_ scrollView: UIScrollView, with view: UIView?, atScale scale: CGFloat) {
        UIView.animate(withDuration: 0.1) {
            self.anotherRescaleAndCenterImageInScrollView ()
        }
    }
    
    private func rescaleAndCenterImageInScrollView(image: UIImage) {
        let minZoomScale = scrollView.minimumZoomScale
        let maxZoomScale = scrollView.maximumZoomScale
        view.layoutIfNeeded()
        let visibleRectSize = scrollView.bounds.size
        let imageSize = image.size
        let hScale = visibleRectSize.width / imageSize.width
        let vScale = visibleRectSize.height / imageSize.height
        let scale = min(maxZoomScale, max(minZoomScale, max(hScale, vScale)))
        scrollView.setZoomScale(scale, animated: false)
        scrollView.layoutIfNeeded()
        let newContentSize = scrollView.contentSize
        let x = (newContentSize.width - visibleRectSize.width) / 2
        let y = (newContentSize.height - visibleRectSize.height) / 2
        scrollView.setContentOffset(CGPoint(x: x, y: y), animated: false)
    }
    
}

// дополнительный метод позиционирования вью показанный наставником на семинаре
private extension SingleImageViewController {
    func anotherRescaleAndCenterImageInScrollView() {
        
        let halfWidth = (scrollView.bounds.size.width - SingleImageView.frame.size.width) / 2
        let halfHeight = (scrollView.bounds.size.height - SingleImageView.frame.size.height) / 2
        scrollView.contentInset = .init(top: halfHeight, left: halfWidth, bottom: 0, right: 0)
        
    }
}

extension SingleImageViewController {
    
    func downloadImage() {
        SingleImageView.kf.setImage(with: largeImageURL) { [weak self] result in
            UIBlockingProgressHUD.dismiss()
            guard let self = self else { return }
            
            switch result {
            case .success(let imageResult):
                self.rescaleAndCenterImageInScrollView(image: imageResult.image)
                activityController = UIActivityViewController(
                    activityItems: [imageResult.image as Any],
                    applicationActivities: nil
                )
            case .failure:
                self.showError()
                return
            }
        }
    }
    
}

extension SingleImageViewController {
    //    func showError() {
    //        let alert = AlertModel(title: "Ошибка",
    //                               message: "Попробовать снова?",
    //                               buttonText: "Повторить",
    //                               completion: { [weak self] in
    //            guard let self = self else { return }
    //            UIBlockingProgressHUD.show()
    //            downloadImage()
    //        })
    //
    //        alertPresenter?.show(in: alert)
    //    }
    func showError() {
        let alert = AlertModel(title: "Ошибка",
                               message: "Попробовать ещё раз?",
                               buttonText: "Да",
                               completion: { [weak self] in
            guard let self = self else { return }
            UIBlockingProgressHUD.show()
            downloadImage()
        },
                               secondButtonText: "Нет",
                               secondCompletion: { [weak self] in
            guard let self = self else { return }
            self.dismiss(animated: true)
        })
        alertPresenter?.show(in: alert)
    }
    
}

extension SingleImageViewController: AlertPresentableDelegate {
    func present(alert: UIAlertController, animated flag: Bool) {
        self.present(alert, animated: flag)
    }
    
}


