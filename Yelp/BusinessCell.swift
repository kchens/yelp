//
//  BusinessCell.swift
//  Yelp
//
//  Created by Kevin Chen on 9/22/15.
//  Copyright © 2015 Timothy Lee. All rights reserved.
//

import UIKit

class BusinessCell: UITableViewCell {

    @IBOutlet weak var thumbImageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var ratingsImageView: UIImageView!
    @IBOutlet weak var reviewsCountLabel: UILabel!
    @IBOutlet weak var addressLabel: UILabel!
    @IBOutlet weak var categoriesLabel: UILabel!
    @IBOutlet weak var distanceLabel: UILabel!
    
    var business: Business? {
        didSet {
            thumbImageView.setImageWithURL(business!.imageURL)
            nameLabel.text = business!.name
            ratingsImageView.setImageWithURL(business!.ratingImageURL)
            reviewsCountLabel.text = ("\(business!.reviewCount!) Reviews")
            addressLabel.text = business!.address
            categoriesLabel.text = business!.categories
            distanceLabel.text = business!.distance
        }
    }
  
    override func awakeFromNib() {
        super.awakeFromNib()
        self.layoutMargins = UIEdgeInsetsZero
        
        thumbImageView.layer.cornerRadius = 3
        thumbImageView.clipsToBounds = true
        
        nameLabel.preferredMaxLayoutWidth = nameLabel.frame.size.width
    }

    // When the dimensions change, change the dimensions again
    override func layoutSubviews() {
        super.layoutSubviews()
        nameLabel.preferredMaxLayoutWidth = nameLabel.frame.size.width
    }
    
    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
