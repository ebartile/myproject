//
//  OfferCollectionViewCell.swift
//  MyProject
//
//  Created by Emmanuel Bartile on 02/03/2023.
//

import UIKit

class Offer: Codable {
    var id: String
    var url: String?
    var name: String
    var description: String
    var terms: String
    var current_value: String
    var isFavorite: Bool?
    
    init(id: String, url: String, name: String, description: String, terms: String, current_value: String, isFavorite: Bool = false) {
        self.id = id
        self.url = url
        self.name = name
        self.description = description
        self.terms = terms
        self.current_value = current_value
        self.isFavorite = isFavorite
    }
}

class OfferCollectionViewCell: UICollectionViewCell {
    
    // MARK: - Properties
    
    static let reuseIdentifier = "OfferCollectionViewCell"
    
    private let imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.backgroundColor = UIColor(hexString: "#f3f5f6")
        imageView.layer.cornerRadius = 5
        imageView.layer.masksToBounds = true
        return imageView
    }()
    
    private let nameLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: "AvenirNext-Regular", size: 11)
        label.textColor = UIColor(hexString: "#4A4A4A")
        label.numberOfLines = 0
        return label
    }()
    
    private let descriptionLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 10)
        label.textColor = UIColor(hexString: "#4A4A4A")
        label.numberOfLines = 3
        label.textAlignment = .left
        return label
    }()
    
    private let amountLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: "AvenirNext-DemiBold", size: 12)
        label.textColor = UIColor(hexString: "#4A4A4A")
        label.textAlignment = .left
        return label
    }()
    
    private let favoriteButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(systemName: "heart"), for: .normal)
        button.tintColor = .lightGray
        return button
    }()
        
    var offer: Offer? {
        didSet {
            if let offer = offer {
                descriptionLabel.text = offer.description
                amountLabel.text = offer.current_value
                favoriteButton.tintColor = offer.isFavorite ?? false ? .red : .gray
                
                // Load image asynchronously
                let url = URL(string: offer.url ?? "https://www.slntechnologies.com/wp-content/uploads/2017/08/ef3-placeholder-image.jpg")!
                DispatchQueue.global(qos: .userInteractive).async {
                    let data = try? Data(contentsOf: url)
                    DispatchQueue.main.async {
                        self.imageView.image = UIImage(data: data!)
                    }
                }
            }
        }
    }
    
    // MARK: - Public Methods

    func configure(with offer: Offer) {
        descriptionLabel.text = offer.description
        amountLabel.text = offer.current_value
        // Load image asynchronously
        let url = URL(string: offer.url ?? "https://www.slntechnologies.com/wp-content/uploads/2017/08/ef3-placeholder-image.jpg")!
        DispatchQueue.global(qos: .userInteractive).async {
            let data = try? Data(contentsOf: url)
            DispatchQueue.main.async {
                self.imageView.image = UIImage(data: data!)
            }
        }
        favoriteButton.isSelected = offer.isFavorite ?? false
    }
    
    // MARK: - Init
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        contentView.backgroundColor = .white
        contentView.layer.cornerRadius = 5
        
        contentView.addSubview(imageView)
        contentView.addSubview(favoriteButton)
        contentView.addSubview(amountLabel)
        contentView.addSubview(descriptionLabel)
        
        imageView.translatesAutoresizingMaskIntoConstraints = false
        descriptionLabel.translatesAutoresizingMaskIntoConstraints = false
        amountLabel.translatesAutoresizingMaskIntoConstraints = false
        favoriteButton.translatesAutoresizingMaskIntoConstraints = false
                
        NSLayoutConstraint.activate([        
            imageView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 6),
            imageView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -6),
            imageView.topAnchor.constraint(equalTo: topAnchor, constant: 6),
            imageView.bottomAnchor.constraint(equalTo: amountLabel.topAnchor, constant: -8),
            amountLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 6),
            amountLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -6),
            amountLabel.bottomAnchor.constraint(equalTo: descriptionLabel.topAnchor, constant: -3),
            descriptionLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 6),
            descriptionLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -6),
            descriptionLabel.bottomAnchor.constraint(equalTo: favoriteButton.topAnchor, constant: -4),
            favoriteButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -6),
            favoriteButton.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -6)
        ])
        
        favoriteButton.addTarget(self, action: #selector(favoriteButtonTapped), for: .touchUpInside)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc private func favoriteButtonTapped() {
        favoriteButton.isSelected.toggle()
        delegate?.offerCollectionViewCellDidTapFavoriteButton(self)
    }
    
    // MARK: - Delegate
    
    weak var delegate: OfferCollectionViewCellDelegate?
}

protocol OfferCollectionViewCellDelegate: AnyObject {
    func offerCollectionViewCellDidTapFavoriteButton(_ cell: OfferCollectionViewCell)
}

extension UIColor {
    convenience init(hexString: String) {
        let hex = hexString.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
        var int = UInt64()
        Scanner(string: hex).scanHexInt64(&int)
        let a, r, g, b: UInt64
        switch hex.count {
        case 3: // RGB (12-bit)
            (a, r, g, b) = (255, (int >> 8) * 17, (int >> 4 & 0xF) * 17, (int & 0xF) * 17)
        case 6: // RGB (24-bit)
            (a, r, g, b) = (255, int >> 16, int >> 8 & 0xFF, int & 0xFF)
        case 8: // ARGB (32-bit)
            (a, r, g, b) = (int >> 24, int >> 16 & 0xFF, int >> 8 & 0xFF, int & 0xFF)
        default:
            (a, r, g, b) = (255, 0, 0, 0)
        }
        self.init(red: CGFloat(r) / 255, green: CGFloat(g) / 255, blue: CGFloat(b) / 255, alpha: CGFloat(a) / 255)
    }
}
