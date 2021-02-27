//
//  AthleteResultsViewController.swift
//  TrackMeet
//
//  Created by Brian Seaver on 5/22/20.
//  Copyright © 2020 clc.seaver. All rights reserved.
//

import UIKit

class AthleteResultsViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    var athlete : Athlete!
    //var meets : [Meet]!
    var meet : Meet?
    
    @IBOutlet weak var eventLabel: UILabel!
    
    @IBOutlet weak var markLabel: UILabel!
    
    @IBOutlet weak var meetLabel: UILabel!
    
    @IBOutlet weak var tableView: UITableView!
    
    @IBOutlet weak var dateLabel: UILabel!
    var thisMeetEvents = [Event]()
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        thisMeetEvents = [Event]()
        if let m = meet{
            for e in athlete.events{
                if e.meetName == m.name{
                    thisMeetEvents.append(e)
                }
            }
            print(thisMeetEvents.count)
            return thisMeetEvents.count
        }
        else{
        return athlete.events.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "myCell", for: indexPath) as! AthleteResultsTableViewCell
        
        if let m = meet{
            cell.eventOutlet.text =  thisMeetEvents[indexPath.row].name
            cell.markOutlet.text = thisMeetEvents[indexPath.row].markString
            cell.meetOutlet.text = thisMeetEvents[indexPath.row].meetName
            if let place = thisMeetEvents[indexPath.row].place{
            cell.placeOutlet.text = "place: \(place)"
            }
            else{
                cell.placeOutlet.text = ""
            }
        
            print("single meet")
            let formatter = DateFormatter()
            formatter.dateStyle = .short
            let dateString = formatter.string(from: m.date)
            cell.dateOutlet.text = dateString
        }
        else{
            cell.eventOutlet.text =  athlete.events[indexPath.row].name
            cell.markOutlet.text = athlete.events[indexPath.row].markString
            cell.meetOutlet.text = athlete.events[indexPath.row].meetName
            for m in Data.meets{
            if m.name == athlete.events[indexPath.row].meetName{
                let formatter = DateFormatter()
                formatter.dateStyle = .short
                let dateString = formatter.string(from: m.date)
                cell.dateOutlet.text = dateString
                
            }
        }
        }
        
        
        return cell
    }
    
  
    

    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "\(athlete.first) \(athlete.last)"
        

        // Do any additional setup after loading the view.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
