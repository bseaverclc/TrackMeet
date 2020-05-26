//
//  TimeTableViewCell.swift
//  TrackMeet
//
//  Created by Brian Seaver on 5/17/20.
//  Copyright © 2020 clc.seaver. All rights reserved.
//


import UIKit
public class TimeTableViewCell : UITableViewCell{
  
    @IBOutlet weak var timeOutlet: UITextField!
    @IBOutlet weak var nameOutlet: UILabel!
    @IBOutlet weak var placeOutlet: UITextField!
    @IBOutlet weak var schoolOutlet: UILabel!
    
   
    
    func configure(text: String, placeholder : String, placeText : String){
        
        timeOutlet.placeholder = placeholder
        timeOutlet.text = text
        placeOutlet.placeholder = "PL"
       
        placeOutlet.text = placeText
    }
    
    func configure(text: String, placeholder : String){
           
           timeOutlet.placeholder = placeholder
           timeOutlet.text = text
           placeOutlet.placeholder = "PL"
        placeOutlet.text = ""
          
           
       }
    
}

