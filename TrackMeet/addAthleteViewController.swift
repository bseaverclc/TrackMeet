//
//  addAthleteViewController.swift
//  TrackMeet
//
//  Created by Brian Seaver on 5/18/20.
//  Copyright © 2020 clc.seaver. All rights reserved.
//

import UIKit

class addAthleteViewController: UIViewController {
    var nvc : AthletesViewController!
    var athlete : Athlete!
    var allAthletes = [Athlete]()
    var displayedAthletes = [Athlete]()
    var eventAthletes = [Athlete]()
    var from = ""
    var schools = [String]()
    @IBOutlet weak var schoolOutlet: UISegmentedControl!
    @IBOutlet weak var yearOutlet: UISegmentedControl!
    @IBOutlet weak var lastOutlet: UITextField!
    @IBOutlet weak var firstOutlet: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        schoolOutlet.removeAllSegments()
        for school in schools{
        schoolOutlet.insertSegment(withTitle: school, at: 0, animated: true)
    }
    }
    
    @IBAction func addAction(_ sender: UIButton) {
        if let first = firstOutlet.text, let last = lastOutlet.text, let school = schoolOutlet.titleForSegment(at: schoolOutlet.selectedSegmentIndex), let year = yearOutlet.titleForSegment(at: yearOutlet.selectedSegmentIndex){
            
            
        athlete = Athlete(f: first, l: last, s: school, g: Int(year)!)
            print("Created Athlete")
            allAthletes.insert(athlete, at: 0)
            if from == "AthletesVC"{
            displayedAthletes.insert(athlete, at: 0)
            performSegue(withIdentifier: "unwindToRosters", sender: self)
            }
            else{
                athlete.events.append(Event(name: from, level: "varsity"))
                eventAthletes.append(athlete)
                performSegue(withIdentifier: "unwindToRosters", sender: self)
            }
                
            
            
               
            
        
    }
        
    }
    
//    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
//        let nvc = segue.destination as! AthletesTableViewController
//        nvc.displayedAthletes = displayedAthletes
//        nvc.allAthletes = allAthletes
       // nvc.tableView.reloadData()
//        for a in nvc.displayedAthletes{
//            print(a.first)
//        }
//    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
