//
//  SavedImageTableViewCell.swift
//  Jokes
//
//  Created by Irina Țari on 6/29/17.
//  Copyright © 2017 Ciprian Iloc. All rights reserved.
//

import UIKit

class SavedImageTableViewCell: UITableViewCell {

    
    @IBOutlet weak var savedImageLabel: UILabel!
    
    @IBOutlet weak var savedImageView: UIImageView!
 
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
