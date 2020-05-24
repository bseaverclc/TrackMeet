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
    var teamPointsVAR = ["CLC":0.0, "CLS":0.0, "CG": 0.0, "PR": 0.0]
    var teamPointsFS = ["CLC":0.0, "CLS":0.0, "CG": 0.0, "PR": 0.0]

    
    @IBOutlet weak var CLCFSOutlet: UILabel!
    @IBOutlet weak var CLSFSOutlet: UILabel!
    @IBOutlet weak var CGFSOutlet: UILabel!
    @IBOutlet weak var PRFSOutlet: UILabel!
    
    
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
                if e.markString != ""{
                    if e.level == "VAR"{
                        if let current = teamPointsVAR[a.school]{
                        teamPointsVAR.updateValue(current + e.points, forKey: a.school)
                         }
                     }
                    else{
                        if let current = teamPointsFS[a.school]{
                            teamPointsFS.updateValue(current + e.points, forKey: a.school)
                         }
                    }
                    
                    if e.name.contains("4x"){
                       if let pl = e.place{
                            textViewOutlet.text += "R,M,\(e.level),\(e.name.dropLast(4)),\(pl), , , ,\(a.school),\(e.markString),\(e.points),Finals, , \n"
                                          }
                       else{
                            textViewOutlet.text += "R,M,\(e.level),\(e.name.dropLast(4)), , , ,\(a.school),\(e.markString),\(e.points),Finals, , \n"
                            }
                    }
                    else{
                      if let pl = e.place{
                        textViewOutlet.text += "E,M,\(e.level),\(e.name.dropLast(4)),\(pl),\(a.last),\(a.first),\(a.grade),\(a.school),\(e.markString),\(e.points),Finals, , \n"
                      }
                      else{
                        textViewOutlet.text += "E,M,\(e.level),\(e.name.dropLast(4)), ,\(a.last),\(a.first),\(a.grade),\(a.school),\(e.markString),\(e.points),Finals, , \n"
                        
                        }
                        }
                   
                    
                }
                }
        }
            
           // if updated{textViewOutlet.text += "\(teamPoints)\n\n"}
            
        for (key,value) in teamPointsVAR{
        textViewOutlet.text += "S,M,VAR,,\(key),\(value)\n"
        }
        
        for (key,value) in teamPointsFS{
               textViewOutlet.text += "S,M,F/S,,\(key),\(value)\n"
               }
        
        CLCScoreOutlet.text = "\(teamPointsVAR["CLC"]!)"
        CLSScoreOutlet.text = "\(teamPointsVAR["CLS"]!)"
        CGScoreOutlet.text = "\(teamPointsVAR["CG"]!)"
        PRScoreOutlet.text = "\(teamPointsVAR["PR"]!)"
        
        CLCFSOutlet.text = "\(teamPointsFS["CLC"]!)"
        CLSFSOutlet.text = "\(teamPointsFS["CLS"]!)"
        CGFSOutlet.text = "\(teamPointsFS["CG"]!)"
        PRFSOutlet.text = "\(teamPointsFS["PR"]!)"
    }
        

}
