//
//  AddMeetViewController.swift
//  TrackMeet
//
//  Created by Brian Seaver on 5/24/20.
//  Copyright © 2020 clc.seaver. All rights reserved.
//

import UIKit

class AddMeetViewController: UIViewController, UITableViewDelegate,UITableViewDataSource {

    var allAthletes = [Athlete]()
    var schools = [String: String]()
    var schoolKeys = [String]()
    var selectedSchools = [String:String]()
    var lev = [String]()
    var eve = ["4x800 VAR", "4x800 F/S","4x100 VAR","4x100 F/S", "3200M VAR","3200M F/S","110HH VAR","110HH F/S","100M VAR","100M F/S","800 VAR","800 F/S","4x200 VAR","4x200 F/S","400 VAR","400 F/S","300IM VAR","300IM F/S","1600 VAR","1600 F/S","200M VAR","200M F/S", "4x400 VAR","4x400 F/S", "Long Jump VAR", "Long Jump F/S","Triple Jump VAR", "Triple Jump F/S","High Jump VAR", "High Jump F/S","Pole Vault VAR","Pole Vault F/S", "Shot Put VAR","Shot Put F/S", "Discus VAR","Discus F/S"]
    var indP = [Int]()
    var relP = [Int]()
    var selectedAthletes = [Athlete]()
    var meet : Meet!
    
    
    @IBOutlet weak var ScoreTableView: UIStackView!
    
    @IBOutlet weak var meetNameOutlet: UITextField!
    @IBOutlet weak var datePickerOutlet: UIDatePicker!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var genderPicker: UISegmentedControl!
    @IBOutlet var levelButtonsOutlet: [UIButton]!
    @IBOutlet weak var eventsOutlet: UISegmentedControl!
    @IBOutlet var individualScoringOutlet: [UITextField]!
    @IBOutlet var relayScoringOutlet: [UITextField]!
    @IBOutlet weak var eventCodeOutlet: UITextField!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.flashScrollIndicators()
        ScoreTableView.layer.borderWidth = 10
        
        // Keep a copy of dictionary key
        schoolKeys = Array(schools.keys)
        // You may want to sort it
        schoolKeys.sort(by: {$0 < $1})
        // Do any additional setup after loading the view.
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return schools.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "myCell", for: indexPath)
        let school = schoolKeys[indexPath.row]
        cell.textLabel?.text = school
        cell.detailTextLabel?.text = schools[school]
        return cell
        
    }
    
    
    @IBAction func eventsAction(_ sender: UISegmentedControl) {
        if sender.selectedSegmentIndex != 0{
            print("Go to new view controller that allows you to pick events")
        }
    }
    

    @IBAction func levelAction(_ sender: UIButton) {
        if sender.isSelected{
            sender.isSelected = false
        }
        else{
            sender.isSelected = true
        }
    }
    
    func getSchools(){
        if let selectedPaths = tableView.indexPathsForSelectedRows{
                          print(selectedPaths)
                          for path in selectedPaths{
                              var selectedSchoolKey = schoolKeys[path.row]
                            selectedSchools[selectedSchoolKey] = schools[selectedSchoolKey]
                          }
                      }
    }
    
    
    @IBAction func submitAction(_ sender: UIButton) {
        getSchools()
       print(selectedSchools)
        var gen = "M"
        if genderPicker.selectedSegmentIndex == 1{
            gen = "W"
        }
        for b in levelButtonsOutlet{
            if b.isSelected{
                lev.append(b.titleLabel?.text! ?? "")
            }
        }
        var i = 0
        while individualScoringOutlet[i].text != ""{
            if let points = Int(individualScoringOutlet[i].text!){
            indP.append(points)
            }
            else{print("not a number in score field")}
            i+=1
        }
        i = 0
        while relayScoringOutlet[i].text != ""{
                   if let points = Int(relayScoringOutlet[i].text!){
                   relP.append(points)
                   }
                   else{print("not a number in score field")}
            i+=1
               }
        var schoolInits = ""
        for (key,value) in selectedSchools{
             schoolInits = value
        }
        
        for a in allAthletes{
            if schoolInits.contains(a.school){
                selectedAthletes.append(a)
            }
        }
        
         meet = Meet(name: meetNameOutlet.text!, date: datePickerOutlet.date, schools: selectedSchools, gender: gen, levels: lev , events: eve, indPoints: indP, relpoints: relP, athletes: selectedAthletes)
        performSegue(withIdentifier: "toHomeSegue", sender: nil)
        //print("\(meet)")
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toHomeSegue"{
            let nvc = segue.destination as! HomeViewController
            nvc.meet = meet
            nvc.allAthletes = allAthletes
        }
    }
    

}
