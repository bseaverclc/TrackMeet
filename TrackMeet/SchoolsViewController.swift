//
//  SchoolsViewController.swift
//  TrackMeet
//
//  Created by Brian Seaver on 7/13/20.
//  Copyright © 2020 clc.seaver. All rights reserved.
//

import UIKit

class SchoolsViewController: UIViewController,UITableViewDelegate, UITableViewDataSource {

   
    @IBOutlet weak var tableView: UITableView!
    
        
         //weak var delegate: DataBackDelegate?
       
        var header = "All Schools"
        var screenTitle = "All Schools"
        var allAthletes = [Athlete]()
        var eventAthletes = [Athlete]()
        var displayedAthletes = [Athlete]()
        //var selectedAthlete : Athlete!
        var schools = [String:String]()
        var schoolNames = [String]()
        
        
        override func viewDidLoad() {
            super.viewDidLoad()
            tableView.delegate = self
            tableView.dataSource = self
            
            self.title = screenTitle
            for (key,_) in schools{
                schoolNames.append(key)
            }
            schoolNames.sort()
            
            
            print("ViewDidLoad")
           
        }
        
        override func viewDidAppear(_ animated: Bool) {
            print("viewDidAppear")
            tableView.reloadData()
        }
        
//        override func viewWillDisappear(_ animated: Bool) {
//            super.viewWillDisappear(animated)
//            print("view disappearing")
//            if isMovingFromParent{
//            self.delegate?.savePreferences(athletes: allAthletes)
//                print("is moving from parent")
//            }
//        }
        

        // MARK: - Table view data source

         func numberOfSections(in tableView: UITableView) -> Int {
            // #warning Incomplete implementation, return the number of sections
            return 1
        }

         func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
            // #warning Incomplete implementation, return the number of rows
            return schoolNames.count
        }

        
         func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
            let cell = tableView.dequeueReusableCell(withIdentifier: "myCell", for: indexPath)
            let school = schoolNames[indexPath.row]
            cell.textLabel?.text = school
            cell.detailTextLabel?.text = schools[school]
            //print(athlete.grade)
            return cell
        }
        
        func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
            return true
        }
        
        func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
            var blankText = false
            var blankAlert = UIAlertController()
            let delete = UITableViewRowAction(style: .destructive, title: "Delete") { (action, indexPath) in
                var selected = self.schoolNames[indexPath.row]
                self.schoolNames.remove(at: indexPath.row) // remove from array
                self.schools.removeValue(forKey: selected) // remove from dictionary
                // Still need to remove all athletes from this school
                tableView.deleteRows(at: [indexPath], with: .fade)
            }

            let edit = UITableViewRowAction(style: .normal, title: "Edit") { (action, indexPath) in
                let alert = UIAlertController(title: "", message: "Edit School", preferredStyle: .alert)
                    alert.addTextField(configurationHandler: { (textField) in
                         textField.autocapitalizationType = .allCharacters
                        textField.text = self.schoolNames[indexPath.row]
                        
                    })
                alert.addTextField(configurationHandler: { (textField) in
                     textField.autocapitalizationType = .allCharacters
                    textField.text = self.schools[self.schoolNames[indexPath.row]]
                    
                })
              
                    alert.addAction(UIAlertAction(title: "Update", style: .default, handler: { (updateAction) in
                        if alert.textFields![0].text! != "" && alert.textFields![1].text! != ""{
                            
                        self.schools.removeValue(forKey: self.schoolNames[indexPath.row]) // remove old from Dict
                        self.schools[alert.textFields![0].text!] = alert.textFields![1].text! // add new to dict
                        self.schoolNames[indexPath.row] = alert.textFields![0].text! // change Array of schools
                        self.tableView.reloadRows(at: [indexPath], with: .fade)
                        
                        // Still need to change all athletes with old school names
//                        for i in 0 ..< self.allAthletes.count{
//                           if self.displayedAthletes[indexPath.row].equals(other: self.allAthletes[i]){
//                            self.allAthletes[i].first = alert.textFields![0].text!
//                             self.allAthletes[i].last = alert.textFields![1].text!
//                             self.allAthletes[i].school = alert.textFields![2].text!
//                              if let grade = Int(alert.textFields![3].text!){
//                                    self.allAthletes[i].grade = grade}
//                            // save changes to userDefaults
//                            let userDefaults = UserDefaults.standard
//                            do {
//
//                                try userDefaults.setObjects(self.allAthletes, forKey: "allAthletes")
//                                   } catch {
//                                       print(error.localizedDescription)
//                                   }
//                                                  break
//                                              }
//                        }
                      
                        }
                        else{
                            blankText = true
                            print("textfields are blank")
                            blankAlert = UIAlertController(title: "Error!", message: "Can't have blank fields", preferredStyle: .alert)
                                let ok = UIAlertAction(title: "OK", style: .default, handler: nil)
                                blankAlert.addAction(ok)
                            self.present(blankAlert, animated: true, completion: nil)
                        }
                        
                    }))
                
            
                alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
               
                self.present(alert, animated: true) {
                   
                            
                        }
                
            }
                  

            

            edit.backgroundColor = UIColor.blue

            return [delete, edit]
        }
    
        
//        func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//            selectedAthlete = displayedAthletes[indexPath.row]
//            performSegue(withIdentifier: "toAthleteResultsSegue", sender: self)
//        }
      
        
    //     func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
    //
    //        if editingStyle == .delete{
    //
    //            var selected = displayedAthletes[indexPath.row]
    //            for i in 0 ..< allAthletes.count{
    //                if selected.equals(other: allAthletes[i]){
    //                    allAthletes.remove(at: i)
    //                    break
    //                }
    //            }
    //            displayedAthletes.remove(at: indexPath.row)
    //                   tableView.deleteRows(at: [indexPath], with: .fade)
    //        }
    //    }
        
    //     func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    //        var selectedAthlete = displayedAthletes[indexPath.row]
    //        selectedAthlete.events.append(Event(name: self.title!, level: "varsity"))
    //        eventAthletes.append(selectedAthlete)
    //        performSegue(withIdentifier: "backToEventSegue", sender: nil)
    //    }
        
//        override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
//
//
//
//            if segue.identifier == "backToEventSegue"{
//            let nvc = segue.destination as! EventEditViewController
//            nvc.eventAthletes = eventAthletes
//            nvc.allAthletes = allAthletes
//            }
//            else if segue.identifier == "toAddAthleteSegue"{
//                let nvc = segue.destination as! addAthleteViewController
//                nvc.displayedAthletes = displayedAthletes
//                nvc.allAthletes = allAthletes
//                nvc.meet = meet
//                nvc.from = "AthletesVC"
//            }
//            else if segue.identifier == "toAthleteResultsSegue"{
//                let nvc = segue.destination as! AthleteResultsViewController
//                nvc.athlete = selectedAthlete
//            }
//        }
        
        
        
//       @IBAction func unwind( _ seg: UIStoryboardSegue) {
//        let pvc = seg.source as! addAthleteViewController
//        allAthletes = pvc.allAthletes
//        displayedAthletes = pvc.displayedAthletes
//        tableView.reloadData()
//        print("unwinding")
//
//       }

//       func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
//            return header
//        }

    }
