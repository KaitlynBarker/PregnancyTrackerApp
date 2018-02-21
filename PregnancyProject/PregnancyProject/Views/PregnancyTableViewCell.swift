//
//  PregnancyTableViewCell.swift
//  PregnancyProject
//
//  Created by Kaitlyn Barker on 2/20/18.
//  Copyright © 2018 Kaitlyn Barker. All rights reserved.
//

import UIKit

class PregnancyTableViewCell: UITableViewCell {
    
    // MARK: - Outlets
    
    @IBOutlet weak var pregProfileImageView: UIImageView!
    @IBOutlet weak var pregNameLabel: UILabel!
    @IBOutlet weak var dueDateLabel: UILabel!
    
    var pregnancy: Pregnancy? {
        didSet {
            updateViews()
        }
    }
    
    func updateViews() {
        guard let pregnancy = pregnancy else { return }
        
//        self.pregProfileImageView.image = pregnancy.
        self.pregNameLabel.text = "\(pregnancy.name)"
        self.dueDateLabel.text = "\(pregnancy.dueDate)"
    }
}
