//
//  PhotoViewController.swift
//  Unsplash
//
//  Created by alekseienko on 30.10.2022.
//

import UIKit

class PhotoViewController: UIViewController {
    
    // MARK: - OUTLETS
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var imageView: UIImageView!
    
    // MARK: - PROPERTIES
    var photo: UnsplasPhoto?

    override func viewDidLoad() {
        super.viewDidLoad()
        setuoScrollView()
        self.title = "Full Image"
        navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 20, weight: .bold),NSAttributedString.Key.foregroundColor: UIColor.black]
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(customView: backButton())

        guard let photo = photo else { return }
        // SETUP MAIN PHOTO
        imageView.downloaded(from: photo.urls.full ,contentMode: .scaleAspectFit)
    }


    // CUSTOM BACK BUTTON
    func backButton() -> UIButton {
        let largeConfig = UIImage.SymbolConfiguration(pointSize: 20, weight: .bold, scale: .large)
        let backButtonImage = UIImage(systemName: "arrow.backward", withConfiguration: largeConfig )?.withRenderingMode(.alwaysTemplate)
        let backButton = UIButton(type: .custom)
        backButton.setImage(backButtonImage, for: .normal)
        backButton.tintColor = .black
        backButton.setTitle("  ", for: .normal)
        backButton.addTarget(self, action: #selector(self.backButtonPressed), for: .touchUpInside)
        return backButton
    }
    @objc func backButtonPressed() {
        dismiss(animated: true, completion: nil)
        navigationController?.popViewController(animated: true)
    }
}
// MARK: - SETUP SROLL FUNCTION
extension PhotoViewController: UIScrollViewDelegate {
    
    func setuoScrollView() {
        scrollView.delegate = self
    }
    
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
       return imageView
    }
}
