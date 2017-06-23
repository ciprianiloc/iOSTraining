//
//  DetailJokeViewController.swift
//  Jokes
//
//  Created by Cristian Banarescu on 6/22/17.
//  Copyright © 2017 Ciprian Iloc. All rights reserved.
//

import UIKit
import Foundation

class DetailJokeViewController: UIViewController {

    
    @IBOutlet var detailJokeView: UIView!
    @IBOutlet weak var ratingView: CosmosView!
    @IBOutlet weak var funnyLevelLabel: UILabel!
    @IBOutlet weak var detailLabel: UILabel!
    @IBOutlet weak var detailImageView: UIImageView!
    
    
    var selectedJoke : String?
    var selectedImage : UIImage?
    
    
   
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        detailLabel.text = selectedJoke
        
        
        
        Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(DetailJokeViewController.ratingLevelChanged), userInfo: nil, repeats: true)
 
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func ratingLevelChanged(){
        getRating(rating: Int(ratingView.rating))
    }
    
    
    func getRating(rating: Int){
        switch rating {
        case 1:
            funnyLevelLabel.text = "1 level Funny"
        case 2:
            funnyLevelLabel.text = "2 levels Funny"
        case 3:
            funnyLevelLabel.text = "3 levels Funny"
        case 4:
            funnyLevelLabel.text = "4 levels Funny"
        case 5:
            funnyLevelLabel.text = "5 levels Funny"
        default:
            funnyLevelLabel.text = "1 level Funny"
        }
    }


}

    
    



