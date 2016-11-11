//
//  DetailViewController.swift
//  Search iTunes Debugging
//
//  Created by Jake Gundersen on 11/11/16.
//  Copyright © 2016 Jake Gundersen. All rights reserved.
//

import UIKit

class DetailViewController : UIViewController {
    @IBOutlet weak var iconImageView: UIImageView!
    
    @IBOutlet weak var artistLabel: UILabel!
    @IBOutlet weak var titleLabel: UILabel!
    
    @IBOutlet weak var descriptionTextBox: UITextView!
    @IBOutlet weak var screenshotImageView: UIImageView!
    
    var result : Result?
    
    override func viewDidLoad() {
        if let r = result {
            if let awi = r.artworkImage {
                iconImageView.image = awi
            }
            artistLabel.text = r.artistName
            titleLabel.text = r.trackName
            descriptionTextBox.text = r.itemDescription
        }
        
        result?.loadScreenShots(completion: { [weak self] (images) in
            if let img = images.first {
                DispatchQueue.main.async {
                    self?.screenshotImageView.image = img
                }
            }
        })
    }
    
}
