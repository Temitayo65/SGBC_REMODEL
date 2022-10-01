//
//  NewsDetailsTableViewCell.swift
//  SGBC_REMODEL
//
//  Created by ADMIN on 01/10/2022.
//

import UIKit

class NewsDetailsTableViewCell: UITableViewCell {

    @IBOutlet var firstSectionTextLabel: UILabel!
    @IBOutlet var newsImageView: UIImageView!
    @IBOutlet var secondSectionTextLabel: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        newsImageView.layer.cornerRadius = 10 
    }

    

}
