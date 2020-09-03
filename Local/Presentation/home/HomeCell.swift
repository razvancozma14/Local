//
//  HomeCell.swift
//  Local
//
//  Created by Razvan Cozma on 02/09/2020.
//  Copyright © 2020 Razvan Cozma. All rights reserved.
//

import UIKit
import Kingfisher
import FSPagerView

class HomeCell: FSPagerViewCell {

    lazy var locationImageView: UIImageView = {
        let imageView = UIImageView()
        return imageView
    }()
    
    lazy var overlayView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.black.withAlphaComponent(0.5)
        return view
    }()
    
    lazy var overlay : UILabel = {
        let overlayLable = UILabel()
        overlayLable.textColor = .white
        overlayLable.textAlignment = .center
        overlayLable.numberOfLines = 2
        overlayLable.font = UIFont.systemFont(ofSize: 15, weight: .regular)
        
        return overlayLable
    }()
    
    lazy var cornerBackgroundView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.layer.cornerRadius = 20.0
        view.clipsToBounds = true
        return view
    }()
    
    
    override func prepareForReuse() {
        super.prepareForReuse()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = UIColor.clear
        self.clipsToBounds = false
        self.layer.masksToBounds = false
        self.contentView.clipsToBounds = false
        self.contentView.layer.masksToBounds = false
        self.contentView.layer.shadowColor = UIColor.black.cgColor
        self.contentView.layer.shadowRadius = 5
        self.contentView.layer.shadowOpacity = 0.2
        self.contentView.layer.shadowOffset = .zero
        self.contentView.addSubview(cornerBackgroundView)
        
        cornerBackgroundView.translatesAutoresizingMaskIntoConstraints = false
        cornerBackgroundView.topAnchor(equalTo: self.contentView.topAnchor)
            .leadingAnchor(equalTo: self.contentView.leadingAnchor)
            .trailingAnchor(equalTo: self.contentView.trailingAnchor)
            .bottomAnchor(equalTo: contentView.bottomAnchor)
        cornerBackgroundView.clipsToBounds = true
        
        
        cornerBackgroundView.addSubview(locationImageView)
        locationImageView
            .topAnchor(equalTo: cornerBackgroundView.topAnchor)
            .leadingAnchor(equalTo: cornerBackgroundView.leadingAnchor)
            .trailingAnchor(equalTo: cornerBackgroundView.trailingAnchor)
            .bottomAnchor(equalTo: cornerBackgroundView.bottomAnchor)
        locationImageView.clipsToBounds = true
        locationImageView.contentMode = .scaleAspectFill
        
        
        self.locationImageView.addSubview(overlayView)
        overlayView.leadingAnchor(equalTo: locationImageView.leadingAnchor)
        .trailingAnchor(equalTo: locationImageView.trailingAnchor)
        .bottomAnchor(equalTo: locationImageView.bottomAnchor)
        
        self.overlayView.addSubview(overlay)
        self.overlay.leadingAnchor(equalTo: overlayView.leadingAnchor, constant: 10)
            .trailingAnchor(equalTo: overlayView.trailingAnchor, constant: -10)
            .bottomAnchor(equalTo: overlayView.bottomAnchor, constant: -10)
            .topAnchor(equalTo: overlayView.topAnchor, constant: 10)
    }
    
    func update(item: HomeUIItem){
        
        self.overlay.text = item.address
        
        if let url = item.imageUrl {
            locationImageView.kf.setImage(with: url)
            locationImageView.backgroundColor = .clear
        }else{
            locationImageView.backgroundColor = .lightGray
            locationImageView.image = nil
        }
        
    }
}

