//
//  ScoresViewController.swift
//  TrackMeet
//
//  Created by Brian Seaver on 5/21/20.
//  Copyright © 2020 clc.seaver. All rights reserved.
//

import UIKit

class ScoresViewController: UIViewController {
    var allAthletes: [Athlete]!
    @IBOutlet weak var textViewOutlet: UITextView!
    var teamPoints = ["CLC":0.0, "CLS":0.0, "CG": 0.0, "PR": 0.0]
    

    

    
    @IBOutlet weak var PRScoreOutlet: UILabel!
    @IBOutlet weak var CLSScoreOutlet: UILabel!
    @IBOutlet weak var CLCScoreOutlet: UILabel!
    @IBOutlet weak var CGScoreOutlet: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
        computeScores()
        //print(teamPoints)

        // Do any additional setup after loading the view.
    }
    

    func computeScores(){
        
        for a in allAthletes{
            var updated = false
            
            for e in a.events{
                textViewOutlet.text += "\(a.last), \(a.first): "
                if let current = teamPoints[a.school]{
                    updated = true
                teamPoints.updateValue(current + e.points, forKey: a.school)
                    textViewOutlet.text += "\(e.name) \(e.points)\n"
                    //print(teamPoints)
                    
                }
            }
           // if updated{textViewOutlet.text += "\(teamPoints)\n\n"}
            
        }
        CLCScoreOutlet.text = "\(teamPoints["CLC"]!)"
        CLSScoreOutlet.text = "\(teamPoints["CLS"]!)"
        CGScoreOutlet.text = "\(teamPoints["CG"]!)"
        PRScoreOutlet.text = "\(teamPoints["PR"]!)"
    }

}
