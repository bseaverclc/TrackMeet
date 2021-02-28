//
//  AthletesTableViewController.swift
//  TrackMeet
//
//  Created by Brian Seaver on 5/18/20.
//  Copyright © 2020 clc.seaver. All rights reserved.
//

import UIKit
import Firebase

class AthletesViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UITabBarDelegate {

   
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var tabBarOutlet: UITabBar!
    
     weak var delegate: DataBackDelegate?
   
    var header = ""
    var screenTitle = "Rosters"
    //var allAthletes = [Athlete]()
    var eventAthletes = [Athlete]()
    var displayedAthletes = [Athlete]()
    var selectedAthlete : Athlete!
    var schools = [String]()
    var meet : Meet?
    var pvcScreenTitle = ""
   // var meets : [Meet]!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let ref = Database.database().reference().child("athletes")
         ref.observe(.childChanged, with: { (snapshot) in
            print(snapshot)
            Data.allAthletes.sort(by: {$0.last.localizedCaseInsensitiveCompare($1.last) == .orderedAscending})
            
     })
         
        
        
        let fontAttributes2 = [NSAttributedString.Key.font: UIFont.preferredFont(forTextStyle: UIFont.TextStyle.title3)]
        UITabBarItem.appearance().setTitleTextAttributes(fontAttributes2, for: .normal)
         
            
           
        
        self.title = screenTitle
        displayedAthletes = Data.allAthletes
       
        
        if pvcScreenTitle == ""{
        schools = [String](meet!.schools.values)
        }
        var tabItems = tabBarOutlet.items!
             var i = 0
             for school in schools{
                 tabItems[i].title = school
                 i+=1
             }
        tabBar(tabBarOutlet, didSelect: tabBarOutlet.items![0])
        
