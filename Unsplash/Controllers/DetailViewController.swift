//
//  DetailViewController.swift
//  Unsplash
//
//  Created by alekseienko on 30.10.2022.
//

import UIKit
import RealmSwift


class DetailViewController: UIViewController {
    
    // MARK: - OUTLETS
    @IBOutlet weak var mainPhoto: UIImageView!
    @IBOutlet weak var avatarPhoto: UIImageView!
    @IBOutlet weak var lblUsername: UILabel!
    @IBOutlet weak var lblLikes: UILabel!
    @IBOutlet weak var lblDate: UILabel!
    @IBOutlet weak var likeButton: UIButton!
    // MARK: - PROPERTIES
    
    private lazy var shareBarButtonItem: UIBarButtonItem = {
        return UIBarButtonItem(image: UIImage(named: "share"), style: .plain, target: self, action: #selector(shareAction))
    }()
    
    
    var photo: UnsplasPhoto?
    var isSave: Bool = false
    var realmDB: Realm!
    var item: PhotoObject = PhotoObject()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        self.title = "Details"
        navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 20, weight: .bold),NSAttributedString.Key.foregroundColor: UIColor.black]
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(customView: backButton())
        shareBarButtonItem.tintColor = .black
        navigationItem.rightBarButtonItem = shareBarButtonItem
        likeButton.backgroundColor = .systemGray6
        likeButton.layer.cornerRadius = 16
        
        setupScreen()
        let singleTap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(showImage))
               singleTap.numberOfTapsRequired = 1
               singleTap.numberOfTouchesRequired = 1
               self.mainPhoto.addGestureRecognizer(singleTap)
               self.mainPhoto.isUserInteractionEnabled = true
        
        realmDB = try! Realm()
    }
    
    
    // MARK: - SAVE/DELETE FUNCTION
    @IBAction func saveDelet(_ sender: Any) {
        
        let photoSave: PhotoObject = PhotoObject()
        guard let photo = photo else { return }
        // SETUP DATA
        photoSave.username = photo.user.username
        photoSave.usernameImage = photo.user.profileImage.small
        photoSave.photoImage = photo.urls.regular
        isSave.toggle()
           if isSave {
               likeButton.setImage(UIImage(named: "red-like"), for: .normal)
               try! self.realmDB.write {
                   self.realmDB.add(photoSave)
               }
               item = photoSave
               print(realmDB.configuration.fileURL!)
               
           } else {
               likeButton.setImage(UIImage(named: "black-like"), for: .normal)
               try! self.realmDB.write {
                   self.realmDB.delete(item)
                      }
           }
    }
    
    // MARK: - SHARE ACTION
    @objc func shareAction(sender: UIBarButtonItem) {
        guard let photo = photo else { return }
        let imgView = UIImageView()
        imgView.downloaded(from: photo.urls.regular)
        let img = imgView.image
        let shareController = UIActivityViewController(activityItems: [img ?? UIImage()], applicationActivities: nil)
        shareController.popoverPresentationController?.barButtonItem = sender
        shareController.popoverPresentationController?.permittedArrowDirections = .any
        present(shareController, animated: true, completion: nil)
    }
    
    // MARK: - SHOW FULL IMAGE
    @objc func showImage(_ sender:UITapGestureRecognizer){
        let vc = PhotoViewController()
        vc.photo = photo
        navigationController?.pushViewController(vc, animated: true)
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
    // MARK: - SETUP UI
    func setupScreen() {
        guard let photo = photo else { return }
        // SETUP MAIN PHOTO
        mainPhoto.downloaded(from: photo.urls.regular ,contentMode: .scaleAspectFill)
        mainPhoto.layer.cornerRadius = 10
        // SETUP AVATAR
        avatarPhoto.downloaded(from: photo.user.profileImage.small)
        avatarPhoto.makeRounded()
        // SETUP USER NAME
        lblUsername.text = photo.user.username.lowercased()
        // SETUP LIKES COUNT
        let largeNumber = photo.likes
        let numberFormatter = NumberFormatter()
        numberFormatter.numberStyle = .decimal
        let number = numberFormatter.string(from: largeNumber as NSNumber)
        lblLikes.text = "\(number!) likes"
        // SETUP DATE PUBLISHED
        let isoDate = photo.createdAt
        let dateFormatter = DateFormatter()
            dateFormatter.locale = Locale(identifier: "en_US_POSIX")
            dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"
        let date = dateFormatter.date(from: isoDate)!
            dateFormatter.dateFormat = "MMM d, yyyy"
        let dateString = dateFormatter.string(from: date)
        lblDate.text =  "Published on \(dateString)"
    }
}


extension UIView {
    func makeRounded() {
        layer.borderWidth = 1
        layer.masksToBounds = false
        layer.borderColor = UIColor.black.cgColor
        layer.cornerRadius = self.frame.height / 2
        clipsToBounds = true
    }
}
