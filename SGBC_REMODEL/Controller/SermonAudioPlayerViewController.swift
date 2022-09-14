//
//  SermonAudioPlayerViewController.swift
//  SGBC_REMODEL
//
//  Created by ADMIN on 14/09/2022.
//

import UIKit
import SwiftAudioPlayer

class SermonAudioPlayerViewController: UIViewController {
    var sermonImageURL: String?
    var sermonTitle: String!
    var preacherTitle: String!
    
    @IBOutlet var sermonImageView: UIImageView!
    @IBOutlet var sermonTitleLabel: UILabel!
    @IBOutlet var preacherTitleLabel: UILabel!
    @IBOutlet var sermonProgressView: UIProgressView!
    @IBOutlet var sermonPlayButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        sermonTitleLabel.text = sermonTitle
        preacherTitleLabel.text = preacherTitle
        if let sermonImageURL = sermonImageURL {
            sermonImageView.load(url: URL(string: sermonImageURL) ?? URL(string: "https://sgbc.ams3.digitaloceanspaces.com/Images/March-2021/The-Disobedience-of-the-First-Adam.jpg?AWSAccessKeyId=C663TNSAPB6NR24LMYTF&Expires=1663194626&Signature=Lsq7scPvzVMUx%2FuIZlKNCKSKZ64%3D")!) // Tell Dara that he missed the link for one of these 
            sermonImageView.layer.borderColor = CGColor(red: 0.5, green: 0.5, blue: 0.3, alpha: 0.3)
            sermonImageView.layer.cornerRadius = 15
            view.reloadInputViews()
        }else{
            sermonImageView.image = UIImage(named: "placeholder")
            sermonImageView.layer.cornerRadius = 15
            view.reloadInputViews()
        }

    }
    
    
    
    @IBAction func sermonRewindButtonPressed(_ sender: UIButton) {
    }
    
    @IBAction func sermonForwardButtonPressed(_ sender: UIButton) {
    }
    
    @IBAction func sermonPlayButtonPressed(_ sender: Any) {
    }
    
    @IBAction func sermonRateButtonPressed(_ sender: UIButton) {
    }
    
    @IBAction func sermonOptionButtonPressed(_ sender: UIButton) {
        
    }
    
    

}
