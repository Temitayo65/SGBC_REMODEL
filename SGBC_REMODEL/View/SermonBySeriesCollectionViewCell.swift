//
//  SermonBySeriesCollectionViewCell.swift
//  SGBC_REMODEL
//
//  Created by ADMIN on 24/09/2022.
//

import UIKit

class SermonBySeriesCollectionViewCell: UICollectionViewCell {

    
    @IBOutlet var seriesImageView: UIImageView!
    @IBOutlet var seriesTitle: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        seriesImageView.layer.cornerRadius = 10
    }

}
