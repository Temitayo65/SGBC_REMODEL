//
//  SearchTableViewCell.swift
//  SGBC_REMODEL
//
//  Created by ADMIN on 03/10/2022.
//

import UIKit

class SearchTableViewCell: UITableViewCell {

    
    @IBOutlet var searchImage: UIImageView!
    @IBOutlet var searchTitle: UILabel!
    @IBOutlet var category: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        searchImage.layer.cornerRadius = 5

    }

    func configureCell(data searchData: [Any], index indexPath: Int){
        
        if searchData[indexPath] is Sermon{
            let data = searchData[indexPath] as! Sermon
            searchImage.image = UIImage(named: "placeholder")
            searchTitle.text = data.title
            category.text = "Sermon"
        }
        else if searchData[indexPath] is Podcast{
            let data = searchData[indexPath] as! Podcast
            searchImage.image = UIImage(named: "placeholder")
            searchTitle.text = data.title
            category.text = "Podcast"
        }
        
        else if searchData[indexPath] is NewsData{
            let data = searchData[indexPath] as! NewsData
            searchImage.image = UIImage(named: "placeholder")
            searchTitle.text = data.title
            category.text = "News"
        }
    }

}
