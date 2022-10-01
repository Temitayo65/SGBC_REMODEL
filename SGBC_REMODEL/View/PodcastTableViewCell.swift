//
//  PodcastTableViewCell.swift
//  SGBC_REMODEL
//
//  Created by ADMIN on 27/09/2022.
//

import UIKit

class PodcastTableViewCell: UITableViewCell {

    
    @IBOutlet var podcastImageView: UIImageView!
    @IBOutlet var podcastEpisodeLabel: UILabel!
    @IBOutlet var podcastTitleLabel: UILabel!
    @IBOutlet var podcastDateLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        podcastImageView.layer.cornerRadius = 10
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
