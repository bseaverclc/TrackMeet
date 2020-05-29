//
//  MeetsViewController.swift
//  TrackMeet
//
//  Created by Brian Seaver on 5/28/20.
//  Copyright © 2020 clc.seaver. All rights reserved.
//

import UIKit

class MeetsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    var meets = [Meet]()
    
    @IBOutlet weak var tableView: UITableView!
    
    var allAthletes = [Athlete]()
    var events = [Event]()
 
    var selectedMeet : Meet?
    var schools = ["Crystal Lake Central": "CLC", "Crystal Lake South": "CLS", "Cary Grove": "CG", "Prairie Ridge": "PR"]
    
    
    override func viewDidLoad() {
               super.viewDidLoad()
               randomizeAthletes()
                sortByName()
               

               // Do any additional setup after loading the view.
           }
    
    func randomizeAthletes(){
        allAthletes.append(Athlete(f: "Owen", l: "Mize", s: "CLC", g: 12, sf: "Crystal Lake Central"))
            allAthletes.append(Athlete(f: "Jakhari", l: "Anderson", s: "CG", g: 12, sf: "Cary-Grove"))
            allAthletes.append(Athlete(f: "Drew", l: "McGinness", s: "CLS", g: 9, sf: "Crystal Lake South"))
        let letters = "abcdefghijklmnopqrstuvwxyz"
        let chars = Array(letters)
        let schoolArray = ["CLC","CG","CLS","PR"]
        let schoolFullArray = ["Crystal Lake Central", "Cary-Grove", "Crystal Lake South", "Prairie Ridge"]
                            
        
        for _ in 3...75{
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
    
    func sortByName(){
        allAthletes.sort(by: {$0.last.localizedCaseInsensitiveCompare($1.last) == .orderedAscending})
    }
    
    
    
   

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toAddMeetSegue"{
            let nvc = segue.destination as! AddMeetViewController
            nvc.allAthletes = allAthletes
            nvc.schools = schools
        }
        if segue.identifier == "toHomeSegue"{
            let nvc = segue.destination as! HomeViewController
            nvc.meet = selectedMeet
            nvc.allAthletes = allAthletes
        }
    
        
    }
    
    
    
    
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        meets.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "myCell", for: indexPath)
      
        let formatter1 = DateFormatter()
        formatter1.dateStyle = .short
        var dateString = formatter1.string(from: meets[indexPath.row].date)
        
        cell.textLabel?.text = dateString
        cell.detailTextLabel?.text = meets[indexPath.row].name
        return cell
        
        
    }
    
  @IBAction func unwind( _ seg: UIStoryboardSegue) {
        print("unwinding to Meets VC")
    let pvc = seg.source as! AddMeetViewController
        if let m = pvc.meet{
        meets.append(m)
            tableView.reloadData()
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selectedMeet = meets[indexPath.row]
        performSegue(withIdentifier: "toHomeSegue", sender: nil)
    }
    


}
