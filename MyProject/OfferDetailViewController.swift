//
//  OfferDetailViewController.swift
//  MyProject
//
//  Created by Emmanuel Bartile on 02/03/2023.
//

import UIKit

class OfferDataSource: NSObject, UICollectionViewDataSource {

    // The list of offers to display
    var offers: [Offer]

    // The collection view to manage
    private weak var collectionView: UICollectionView?

    init(collectionView: UICollectionView, offers: [Offer]) {
        self.collectionView = collectionView
        self.offers = offers
        super.init()
    }

    // MARK: - UICollectionViewDataSource

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return offers.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "OfferCell", for: indexPath) as! OfferCollectionViewCell
        let offer = offers[indexPath.item]
        cell.configure(with: offer)
        cell.delegate = collectionView.delegate as? OfferCollectionViewCellDelegate
        return cell
    }

    // MARK: - Offer updates

    func didUpdateOffer(at index: Int) {
        let indexPath = IndexPath(item: index, section: 0)
        collectionView?.reloadItems(at: [indexPath])
    }

}

class OfferDetailViewController: UIViewController {
    
    // MARK: - Properties
    
    var offer: Offer?
    var dataSource: OfferDataSource?

    private var isFavorite: Bool = false {
        didSet {
            updateFavoriteButton()
            updateOfferState()
        }
    }
    
    // MARK: - Outlets
    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var favoriteButton: UIButton!
    
    // MARK: - View Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Configure UI
        configureUI()
        
        // Load offer data
        loadData()
    }
    
    // MARK: - Actions
    
    @IBAction func toggleFavorite(_ sender: UIButton) {
        isFavorite = !isFavorite
    }
    
    // MARK: - Private Methods
    
    private func configureUI() {
        // Configure fonts and colors
        nameLabel.font = UIFont(name: "AvenirNext-Regular", size: 11)
        nameLabel.textColor = UIColor(named: "DarkGray")
        descriptionLabel.font = UIFont.systemFont(ofSize: 12)
        descriptionLabel.textColor = UIColor(named: "DarkGray")
        favoriteButton.titleLabel?.font = UIFont(name: "AvenirNext-DemiBold", size: 12)
        favoriteButton.setTitleColor(UIColor(named: "DarkGray"), for: .normal)
        favoriteButton.layer.cornerRadius = 5
        favoriteButton.layer.borderWidth = 1
        favoriteButton.layer.borderColor = UIColor(named: "DarkGray")?.cgColor
    }
    
    private func loadData() {
        guard let offer = offer else { return }
        
        // Load offer data
        nameLabel.text = offer.name
        descriptionLabel.text = offer.description
        
        // Load offer image asynchronously
        if let imageUrl = URL(string: offer.url ?? "https://www.slntechnologies.com/wp-content/uploads/2017/08/ef3-placeholder-image.jpg") {
            DispatchQueue.global().async {
                if let data = try? Data(contentsOf: imageUrl) {
                    DispatchQueue.main.async {
                        self.imageView.image = UIImage(data: data)
                    }
                }
            }
        }
        
        // Set favorite state
        isFavorite = offer.isFavorite ?? false
    }
    
    private func updateFavoriteButton() {
        let title = isFavorite ? "Unfavorite" : "Favorite"
        favoriteButton.setTitle(title, for: .normal)
        favoriteButton.backgroundColor = isFavorite ? UIColor(named: "DarkGray") : UIColor.clear
        favoriteButton.setTitleColor(isFavorite ? UIColor.white : UIColor(named: "DarkGray"), for: .normal)
    }
    
    private func updateOfferState() {
        guard let offer = offer else { return }
        
        // Update offer state in data source
        if let index = dataSource?.offers.firstIndex(where: { $0.id == offer.id }) {
            dataSource?.offers[index].isFavorite = isFavorite
            dataSource?.didUpdateOffer(at: index)
        }
    }
}

