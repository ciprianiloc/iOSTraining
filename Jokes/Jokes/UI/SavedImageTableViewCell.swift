//
//  SavedImageTableViewCell.swift
//  Jokes
//
//  Created by Irina Țari on 6/29/17.
//  Copyright © 2017 Ciprian Iloc. All rights reserved.
//

import UIKit

class SavedImageTableViewCell: UITableViewCell {

    var savedImageLabel: UILabel = UILabel()
    var savedImageView: UIImageView = UIImageView()
    
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: .default, reuseIdentifier: "TableCell")
        
        self.contentView.addSubview(savedImageLabel)
        self.contentView.addSubview(savedImageView)
        
    }
    
    required init?(coder aDecoder: NSCoder) {

        super.init(coder: aDecoder)
        
    }
    
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
