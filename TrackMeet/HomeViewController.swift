//
//  HomeViewController.swift
//  TrackMeet
//
//  Created by Brian Seaver on 5/18/20.
//  Copyright © 2020 clc.seaver. All rights reserved.
//

import UIKit

public protocol DataBackDelegate: class {
    func savePreferences (athletes: [Athlete])
}


class HomeViewController: UIViewController, DataBackDelegate {
    func savePreferences(athletes: [Athlete]) {
        allAthletes = athletes
        print("delegate function called")
    }
    
  
    

    var allAthletes = [Athlete]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        allAthletes.append(Athlete(f: "Owen", l: "Mize", s: "CLC", g: 12))
               allAthletes.append(Athlete(f: "Jakhari", l: "Anderson", s: "CG", g: 12))
               allAthletes.append(Athlete(f: "Drew", l: "McGinness", s: "CLS", g: 9))
        let letters = "abcdefghijklmnopqrstuvwxyz"
        let chars = Array(letters)
        let schoolArray = ["CLC","CG","CLS","PR"]
        
        for _ in 3...75{
            var first = ""
            var last = ""
            for _ in 0...4{
                first.append(String(chars[Int.random(in: 0 ..< chars.count)]))
                last.append(String(chars[Int.random(in: 0 ..< chars.count)]))
            }
            let school = schoolArray.randomElement()!
            let grade = Int.random(in: 9...12)
            
            allAthletes.append(Athlete(f: first, l: last, s: school, g: grade))
            
        }
               allAthletes[0].addEvent(name: "200M", level: "varsity")
               allAthletes[1].addEvent(name: "100M", level: "varsity")
               allAthletes[2].addEvent(name: "100M", level: "varsity")
        allAthletes.sort(by: {$0.last.localizedCaseInsensitiveCompare($1.last) == .orderedAscending})

        // Do any additional setup after loading the view.
    }
    

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        print(segue.description)
        if segue.identifier == "eventsSegue"{
            let nvc = segue.destination as! EventsTableViewController
            nvc.athletes = allAthletes
        }
        else{
            let nvc = segue.destination as! AthletesViewController
            nvc.allAthletes = allAthletes
            nvc.delegate = self
        }
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    
   @IBAction func unwind( _ seg: UIStoryboardSegue) {
   let pvc = seg.source as! AthletesViewController
    allAthletes = pvc.allAthletes
    
    
    }
    

}
