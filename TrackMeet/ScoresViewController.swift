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
    
    var schoolsOutlet = [UILabel]()
    
    @IBOutlet weak var meetNameOutlet: UILabel!
    @IBOutlet var levelsOutlet: [UILabel]!
    @IBOutlet var schoolsStackView: [UIStackView]!
    @IBOutlet var scoresStackView: [UIStackView]!
    
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
        meetNameOutlet.text = meet.name
        print("meet name : \(meet.name)")
   
        var initials = [String](meet.schools.values)
        for i in 0 ..< initials.count{
            initials[i] = initials[i].uppercased()
        }
        initials.sort(by: {$0 < $1 })
        levels = meet.levels
        for lev in levels{
            // hard code the first one
            teamPoints[lev] = [initials[0]: 0.0]
            // fill in the rest if needed
            for i in 1..<initials.count{
                    (teamPoints[lev]!)[initials[i]] = 0.0
                }
           
            }
        
        print("initial team points: \(teamPoints)")
        computeScores()
        print("Scores View Did Load")
    }
    

    func computeScores(){
        
        for a in allAthletes{
            var updated = false
            
            for e in a.events{
                if e.meetName == meet.name{
                  if e.markString != "" {
                    
                    //var current = teamPoints[e.level]!
                    let currentPoints = teamPoints[e.level]![a.school]!
                        teamPoints[e.level]!.updateValue(currentPoints + e.points, forKey: a.school)
                    print("points added to school \(a.school): \(teamPoints[e.level]![a.school])")
                     
                    
                    // if event was a relay
                    if e.name.contains("4x"){
                        // if they placed put place in output
                       if let pl = e.place{
                        textViewOutlet.text += "R,\(meet.gender), \(e.level),\(e.name.dropLast(4)),\(pl), , , ,\(a.schoolFull),\(e.markString),\(e.points),Finals, , \n"
                                          }
                        // if they didn't place leave spot open
                       else{
                            textViewOutlet.text += "R,\(meet.gender),\(e.level),\(e.name.dropLast(4)), , , ,\(a.schoolFull),\(e.markString),\(e.points),Finals, , \n"
                            }
                    }
                      //  If event was individual
                    else{
                      if let pl = e.place{
                        textViewOutlet.text += "E,\(meet.gender),\(e.level),\(e.name.dropLast(4)),\(pl),\(a.last),\(a.first),\(a.grade),\(a.schoolFull),\(e.markString),\(e.points),Finals, , \n"
                      }
                      else{
                        textViewOutlet.text += "E,\(meet.gender),\(e.level),\(e.name.dropLast(4)), ,\(a.last),\(a.first),\(a.grade),\(a.schoolFull),\(e.markString),\(e.points),Finals, , \n"
                        
                        }
                        }
                   
                    
                }
                }
            }
                }
        
            
       // Need to figure out how to clear out labels everytime????
        // I think I should add the labels in view did load and update their text values here
        // I will need to build an array of uiLabels
            var i = 0
        for (level,scores) in teamPoints {
            if i < schoolsStackView.count{
            // add level text header
            levelsOutlet[i].text = "\(level) Scores"
        
                
                
            for (initials,score) in scores{
                // print info to textview
                var fullSchool = ""
                for (sch,ini) in meet.schools{
                    if initials == ini{
                        fullSchool = sch
                    }
                }
            textViewOutlet.text += "S,\(meet.gender),\(level),,\(fullSchool),\(score)\n"
                // set up school labels
                var label = UILabel()
                label.text = "\(initials)"
                label.textAlignment = .center
                schoolsStackView[i].addArrangedSubview(label)
                
                // set up score labels
                var label2 = UILabel()
                label2.text = "\(score)"
                label2.textAlignment = .center
                scoresStackView[i].addArrangedSubview(label2)
                }
                
            }
            else{print("i value too big when adding score labels")}
            i+=1
        }
        
//       for (key,value) in meet.schools{
//                 var label = UILabel()
//                       label.text = value
//                       schoolsOutlet.append(label)
//                 schoolsStackViewA.addArrangedSubview(label)
//             }
        
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
