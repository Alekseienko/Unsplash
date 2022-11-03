//
//  FavouriteViewController.swift
//  Unsplash
//
//  Created by alekseienko on 30.10.2022.
//

import UIKit
import RealmSwift


class FavouriteViewController: UIViewController {
    
    // MARK: - OUTLETS
    
    @IBOutlet weak var collectionView: UICollectionView!
    // MARK: - PROPERTIES
    let realm = try! Realm()
    var photo: Results<PhotoObject>!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        self.title = "Favourite"
        navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 20, weight: .bold),NSAttributedString.Key.foregroundColor: UIColor.black]
        setupColections()
        photo = realm.objects(PhotoObject.self)
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        collectionView.reloadData()
    }
}

// MARK: - COLLECTION VIEW
extension FavouriteViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func setupColections() {
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(UINib(nibName: "FavouriteCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "FavouriteCollectionViewCell")
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return photo.count
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let flowayout = collectionViewLayout as? UICollectionViewFlowLayout
        let space: CGFloat = (flowayout?.minimumInteritemSpacing ?? 0.0) + (flowayout?.sectionInset.left ?? 0.0) + (flowayout?.sectionInset.right ?? 0.0)
        let size: CGFloat = (collectionView.frame.size.width - space) / 2.0
        return CGSize(width: size, height: size)
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "FavouriteCollectionViewCell", for: indexPath) as! FavouriteCollectionViewCell
        
        cell.backgroundColor = .systemGray6
        cell.mainPhoto.downloaded(from: photo[indexPath.item].photoImage, contentMode: .scaleAspectFill)
        cell.lblUsername.text = photo[indexPath.item].username.capitalized
        cell.avatarImg.downloaded(from: photo[indexPath.item].usernameImage)
        return cell
    }
    
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        let alert = UIAlertController(title: "Видалити фото", message: "Ви дійсно бажаете видалити фото?", preferredStyle: UIAlertController.Style.alert)
        alert.addAction(UIAlertAction(title: "НІ", style: UIAlertAction.Style.destructive, handler: nil))
        alert.addAction(UIAlertAction(title: "ТАК", style: UIAlertAction.Style.default, handler: { action in
            
            let object = self.photo[indexPath.item]
            try! self.realm.write {
                self.realm.delete(object)
                   }
            DispatchQueue.main.async {
                collectionView.reloadData()
            }
           
        }))
        self.present(alert, animated: true, completion: nil)
    }
}
