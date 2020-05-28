//
//  AddMeetViewController.swift
//  TrackMeet
//
//  Created by Brian Seaver on 5/24/20.
//  Copyright © 2020 clc.seaver. All rights reserved.
//

import UIKit

class AddMeetViewController: UIViewController, UITableViewDelegate,UITableViewDataSource, UIScrollViewDelegate {
    var kHeight : CGFloat = 0.0

    @IBOutlet weak var scrollViewOutlet: UIScrollView!
    var allAthletes = [Athlete]()
    var schools = [String: String]()
    var schoolKeys = [String]()
    var selectedSchools = [String:String]()
    var lev = [String]()
    var eve = ["4x800", "4x100", "3200M", "110HH", "100M", "800M", "4x200", "400M", "300IM", "1600", "200", "4x400", "Long Jump", "Triple Jump", "High Jump", "Pole Vault", "Shot Put", "Discus"]
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
    
    
    override func viewWillAppear(_ animated: Bool) {
        NotificationCenter.default.addObserver(self, selector: #selector(AddMeetViewController.keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        
                 NotificationCenter.default.addObserver(self, selector: #selector(AddMeetViewController.keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
        print(scrollViewOutlet.contentInset.bottom)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
         NotificationCenter.default.removeObserver(self)
    }
    
    @objc func keyboardWillShow(notification: Notification){
         if let keyboardHeight = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue.height {
                print("Notification: Keyboard will show")
            scrollViewOutlet.contentInset.bottom = keyboardHeight
            print(scrollViewOutlet.contentInset.bottom)
            
            
           // view.frame.origin.y -= keyboardHeight
             
             
     }
     }
     
     @objc func keyboardWillHide(notification: Notification){
         print("Notification: Keyboard will hide")
         
        scrollViewOutlet.contentInset.bottom = 0.0
        // view.frame.origin.y += kHeight
         
         
     }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
//         eventAthletes = eventAthletes.sorted(by: {$0.last.localizedCaseInsensitiveCompare($1.last) == .orderedAscending})
        
        individualScoringOutlet.sort(by: {$0.tag < $1.tag})
        relayScoringOutlet.sort(by: {$0.tag < $1.tag})
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
                          //print(selectedPaths)
                          for path in selectedPaths{
                              var selectedSchoolKey = schoolKeys[path.row]
                            selectedSchools[selectedSchoolKey] = schools[selectedSchoolKey]
                          }
                      }
    }
    
    
    @IBAction func submitAction(_ sender: UIButton) {
        print("hit submit button")
        selectedSchools.removeAll()
        getSchools()
        
        
       print(selectedSchools)
        var gen = "M"
        if genderPicker.selectedSegmentIndex == 1{
            gen = "W"
        }
        
        lev.removeAll()
        for b in levelButtonsOutlet{
            if b.isSelected{
                lev.append(b.titleLabel?.text! ?? "")
            }
        }
        
        var eventLeveled = [String]()
        for event in eve{
              for level in lev{
                      eventLeveled.append("\(event) \(level)")
                  }
              }
        
        indP.removeAll()
        var i = 0
        while individualScoringOutlet[i].text != ""{
            if let points = Int(individualScoringOutlet[i].text!){
            indP.append(points)
            }
            else{print("not a number in score field")}
            i+=1
        }
        
        relP.removeAll()
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
        
         meet = Meet(name: meetNameOutlet.text!, date: datePickerOutlet.date, schools: selectedSchools, gender: gen, levels: lev , events: eventLeveled, indPoints: indP, relpoints: relP, athletes: selectedAthletes)
        
        performSegue(withIdentifier: "unwindToMeetsSegue", sender: self)
        //print("\(meet)")
    }
    
//    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
//        print("trying to prepare")
//        if segue.identifier == "toHomeSegue"{
//            let nvc = segue.destination as! HomeViewController
//            nvc.meet = meet
//            nvc.allAthletes = allAthletes
//            print("preparing to go back")
//        }
//    }
    

}
