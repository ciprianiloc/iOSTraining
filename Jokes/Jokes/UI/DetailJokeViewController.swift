//
//  DetailJokeViewController.swift
//  Jokes
//
//  Created by Cristian Banarescu on 6/22/17.
//  Copyright © 2017 Ciprian Iloc. All rights reserved.
//

import UIKit


class DetailJokeViewController: UIViewController {

    
    @IBOutlet var detailJokeView: UIView!
    
    
    @IBOutlet weak var detailLabel: UILabel!
    
    @IBOutlet weak var detailImageView: UIImageView!
    
    
    var selectedJoke : String?
    var selectedImage : UIImage?
    
    
   
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
      //  imageDetailView = myDetailRating?.jokeImageView
        detailLabel.text = selectedJoke
       // detailImageView.image = selectedImage
        
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
