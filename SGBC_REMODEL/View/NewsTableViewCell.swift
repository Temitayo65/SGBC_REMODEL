//
//  NewsTableViewCell.swift
//  SGBC_REMODEL
//
//  Created by ADMIN on 01/10/2022.
//

import UIKit

class NewsTableViewCell: UITableViewCell {

    @IBOutlet var newsImageView: UIImageView!
    @IBOutlet var newsTitleLabel: UILabel!
    @IBOutlet var newsBodyTextLabel: UILabel!
    @IBOutlet var newsTimeLabel: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        newsImageView.layer.cornerRadius = 5
    }

    
    func configureCell(news: [NewsData], indexPath: IndexPath){
        let url = URL(string: news[indexPath.row].newsImage.image_url)!
        self.newsImageView.load(url: url)
        self.newsTitleLabel.text = news[indexPath.row].title.uppercased()
        self.newsTitleLabel.numberOfLines = 3
        self.newsBodyTextLabel.text = news[indexPath.row].body
    }

    
    
}