        print("ViewDidLoad")
       
    }
    
    override func viewDidAppear(_ animated: Bool) {
        print("viewDidAppear")
        tableView.reloadData()
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        print("view disappearing")
        if isMovingFromParent{
            if let del = self.delegate{
        del.savePreferences(athletes: Data.allAthletes)
            }
            else{
                performSegue(withIdentifier: "unwindtoSchoolsSegue", sender: nil)
            }
            print("is moving from parent")
        }
    }
    

    // MARK: - Table view data source

     func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

     func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return displayedAthletes.count
    }

    
     func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "myCell", for: indexPath)
        let athlete = displayedAthletes[indexPath.row]
        cell.textLabel?.text = "\(athlete.last), \(athlete.first)"
        cell.detailTextLabel?.text = "\(athlete.school)"
       
        //print(athlete.grade)
        return cell
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        let delete = UITableViewRowAction(style: .destructive, title: "Delete") { (action, indexPath) in
            let alert = UIAlertController(title: "Are you sure?", message: "Deleting this athlete will also delete any results stored for this athlete", preferredStyle:    .alert)
            let ok = UIAlertAction(title: "Delete", style: .destructive) { (a) in
                var selected = self.displayedAthletes[indexPath.row]
                Data.allAthletes.removeAll { (athlete) -> Bool in
                    athlete.equals(other: selected)
               
                }
                selected.deleteFromFirebase()
                     self.displayedAthletes.remove(at: indexPath.row)
                            tableView.deleteRows(at: [indexPath], with: .fade)
            }
            let cancel = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
            
            alert.addAction(cancel)
            alert.addAction(ok)
            self.present(alert, animated: true, completion: nil)
        }
            
            let edit = UITableViewRowAction(style: .normal, title: "Edit") { (action, indexPath) in
            let alert = UIAlertController(title: "", message: "Edit Athlete", preferredStyle: .alert)
                alert.addTextField(configurationHandler: { (textField) in
                    textField.autocapitalizationType = .allCharacters
                    textField.text = self.displayedAthletes[indexPath.row].first
                    
                })
            alert.addTextField(configurationHandler: { (textField) in
                textField.autocapitalizationType = .allCharacters
                textField.text = self.displayedAthletes[indexPath.row].last
                
            })
            alert.addTextField(configurationHandler: { (textField) in
                textField.autocapitalizationType = .allCharacters
                textField.text = self.displayedAthletes[indexPath.row].school
                
            })
            alert.addTextField(configurationHandler: { (textField) in
                textField.keyboardType = UIKeyboardType.numberPad
                textField.autocapitalizationType = .allCharacters
                textField.text = "\(self.displayedAthletes[indexPath.row].grade)"
                
            })
                alert.addAction(UIAlertAction(title: "Update", style: .default, handler: { (updateAction) in
                  
                    self.displayedAthletes[indexPath.row].first = alert.textFields![0].text!
                    self.displayedAthletes[indexPath.row].last = alert.textFields![1].text!
                    self.displayedAthletes[indexPath.row].school = alert.textFields![2].text!
                    if let grade = Int(alert.textFields![3].text!){
                        self.displayedAthletes[indexPath.row].grade = grade}
                    self.tableView.reloadRows(at: [indexPath], with: .fade)
                    for i in 0 ..< Data.allAthletes.count{
                       if self.displayedAthletes[indexPath.row].equals(other: Data.allAthletes[i]){
                        Data.allAthletes[i].first = alert.textFields![0].text!
                         Data.allAthletes[i].last = alert.textFields![1].text!
                         Data.allAthletes[i].school = alert.textFields![2].text!
                          if let grade = Int(alert.textFields![3].text!){
                                Data.allAthletes[i].grade = grade}
                        
                        // updateFirebase
                        print(Data.allAthletes[i].first)
                        Data.allAthletes[i].updateFirebase()
                        // save changes to userDefaults
                        let userDefaults = UserDefaults.standard
                        do {

                            try userDefaults.setObjects(Data.allAthletes, forKey: "allAthletes")
                               } catch {
                                   print(error.localizedDescription)
                               }
                                              break
                                          }
                    }
                  
                    
                }))
                alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
                self.present(alert, animated: false)
            }

        

        edit.backgroundColor = UIColor.blue

        return [delete, edit]
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selectedAthlete = displayedAthletes[indexPath.row]
        performSegue(withIdentifier: "toAthleteResultsSegue", sender: self)
    }
  
    
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
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        
        
        if segue.identifier == "backToEventSegue"{
        let nvc = segue.destination as! EventEditViewController
        nvc.eventAthletes = eventAthletes
       // nvc.allAthletes = allAthletes
        }
        else if segue.identifier == "toAddAthleteSegue"{
            let nvc = segue.destination as! addAthleteViewController
            nvc.displayedAthletes = displayedAthletes
           // nvc.allAthletes = allAthletes
            if let aMeet = meet{
                nvc.meet = aMeet
            }
            else{
                nvc.meet = Meet(name: "Blank", date: Date(), schools: ["Full School":schools[0]], gender: "M", levels: ["VAR"], events: ["none"], indPoints: [Int](), relpoints: [Int](), beenScored: [false], coach: "", manager: "")
            }
            nvc.from = "AthletesVC"
        }
        else if segue.identifier == "toAthleteResultsSegue"{
            let nvc = segue.destination as! AthleteResultsViewController
            nvc.athlete = selectedAthlete
           // nvc.meets = meets
            nvc.meet = meet
        }
    }
    
    func tabBar(_ tabBar: UITabBar, didSelect item: UITabBarItem) {
        displayedAthletes = [Athlete]()
        for a in Data.allAthletes{
        
            if item.title == a.school{
                displayedAthletes.append(a)
            }
        }
        //self.title = item.title
        header = item.title!
        self.tableView.reloadData()
        
    }
    
   @IBAction func unwind( _ seg: UIStoryboardSegue) {
    let pvc = seg.source as! addAthleteViewController
   // allAthletes = pvc.allAthletes
    displayedAthletes = pvc.displayedAthletes
    tableView.reloadData()
    print("unwinding")
    
   }

   func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return header
    }

}
