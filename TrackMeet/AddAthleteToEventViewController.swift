//
//  AddAthleteToEventViewController.swift
//  TrackMeet
//
//  Created by Brian Seaver on 5/20/20.
//  Copyright © 2020 clc.seaver. All rights reserved.
//

import UIKit

class AddAthleteToEventViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UITabBarDelegate {

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var tabBarOutlet: UITabBar!
    var lev = ""
        var screenTitle = ""
       // var allAthletes = [Athlete]()
        var eventAthletes = [Athlete]()
        var displayedAthletes = [Athlete]()
    var meet : Meet!
    var schools = [String]()
        
    
        override func viewDidLoad() {
            super.viewDidLoad()
            self.title = screenTitle
            lev = String(screenTitle.suffix(3))
            for a in Data.allAthletes{
                if meet.schools.values.contains(a.school){
                    displayedAthletes.append(a)
                }
            }
          
             schools = [String](meet.schools.values)
            var tabItems = tabBarOutlet.items!
                 var i = 0
                 for school in schools{
                     tabItems[i].title = school
                     i+=1
                 }
           
        }
    
    override func viewWillDisappear(_ animated: Bool) {
      
     selectAthletes()
        if isMovingFromParent{
               performSegue(withIdentifier: "unwindToEventEdit", sender: self)
              }
    }
        
        override func viewDidAppear(_ animated: Bool) {
            tableView.reloadData()
        }
        

        // MARK: - Table view data source

        func numberOfSections(in tableView: UITableView) -> Int {
            // #warning Incomplete implementation, return the number of sections
            return 1
            print("number of sections being called")
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
        
         func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
            print("Did select row at")
            var selectedAthlete = displayedAthletes[indexPath.row]
            if eventAthletes.contains(where: { $0.equals(other: selectedAthlete)}) {
                var alert = UIAlertController(title: "Error!", message: "Athlete already in event", preferredStyle: .alert)
                var action = UIAlertAction(title: "ok", style: .cancel) { (action) in
                    self.tableView.deselectRow(at: indexPath, animated: true)
                }
                alert.addAction(action)
               present(alert, animated: true, completion: nil)
                
            } else {
            
            //print(selectedAthlete.first)
          
            }
        }
    
    func selectAthletes(){
        if let selectedPaths = tableView.indexPathsForSelectedRows{
                 print(selectedPaths)
                 for path in selectedPaths{
                     var selectedAthlete = displayedAthletes[path.row]
                    
                     print("level of selected athletes: \(lev)")
                    selectedAthlete.addEvent(e: Event(name: self.title!, level: lev, meetName: meet.name))
                     eventAthletes.append(selectedAthlete)
                 }
            print("Athletes in the event")
            for ath in eventAthletes{
                for eve in ath.events{
                    print("\(ath.last) \(eve.name)")
                }
            }
             }
    }
        

        
        func tabBar(_ tabBar: UITabBar, didSelect item: UITabBarItem) {
            selectAthletes()
            displayedAthletes = [Athlete]()
            for a in Data.allAthletes{
            
                if item.title == a.school{
                    displayedAthletes.append(a)
                }
            }
            //self.title = item.title
            
            self.tableView.reloadData()
            
        }
       
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier != "unwindToEventEdit"{
            selectAthletes()
        let nvc = segue.destination as! addAthleteViewController
       // nvc.allAthletes = allAthletes
        nvc.eventAthletes = eventAthletes
        nvc.from = screenTitle
        nvc.schools = schools
        nvc.meet = meet
        nvc.lev = lev
        nvc.meetName = meet.name
        }
        
    }

    
    
    }

