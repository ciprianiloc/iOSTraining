//
//  SortingView.swift
//  Jokes
//
//  Created by Cristian Banarescu on 11/07/2017.
//  Copyright © 2017 Ciprian Iloc. All rights reserved.
//

import UIKit

@IBDesignable class SortingView: UIView {

    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */
    
    // Our custom view from the XIB file
    
    //MARK: - Xib functions
    
    var view: UIView!
    
    @IBOutlet weak var categoryLabel: UILabel!
    @IBOutlet weak var sortLabel: UILabel!
    @IBOutlet weak var ratingButton: UIButton!
    @IBOutlet weak var dateAddedButton: UIButton!
    var sectionFromView : Int = 0
    var categoryFromAllJokes : String = ""
    
  
   
    
    func xibSetup() {
        view = loadViewFromNib()
        
        // use bounds not frame or it'll be offset
        view.frame = bounds
        
        // Make the view stretch with containing view
        view.autoresizingMask = [UIViewAutoresizing.flexibleWidth, UIViewAutoresizing.flexibleHeight]
        // Adding custom subview on top of our view (over any custom drawing > see note below)
        addSubview(view)
    }
    
    func loadViewFromNib() -> UIView {
        
        let bundle = Bundle(for: type(of: self))
        let nib = UINib(nibName: "SortingView", bundle: bundle)
        let view = nib.instantiate(withOwner: self, options: nil)[0] as! UIView
        
        self.dateAddedButton.addTarget(AllJokesTableViewController(), action: #selector(AllJokesTableViewController.dateButtonPressed(sender:)), for: .touchUpInside)
        self.dateAddedButton.tag = self.sectionFromView
        self.ratingButton.addTarget(AllJokesTableViewController(), action: #selector(AllJokesTableViewController.ratingButtonPressed(sender:)), for: .touchUpInside)
        self.ratingButton.tag = self.sectionFromView
        self.categoryLabel.text = self.categoryFromAllJokes
        return view
    }
}
