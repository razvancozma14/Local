//
//  LocationAddressTableViewCell.swift
//  Local
//
//  Created by Razvan Cozma on 02/09/2020.
//  Copyright © 2020 Razvan Cozma. All rights reserved.
//

import Foundation

import UIKit

class LocationAddressTableViewCell: UITableViewCell {
    private let padding: CGFloat = Constants.UI.defaultPadding

    lazy var addressTextField: TextField = {
        let textField = TextField()
        textField.font = UIFont.systemFont(ofSize: 14, weight: .light)
        textField.textColor = Constants.UI.grayColor
        textField.layer.borderColor = Constants.UI.grayColor.cgColor
        textField.layer.borderWidth = 1.0
        textField.layer.cornerRadius = 8.0
        return textField
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
            .bottomAnchor(equalTo: contentView.bottomAnchor)
        
        cornerBackgroundView.addSubview(addressTextField)
        addressTextField.leadingAnchor(equalTo: cornerBackgroundView.leadingAnchor, constant: halfPadding)
            .trailingAnchor(equalTo: cornerBackgroundView.trailingAnchor, constant: -halfPadding)
            .topAnchor(equalTo: cornerBackgroundView.topAnchor, constant: padding)
            .bottomAnchor(equalTo: contentView.bottomAnchor, constant: -padding)
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
}
