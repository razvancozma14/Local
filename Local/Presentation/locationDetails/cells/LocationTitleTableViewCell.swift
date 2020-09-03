//
//  LocationTitleTableViewCell.swift
//  Local
//
//  Created by Razvan Cozma on 02/09/2020.
//  Copyright © 2020 Razvan Cozma. All rights reserved.
//

import UIKit

class LocationTitleTableViewCell: UITableViewCell {
    lazy var nameLabel: UILabel = {
        let label = UILabel()
        label.text = ""
        label.numberOfLines = 0
        label.textColor = .black
        label.font = UIFont.systemFont(ofSize: 19, weight: .regular)
        return label
    }()
    
    private let padding: CGFloat = Constants.UI.defaultPadding
    
    override func prepareForReuse() {
        super.prepareForReuse()
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.backgroundColor = UIColor.clear
        self.selectionStyle = .none
        
        self.contentView.addSubview(nameLabel)
        nameLabel.leadingAnchor(equalTo: contentView.leadingAnchor, constant: padding)
            .trailingAnchor(equalTo: contentView.trailingAnchor, constant: -padding)
            .topAnchor(equalTo: contentView.topAnchor, constant: padding)
        .bottomAnchor(equalTo: contentView.bottomAnchor)
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
}
