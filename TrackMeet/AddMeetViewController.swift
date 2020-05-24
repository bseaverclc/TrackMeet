//
//  AddMeetViewController.swift
//  TrackMeet
//
//  Created by Brian Seaver on 5/24/20.
//  Copyright © 2020 clc.seaver. All rights reserved.
//

import UIKit

class AddMeetViewController: UIViewController, UITableViewDelegate,UITableViewDataSource {

    

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

        // Do any additional setup after loading the view.
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 4
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "myCell", for: indexPath)
        cell.textLabel?.text = "Crystal Lake Central"
        cell.detailTextLabel?.text = "CLC"
        return cell
        
    }
    
    
    @IBAction func eventsAction(_ sender: UISegmentedControl) {
        if sender.selectedSegmentIndex != 0{
            print("Go to new view controller that allows you to pick events")
        }
    }
    



}
