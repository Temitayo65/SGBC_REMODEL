//
//  NewsDetailsViewController.swift
//  SGBC_REMODEL
//
//  Created by ADMIN on 01/10/2022.
//

import UIKit

class NewsDetailsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    var newsTitle: String!
    var newsBody: String!
    var newsImageURL: String!

    @IBOutlet var newsDetailsTableView: UITableView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.navigationBar.isHidden = false
        navigationController?.navigationBar.topItem?.backButtonTitle = ""
       
        
        newsDetailsTableView.register(UINib(nibName: "NewsDetailsTableViewCell", bundle: nil), forCellReuseIdentifier: "newsdetailscell")
        newsDetailsTableView.delegate = self
        newsDetailsTableView.dataSource = self

    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: "newsdetailscell", for: indexPath) as? NewsDetailsTableViewCell{
            let url = URL(string: newsImageURL)!
            cell.newsImageView.load(url: url)
            let details = newsBody!
            let index = details.firstIndex(of: ".")!
            let first_part = String(details[...index])
            let last_part = String(details.suffix(details.count - first_part.count - 1))
            cell.newsTitle.text = newsTitle.uppercased()
            cell.firstSectionTextLabel.text = first_part
            cell.secondSectionTextLabel.text = last_part
            return cell
        }
        return UITableViewCell()
    }

    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 900
    }
    


}
