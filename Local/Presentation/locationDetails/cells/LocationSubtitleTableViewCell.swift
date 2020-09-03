//
//  LocationSubtitleTableViewCell.swift
//  Local
//
//  Created by Razvan Cozma on 02/09/2020.
//  Copyright © 2020 Razvan Cozma. All rights reserved.
//

import Foundation

import UIKit

class LocationSubtitleTableViewCell: UITableViewCell {
    private let padding: CGFloat = Constants.UI.defaultPadding
    lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.text = ""
        label.numberOfLines = 0
        label.font = UIFont.systemFont(ofSize: 14, weight: .light)
        label.textColor =  .black
        return label
    }()
    
    lazy var subTitleLabel: UILabel = {
        let label = UILabel()
        label.text = ""
        label.numberOfLines = 0
        label.font = UIFont.systemFont(ofSize: 14, weight: .light)
        label.textColor = Constants.UI.grayColor
        return label
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
    
    override func prepareForReuse() {
        super.prepareForReuse()
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.backgroundColor = UIColor.clear
        self.selectionStyle = .none
        let halfPadding = padding / 2
        self.contentView.addSubview(cornerBackgroundView)
        cornerBackgroundView.leadingAnchor(equalTo: contentView.leadingAnchor, constant: padding)
            .trailingAnchor(equalTo: contentView.trailingAnchor, constant: -padding)
            .topAnchor(equalTo: contentView.topAnchor, constant: padding)
            .bottomAnchor(equalTo: contentView.bottomAnchor)//, constant: -halfPadding)
        //        .heightAnchor(equalTo: 100)
        
        
        cornerBackgroundView.addSubview(titleLabel)
        cornerBackgroundView.addSubview(subTitleLabel)
        titleLabel.leadingAnchor(equalTo: cornerBackgroundView.leadingAnchor, constant: halfPadding)
            .topAnchor(equalTo: cornerBackgroundView.topAnchor, constant: padding)
            .trailingAnchor(lessThanOrEqualTo: subTitleLabel.leadingAnchor)
            .bottomAnchor(equalTo: cornerBackgroundView.bottomAnchor, constant: -padding)
        
        subTitleLabel.trailingAnchor(equalTo: cornerBackgroundView.trailingAnchor, constant: -halfPadding)
            .topAnchor(equalTo: titleLabel.topAnchor)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
}
