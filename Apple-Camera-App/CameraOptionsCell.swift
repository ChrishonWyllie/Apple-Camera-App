//
//  CustomCell.swift
//  Apple-Camera-App
//
//  Created by Chrishon Wyllie on 9/19/17.
//  Copyright © 2017 Chrishon Wyllie. All rights reserved.
//

import UIKit

class CameraOptionsCell: UICollectionViewCell {
    
    var optionTitle: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .white
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        addSubview(optionTitle)
        
        optionTitle.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        optionTitle.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
