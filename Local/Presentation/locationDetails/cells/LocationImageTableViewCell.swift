//
//  LocationImageTableViewCell.swift
//  Local
//
//  Created by Razvan Cozma on 02/09/2020.
//  Copyright © 2020 Razvan Cozma. All rights reserved.
//

import UIKit

class LocationImageTableViewCell: UITableViewCell {
    
    lazy var locationImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.clipsToBounds = true
        imageView.contentMode = .scaleAspectFill
        return imageView
    }()
    
    lazy var cornerBackgroundView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.layer.cornerRadius = 8.0
        view.clipsToBounds = true
        self.layer.shadowOffset = CGSize(width: 0, height: 2.5)
        self.layer.shadowRadius = 2.5
        self.layer.shadowColor = UIColor.lightGray.cgColor
        self.layer.shadowOpacity = 0.4
        return view
    }()
    
    private let padding: CGFloat = Constants.UI.defaultPadding
    
    override func prepareForReuse() {
        super.prepareForReuse()
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.backgroundColor = UIColor.clear
        self.selectionStyle = .none
        
        self.contentView.addSubview(cornerBackgroundView)
        cornerBackgroundView.leadingAnchor(equalTo: contentView.leadingAnchor, constant: padding)
            .trailingAnchor(equalTo: contentView.trailingAnchor, constant: -padding)
            .topAnchor(equalTo: contentView.topAnchor, constant: padding)
            .bottomAnchor(equalTo: contentView.bottomAnchor, priority: .low)
            .heightAnchor(equalTo: cornerBackgroundView.widthAnchor, multiplier: 0.5)
        
        self.cornerBackgroundView.addSubview(locationImageView)
        locationImageView.leadingAnchor(equalTo: cornerBackgroundView.leadingAnchor)
            .trailingAnchor(equalTo: cornerBackgroundView.trailingAnchor)
            .topAnchor(equalTo: cornerBackgroundView.topAnchor)
            .bottomAnchor(equalTo: cornerBackgroundView.bottomAnchor)
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
}
