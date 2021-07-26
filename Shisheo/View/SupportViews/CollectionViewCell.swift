//
//  collectionViewCell.swift
//  Shisheo
//
//  Created by Arina Nefedova on 26.07.2021.
//

import UIKit
import RxGesture
import RxSwift

class CollectionViewCell: UICollectionViewCell {
    
    @IBOutlet var imageView: UIImageView!
    
    @IBOutlet var nameLabel: UILabel!
    
    @IBOutlet var descriptionLabel: UILabel!
    
    @IBOutlet weak var starsStackView: UIStackView!
    
    @IBOutlet var deliveryPriceLabel: UILabel!
    
    @IBOutlet var offerLabel: UILabel!
    
    @IBOutlet weak var nameAndStarsStackView: UIStackView!
    
    private let disposeBag = DisposeBag()
    
    public var place: Place! {
        didSet {
            self.nameLabel.text = place.name
            self.imageView.loadImage(fromURL: place.image_url)
            self.descriptionLabel.text = place.description
            self.offerLabel.text = place.offer
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.translatesAutoresizingMaskIntoConstraints = false
        self.widthAnchor.constraint(equalToConstant: UIScreen.main.bounds.size.width - 50).isActive = true
                    
        imageView.layer.cornerRadius = 8
        imageView.layer.masksToBounds = true
        
        imageView.rx
          .tapGesture()
          .when(.recognized)
          .subscribe(onNext: { _ in
            self.starsStackView.isHidden = !self.starsStackView.isHidden
          })
          .disposed(by: disposeBag)
        
    }

}
