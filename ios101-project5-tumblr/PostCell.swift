//
//  PostCell.swift
//  ios101-project5-tumblr
//
//  Created by Linh on 3/25/24.
//

import UIKit

class PostCell: UITableViewCell {

    @IBOutlet weak var poster: UIImageView!
    
    @IBOutlet weak var summary: UILabel!
    
    @IBOutlet weak var caption: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
