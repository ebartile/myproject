//
//  ViewController.swift
//  MyProject
//
//  Created by Emmanuel Bartile on 02/03/2023.
//

import UIKit

class OfferViewController: UIViewController {
    
    // MARK: - Properties
    
    let cellId = "OfferCell"
    var offers = [Offer]()
    var favorites = [Int]()
    let collectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())
    
    // MARK: - View Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Load data from offers.json
        if let url = Bundle.main.url(forResource: "offers", withExtension: "json") {
            do {
                let data = try Data(contentsOf: url)
                let decoder = JSONDecoder()
                offers = try decoder.decode([Offer].self, from: data)
            } catch {
                print("Error loading offers data: \(error)")
            }
        } else {
            print("Error: could not find offers.json file.")
        }
        
        // Configure collection view
        collectionView.backgroundColor = .white
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(OfferCollectionViewCell.self, forCellWithReuseIdentifier: cellId)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        
        // Add collection view to view hierarchy
        view.addSubview(collectionView)
        collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 12).isActive = true
        collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -12).isActive = true
        collectionView.topAnchor.constraint(equalTo: view.topAnchor, constant: 24).isActive = true
        collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -24).isActive = true
    }
    
    @objc private func pushViewController() {
        let offerDetailViewController = OfferDetailViewController()
        navigationController?.pushViewController(offerDetailViewController, animated: true)
    }
}

extension OfferViewController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let margin: CGFloat = 12
        let spacing: CGFloat = 8
        let width = (collectionView.frame.width - 2 * margin - spacing) / 2
        
        let ratio: CGFloat = 3 / 2 // Height to width ratio of offer image
        let height = width * ratio
        
        return CGSize(width: width, height: height + 72)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 8
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 24
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
    }
}

// MARK: - UICollectionViewDataSource

extension OfferViewController: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return offers.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath) as! OfferCollectionViewCell
        let offer = offers[indexPath.item]
        let isFavorite = favorites.contains(Int(offer.id) ?? -1)
        offer.isFavorite = isFavorite
        cell.configure(with: offer)
        cell.delegate = self
        return cell
    }
}

// MARK: - OfferCollectionViewCellDelegate

extension OfferViewController: OfferCollectionViewCellDelegate {
    func offerCollectionViewCellDidTapFavoriteButton(_ cell: OfferCollectionViewCell) {
        // pass
    }
        
    func offerCollectionViewCellDidToggleFavorite(_ cell: OfferCollectionViewCell) {
        guard let indexPath = collectionView.indexPath(for: cell) else { return }
        let offer = offers[indexPath.item]
        offer.isFavorite?.toggle()
        collectionView.reloadItems(at: [indexPath])
    }

}
