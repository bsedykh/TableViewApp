//
//  CustomTableViewCell.swift
//  TableViewApp
//
//  Created by Борис Седых on 17.08.2022.
//

import UIKit

class CustomTableViewCell: UITableViewCell {

    @IBOutlet weak var placeImage: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var locationLabel: UILabel!
    @IBOutlet weak var typeLabel: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        placeImage.layer.cornerRadius = placeImage.frame.size.height / 2
        placeImage.clipsToBounds = true
    }
}
