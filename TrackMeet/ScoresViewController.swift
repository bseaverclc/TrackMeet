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
    var teamPoints = [String: [String:Double]]()
   
    var meet : Meet!
    var levels = [String]()
    
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
        print("Scores View Did Load")
        var initials = [String](meet.schools.values)
        levels = meet.levels
        for lev in levels{
            for team in initials{
                (teamPoints[lev]?)[team] = 0.0
            }
        }
        
        print("initial team points: \(teamPoints)")
        computeScores()
        
    }
    

    func computeScores(){
        
        for a in allAthletes{
            var updated = false
            
            for e in a.events{
                if e.markString != ""{
                    
                    var current = teamPoints[e.level]!
                    let currentPoints = current[a.school]!
                        current.updateValue(currentPoints + e.points, forKey: a.school)
                         
                     }
                    
                    // if event was a relay
                    if e.name.contains("4x"){
                        // if they placed put place in output
                       if let pl = e.place{
                        textViewOutlet.text += "R,\(meet.gender), \(e.level),\(e.name.dropLast(4)),\(pl), , , ,\(a.school),\(e.markString),\(e.points),Finals, , \n"
                                          }
                        // if they didn't place leave spot open
                       else{
                            textViewOutlet.text += "R,\(meet.gender),\(e.level),\(e.name.dropLast(4)), , , ,\(a.school),\(e.markString),\(e.points),Finals, , \n"
                            }
                    }
                      //  If event was individual
                    else{
                      if let pl = e.place{
                        textViewOutlet.text += "E,\(meet.gender),\(e.level),\(e.name.dropLast(4)),\(pl),\(a.last),\(a.first),\(a.grade),\(a.school),\(e.markString),\(e.points),Finals, , \n"
                      }
                      else{
                        textViewOutlet.text += "E,\(meet.gender),\(e.level),\(e.name.dropLast(4)), ,\(a.last),\(a.first),\(a.grade),\(a.school),\(e.markString),\(e.points),Finals, , \n"
                        
                        }
                        }
                   
                    
                }
                }
        
            
       
            
        for (key,value) in teamPoints{
            for (k,v) in value{
            textViewOutlet.text += "S,\(meet.gender),\(key),,\(k),\(v)\n"
            }
        }
        
       
        
//        CLCScoreOutlet.text = "\(teamPointsVAR["CLC"]!)"
//        CLSScoreOutlet.text = "\(teamPointsVAR["CLS"]!)"
//        CGScoreOutlet.text = "\(teamPointsVAR["CG"]!)"
//        PRScoreOutlet.text = "\(teamPointsVAR["PR"]!)"
//        
//        CLCFSOutlet.text = "\(teamPointsFS["CLC"]!)"
//        CLSFSOutlet.text = "\(teamPointsFS["CLS"]!)"
//        CGFSOutlet.text = "\(teamPointsFS["CG"]!)"
//        PRFSOutlet.text = "\(teamPointsFS["PR"]!)"
    }
        

}
