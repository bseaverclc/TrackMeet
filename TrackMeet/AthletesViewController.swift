//
//  AthletesTableViewController.swift
//  TrackMeet
//
//  Created by Brian Seaver on 5/18/20.
//  Copyright © 2020 clc.seaver. All rights reserved.
//

import UIKit

class AthletesViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UITabBarDelegate {

   
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var tabBarOutlet: UITabBar!
    
     weak var delegate: DataBackDelegate?
   
    var header = "All Schools"
    var screenTitle = "Rosters"
    var allAthletes = [Athlete]()
    var eventAthletes = [Athlete]()
    var displayedAthletes = [Athlete]()
    var selectedAthlete : Athlete!
    var schools = [String]()
    var meet : Meet!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let fontAttributes2 = [NSAttributedString.Key.font: UIFont.preferredFont(forTextStyle: UIFont.TextStyle.title3)]
        UITabBarItem.appearance().setTitleTextAttributes(fontAttributes2, for: .normal)
         
            
           
        
        self.title = screenTitle
        displayedAthletes = allAthletes
        
        schools = [String](meet.schools.values)
        var tabItems = tabBarOutlet.items!
             var i = 0
             for school in schools{
                 tabItems[i].title = school
                 i+=1
             }
        
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
        self.delegate?.savePreferences(athletes: allAthletes)
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
            var selected = self.displayedAthletes[indexPath.row]
       
            self.displayedAthletes.remove(at: indexPath.row)
                   tableView.deleteRows(at: [indexPath], with: .fade)
        }

        let edit = UITableViewRowAction(style: .normal, title: "Edit") { (action, indexPath) in
            let alert = UIAlertController(title: "", message: "Edit Athlete", preferredStyle: .alert)
                alert.addTextField(configurationHandler: { (textField) in
                    textField.text = self.displayedAthletes[indexPath.row].first
                    
                })
            alert.addTextField(configurationHandler: { (textField) in
                textField.text = self.displayedAthletes[indexPath.row].last
                
            })
            alert.addTextField(configurationHandler: { (textField) in
                textField.text = self.displayedAthletes[indexPath.row].school
                
            })
            alert.addTextField(configurationHandler: { (textField) in
                textField.text = "\(self.displayedAthletes[indexPath.row].grade)"
                
            })
                alert.addAction(UIAlertAction(title: "Update", style: .default, handler: { (updateAction) in
                  
                    self.displayedAthletes[indexPath.row].first = alert.textFields![0].text!
                    self.displayedAthletes[indexPath.row].last = alert.textFields![1].text!
                    self.displayedAthletes[indexPath.row].school = alert.textFields![2].text!
                    if let grade = Int(alert.textFields![3].text!){
                        self.displayedAthletes[indexPath.row].grade = grade}
                    self.tableView.reloadRows(at: [indexPath], with: .fade)
                    for i in 0 ..< self.allAthletes.count{
                       if self.displayedAthletes[indexPath.row].equals(other: self.allAthletes[i]){
                        self.allAthletes[i].first = alert.textFields![0].text!
                         self.allAthletes[i].last = alert.textFields![1].text!
                         self.allAthletes[i].school = alert.textFields![2].text!
                          if let grade = Int(alert.textFields![3].text!){
                                self.allAthletes[i].grade = grade}
                        
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
        nvc.allAthletes = allAthletes
        }
        else if segue.identifier == "toAddAthleteSegue"{
            let nvc = segue.destination as! addAthleteViewController
            nvc.displayedAthletes = displayedAthletes
            nvc.allAthletes = allAthletes
            nvc.nvc = self
            nvc.from = "AthletesVC"
        }
        else if segue.identifier == "toAthleteResultsSegue"{
            let nvc = segue.destination as! AthleteResultsViewController
            nvc.athlete = selectedAthlete
        }
    }
    
    func tabBar(_ tabBar: UITabBar, didSelect item: UITabBarItem) {
        displayedAthletes = [Athlete]()
        for a in allAthletes{
        
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
    allAthletes = pvc.allAthletes
    displayedAthletes = pvc.displayedAthletes
    tableView.reloadData()
    print("unwinding")
    
   }

   func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return header
    }

}