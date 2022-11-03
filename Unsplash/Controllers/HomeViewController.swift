//
//  HomeViewController.swift
//  Unsplash
//
//  Created by alekseienko on 30.10.2022.
//

import UIKit
import CHTCollectionViewWaterfallLayout

class HomeViewController: UIViewController {

    // MARK: - OUTLETS
    @IBOutlet weak var collectionView: UICollectionView!
    
    // MARK: - PROPERTIES
    private let searchController = UISearchController(searchResultsController: nil)
    private let activityIndicator = UIActivityIndicatorView(style: UIActivityIndicatorView.Style.large)
    private let layout = CHTCollectionViewWaterfallLayout()
    private var timer: Timer?
    var unsplashPhoto = [UnsplasPhoto]()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        setupSearchBar()
        setupColections()
        setupLayout()
        setupActivityIndicator()
       // loadData(text: "random")
    }
    
    // MARK: - FUNCTIONS LOAD DATA
    private func loadData(text: String) {
        timer?.invalidate()
        timer = Timer.scheduledTimer(withTimeInterval: 0.2, repeats: false, block: { [self] _ in
            NetworkManager.shared.getData(searchText: text) { [weak self] (searchResault) in
                guard let fetchedResault = searchResault else { return }
                self?.unsplashPhoto += fetchedResault.results
                DispatchQueue.main.async {
                    self?.collectionView.reloadData()
                }
            }
        })
    }
    // MARK: - ACTIVITI INDICATOR
    func setupActivityIndicator() {
        view.addSubview(activityIndicator)
        activityIndicator.translatesAutoresizingMaskIntoConstraints = false
        activityIndicator.hidesWhenStopped = true
        activityIndicator.color = UIColor.red
        let horizontalConstraint = NSLayoutConstraint(item: activityIndicator, attribute: NSLayoutConstraint.Attribute.centerX, relatedBy: NSLayoutConstraint.Relation.equal, toItem: view, attribute: NSLayoutConstraint.Attribute.centerX, multiplier: 1, constant: 0)
        view.addConstraint(horizontalConstraint)
        let verticalConstraint = NSLayoutConstraint(item: activityIndicator, attribute: NSLayoutConstraint.Attribute.centerY, relatedBy: NSLayoutConstraint.Relation.equal, toItem: view, attribute: NSLayoutConstraint.Attribute.centerY, multiplier: 1, constant: 0)
        view.addConstraint(verticalConstraint)
    }
    
}

// MARK: - SEARCH BAR
extension HomeViewController: UISearchBarDelegate {
    // SETUP
    func setupSearchBar() {
        searchController.searchBar.placeholder = "ПОШУК"
        searchController.searchBar.tintColor = .black
        navigationItem.searchController = searchController
        searchController.searchBar.delegate = self
    }
    // SEARCH BAR FUNCTION
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        activityIndicator.startAnimating()
        
        if searchText == "" {
            print("тут пусто")
        }
        timer?.invalidate()
        timer = Timer.scheduledTimer(withTimeInterval: 0.5, repeats: false, block: { [self] _ in
            NetworkManager.shared.getData(searchText: searchText) { [weak self] (searchResault) in
                guard let fetchedResault = searchResault else { return }
                self?.unsplashPhoto = fetchedResault.results
                DispatchQueue.main.async {
                    self?.activityIndicator.stopAnimating()
                    self?.collectionView?.reloadData()
                }
            }
        })
    }
}

// MARK: - COLLECTION VIEW
extension HomeViewController: UICollectionViewDelegate, UICollectionViewDataSource, CHTCollectionViewDelegateWaterfallLayout {
    // SETUP COLLECTION VIEW
    func setupColections() {
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(UINib(nibName: "HomeCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "HomeCollectionViewCell")
    }
    // SETUP LAYOUT (PINTAREST STYLE)
    func setupLayout() {
        layout.columnCount = 2
        layout.itemRenderDirection = .leftToRight
        layout.minimumColumnSpacing = 20
        layout.minimumInteritemSpacing = 20
        layout.sectionInset = UIEdgeInsets(top: 20, left: 20, bottom: 10, right: 20)
        collectionView.collectionViewLayout = layout
    }
    // SECTIONS COUNT (MIN 1)
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    // ITEM COUNT
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return unsplashPhoto.count
    }
    // SETUP DATA TO ITEM
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "HomeCollectionViewCell", for: indexPath) as! HomeCollectionViewCell
        let photo = unsplashPhoto[indexPath.item]
        cell.backgroundColor = .systemGray6
        cell.img.downloaded(from: photo.urls.thumb,contentMode: .scaleAspectFill)
        return cell
    }
    // ITEM SIZE
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: view.frame.size.width/2, height: CGFloat.random(in: 200...300))
    }
    // SENT DATA TO VC
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let vc = DetailViewController()
        vc.photo = unsplashPhoto[indexPath.item]
        navigationController?.pushViewController(vc, animated: true)
    }
}

// MARK: - DOWLAND IMAGE FROM JSON API
extension UIImageView {
    func downloaded(from url: URL, contentMode mode: ContentMode = .scaleAspectFit) {
        contentMode = mode
        URLSession.shared.dataTask(with: url) { data, response, error in
            guard
                let httpURLResponse = response as? HTTPURLResponse, httpURLResponse.statusCode == 200,
                let mimeType = response?.mimeType, mimeType.hasPrefix("image"),
                let data = data, error == nil,
                let image = UIImage(data: data)
            else { return }
            DispatchQueue.main.async() { [weak self] in
                self?.image = image
            }
        }.resume()
    }
    func downloaded(from link: String, contentMode mode: ContentMode = .scaleAspectFit) {
        guard let url = URL(string: link) else { return }
        downloaded(from: url, contentMode: mode)
    }
}
