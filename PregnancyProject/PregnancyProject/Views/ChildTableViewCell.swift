//
//  ChildTableViewCell.swift
//  PregnancyProject
//
//  Created by Kaitlyn Barker on 2/20/18.
//  Copyright © 2018 Kaitlyn Barker. All rights reserved.
//

import UIKit

class ChildTableViewCell: UITableViewCell {
    
    // MARK: - Outlets
    
    @IBOutlet weak var childProfileImageView: UIImageView!
    @IBOutlet weak var childNameLabel: UILabel!
    @IBOutlet weak var childAgeLabel: UILabel!
    
    var child: Child? {
        didSet {
            updateViews()
        }
    }
    
    func updateViews() {
        guard let child = child else { return }
        
        self.childProfileImageView.image = child.photo
        self.childNameLabel.text = "\(child.name)"
        self.childAgeLabel.text = "\(child.age)"
    }
}
