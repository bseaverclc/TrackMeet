//
//  LaunchViewController.swift
//  TrackMeet
//
//  Created by Brian Seaver on 7/13/20.
//  Copyright © 2020 clc.seaver. All rights reserved.
//

import UIKit

class LaunchViewController: UIViewController {
   var meets = [Meet]()
   var allAthletes = [Athlete]()
   var schools = [String:String]()
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toMeetsSegue"{
            let nvc = segue.destination as! MeetsViewController
            nvc.allAthletes = allAthletes
            nvc.meets = meets
            nvc.schools = schools
            print("sent stuff to meets")
        }
        else{
            let nvc = segue.destination as! SchoolsViewController
            nvc.allAthletes = allAthletes
            nvc.schools = schools
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let userDefaults = UserDefaults.standard
        
        // Get athletes from UserDefaults
        do {
            let athletes = try userDefaults.getObjects(forKey: "allAthletes", castTo: [Athlete].self)
//            for athlete in athletes{
//                allAthletes.append(athlete)
//            }
            
                   //print(playingItMyWay[0].schoolFull)
               } catch {
                   print(error.localizedDescription)
                  randomizeAthletes()
               }
               //randomizeAthletes()
                //sortByName()
        
        // get meets from userdefaults
        do {
               let inMeets = try userDefaults.getObjects(forKey: "meets", castTo: [Meet].self)
        for meet in inMeets{
            meets.append(meet)
        }
        
               //print(playingItMyWay[0].schoolFull)
           } catch {
               print(error.localizedDescription)
           }
        
        // get schools from UserDefaults
        do {
            let inSchools = try userDefaults.getObjects(forKey: "schools", castTo: [String:String].self)
               for (key,value) in inSchools{
                   schools[key] = value
               }
            print("Got schools from file")
            print(schools)
            } catch {
                schools = ["CRYSTAL LAKE CENTRAL": "CLC", "CRYSTAL LAKE SOUTH": "CLS", "CARY-GROVE": "CG", "PRAIRIE RIDGE": "PR"]
                      print(error.localizedDescription)
                print(schools)
                    }

    }
    
     func randomizeAthletes(){
            allAthletes.append(Athlete(f: "OWEN", l: "MIZE", s: "CLC", g: 12, sf: "CRYSTAL LAKE CENTRAL"))
                allAthletes.append(Athlete(f: "JAKHARI", l: "ANDERSON", s: "CG", g: 12, sf: "CARY-GROVE"))
                allAthletes.append(Athlete(f: "DREW", l: "MCGINNESS", s: "CLS", g: 9, sf: "CRYSTAL LAKE SOUTH"))
            let letters = "ABCDEFGHIJKLMNOPQRSTUVWXYZ"
            let chars = Array(letters)
            let schoolArray = ["CLC","CG","CLS","PR"]
            let schoolFullArray = ["CRYSTAL LAKE CENTRAL", "CARY-GROVE", "CRYSTAL LAKE SOUTH", "PRAIRIE RIDGE"]
                                
            
            for _ in 3...1000{
                var first = ""
                var last = ""
                for _ in 0...4{
                    first.append(String(chars[Int.random(in: 0 ..< chars.count)]))
                    last.append(String(chars[Int.random(in: 0 ..< chars.count)]))
                }
                var choice = Int.random(in: 0..<schoolArray.count)
                let school = schoolArray[choice]
                let schoolF = schoolFullArray[choice]
                //let school = schoolArray.randomElement()!
                let grade = Int.random(in: 9...12)
                
                allAthletes.append(Athlete(f: first, l: last, s: school, g: grade, sf: schoolF))
                
            }
    //        var teams = ["A","B","C"]
    //        var levels = ["VAR", "F/S"]
    //        for school in schoolArray{
    //            for letter in teams{
    //                allAthletes.append(Athlete(f: letter, l: school, s: school, g: 12))
    //        }
    //     }
                 
            
        }
  

}
