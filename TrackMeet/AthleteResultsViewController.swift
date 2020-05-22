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
    
    @IBOutlet weak var tableView: UITableView!
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return athlete.events.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "myCell", for: indexPath)
            cell.textLabel?.text =  athlete.events[indexPath.row].name
            cell.detailTextLabel?.text = athlete.events[indexPath.row].markString
        
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
