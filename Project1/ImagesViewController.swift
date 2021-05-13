//
//  ImagesViewController.swift
//  Project1
//
//  Created by Iyin Raphael on 5/12/21.
//

import UIKit

class ImagesViewController: UIViewController {
    
    // MARK: - Outlets
    @IBOutlet weak var spinner: UIActivityIndicatorView!
    @IBOutlet weak var creditLabel: UILabel!
    
    // MARK: - Properties
    var category = " "
    var appID = "KngbmTCozg40MiNcxD9pZv7w3yTog7AEbpAcf06h9jA"
    var imageviews = [UIImageView]()
    var images = [JSON]()
    var imageCounter = 0
        
    override func viewDidLoad() {
        super.viewDidLoad()
        imageviews = view.subviews.compactMap{ $0 as? UIImageView}
        imageviews.forEach { $0.alpha = 0}
        
        creditLabel.layer.cornerRadius = 15
        
        guard let url = URL(string: "https://api.unsplash.com/search/photos?client_id=\(appID)&query=\(category)&per_page=100")
        else  { return }
        DispatchQueue.global(qos: .userInteractive).async {
            self.fetch(url)
        }
    }
    
    // MARK: - Methods
    func fetch(_ url: URL) {
        if let data = try? Data(contentsOf: url) {
            let json = JSON(data)
            images = json["results"].arrayValue
            downloadImage()
        }
    }
    
    func downloadImage() {
        let currentImage = images[imageCounter % images.count]
        let imageName = currentImage["urls"]["full"].stringValue
        let imageCredit = currentImage["user"]["name"].stringValue
        
        imageCounter += 1
        
        guard let imageURL = URL(string: imageName) else { return }
        guard let imageData = try? Data(contentsOf: imageURL) else { return }
        guard let image = UIImage(data: imageData) else { return }
        
        DispatchQueue.main.async {
            self.show(image, credit: imageCredit)
        }
    }
    
    func show(_ image: UIImage, credit: String) {
        spinner.stopAnimating()
        
        let imageViewToUse = imageviews[imageCounter % imageviews.count]
        let otherImageview = imageviews[(imageCounter + 1) % imageviews.count]

        UIView.animate(withDuration: 2.0) {
            imageViewToUse.image = image
            imageViewToUse.alpha = 1
            self.creditLabel.alpha = 0
            
            self.view.sendSubviewToBack(otherImageview)
        }
        completion: { _ in
            self.creditLabel.text = "  \(credit.uppercased())"
            self.creditLabel.alpha = 1
            otherImageview.alpha = 0
            otherImageview.transform = .identity
        }
        UIView.animate(withDuration: 10.0) {
            imageViewToUse.transform = CGAffineTransform(scaleX: 1.1, y: 1.1)
        }
        completion: { _ in
            DispatchQueue.global(qos: .userInteractive).async {
                self.downloadImage()
            }
        }

    }

}
