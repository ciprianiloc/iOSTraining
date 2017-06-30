//
//  JokeCell.swift
//  Jokes
//
//  Created by Cristian Banarescu on 6/22/17.
//  Copyright © 2017 Ciprian Iloc. All rights reserved.
//

import UIKit

class JokeCell: UITableViewCell {

    @IBOutlet weak var jokeLabel: UILabel!
    @IBOutlet weak var jokeImageView: UIImageView!
    @IBOutlet weak var ratingStarsView: CosmosView!
    var jokeCategory : String?
    //var changedRating : Double?
    
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
