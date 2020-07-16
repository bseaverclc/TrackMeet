//
//  AddMeetViewController.swift
//  TrackMeet
//
//  Created by Brian Seaver on 5/24/20.
//  Copyright © 2020 clc.seaver. All rights reserved.
//

import UIKit

class AddMeetViewController: UIViewController, UITableViewDelegate,UITableViewDataSource, UIScrollViewDelegate, UITextFieldDelegate {
    var kHeight : CGFloat = 0.0

    
    @IBOutlet weak var scrollViewOutlet: UIScrollView!
    var allAthletes = [Athlete]()
    var schools = [String: String]()
    var initials = [String]()
    var schoolKeys = [String]()
    var selectedSchools = [String:String]()
    var lev = [String]()
    var eve = ["4x800", "4x100", "3200M", "110HH", "100M", "800M", "4x200", "400M", "300IM", "1600", "200", "4x400", "Long Jump", "Triple Jump", "High Jump", "Pole Vault", "Shot Put", "Discus"]
    var indP = [Int]()
    var relP = [Int]()
    var selectedAthletes = [Athlete]()
    var meet : Meet!
    var meets: [Meet]!
    var selectedMeet : Meet?
    var changeMeet = false
    
    
    @IBOutlet weak var verticalStackViewOutlet: UIStackView!
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
    
    
    
    // Does not work
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
         print("textfield should return")
        for textField in verticalStackViewOutlet.subviews where textField is UITextField {
                   textField.resignFirstResponder()
                   
               }
               return true
    }
    
    // This is not working either.
    // Need to find the right subviews and add delegates to these subviews also
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        for textField in ScoreTableView.subviews where textField is UITextField {
                          textField.resignFirstResponder()
                          
                      }
        print("touchesBegan")
    }
    
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
        
        for textField in verticalStackViewOutlet.subviews {
            print("found a subview")
            if let current = textField as? UITextField{
            current.delegate = self
                print("made textfield delegate")
            }
                  
              }
        
        // sort the scoring textfields
        individualScoringOutlet.sort(by: {$0.tag < $1.tag})
        relayScoringOutlet.sort(by: {$0.tag < $1.tag})
        
        meetNameOutlet.isEnabled = true
        if let meet = selectedMeet{
            changeMeet = true
            // set the name and you can't change it!
            meetNameOutlet.text = meet.name
            meetNameOutlet.isEnabled = false
            meetNameOutlet.textColor = UIColor.lightGray
            
            // set the date
            datePickerOutlet.date = meet.date
            
            // still need to set the schools
            
            // set the gender
            if meet.gender == "M"{
                genderPicker.selectedSegmentIndex = 0
            }
            else{
                genderPicker.selectedSegmentIndex = 1
            }
            
            // set the levels
            for level in meet.levels{
                for button in levelButtonsOutlet{
                    if button.titleLabel?.text == level{
                        button.isSelected = true
                    }
                }
            }
            
            // set the events no happening yet
            
            // set the scores
            var i = 0
            for score in meet.indPoints{
                individualScoringOutlet[i].text = "\(score)"
                i+=1
            }
            
            var j = 0
            for score in meet.relPoints{
                relayScoringOutlet[j].text = "\(score)"
                j+=1
            }
            
            
            
        }
        else{
            meetNameOutlet.becomeFirstResponder()
        }
        
       
        
//         eventAthletes = eventAthletes.sorted(by: {$0.last.localizedCaseInsensitiveCompare($1.last) == .orderedAscending})
        
        
        tableView.flashScrollIndicators()
        ScoreTableView.layer.borderWidth = 10
        
        // Keep a copy of dictionary key
        schoolKeys = Array(schools.keys)
        initials = Array(schools.values)
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
        if selectedMeet?.schools[school] != nil{
            tableView.selectRow(at: indexPath, animated: true, scrollPosition: UITableView.ScrollPosition(rawValue: 0)!)
            //cell.isHighlighted = true
            print("selecting and highlighting cell")
        }
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
    
    func showAlert(errorMessage:String){
        let alert = UIAlertController(title: "Error!", message: errorMessage, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
        alert.addAction(okAction)
        present(alert, animated: true, completion: nil)
        
    }
    
    
    @IBAction func submitAction(_ sender: UIButton) {
        print("hit submit button")
        if !changeMeet{
        for meet in meets{
            if meet.name == meetNameOutlet.text{
                showAlert(errorMessage: "Meet name already in use")
                return
            }
        }
        }
        selectedSchools.removeAll()
        getSchools()
        if selectedSchools.count == 0{
            showAlert(errorMessage: "You have to have at least 1 school")
            return
        }
       //print(selectedSchools)
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
        if lev.count == 0{
            showAlert(errorMessage: "You have to have at least 1 level")
            return
        }
        var beenScored = [Bool]()
        var eventLeveled = [String]()
        for event in eve{
              for level in lev{
                      eventLeveled.append("\(event) \(level)")
                    beenScored.append(false)
                  }
              }
        
        indP.removeAll()
        var i = 0
        while individualScoringOutlet[i].text != ""{
            if let points = Int(individualScoringOutlet[i].text!){
            indP.append(points)
            }
            else{
                showAlert(errorMessage: "Must put some numbers in individual score fields")
                return
                
            }
            i+=1
        }
        
        relP.removeAll()
        i = 0
        while relayScoringOutlet[i].text != ""{
                   if let points = Int(relayScoringOutlet[i].text!){
                   relP.append(points)
                   }
                   else{
                   showAlert(errorMessage: "Must put some numbers in relay score fields")
                    return
            }
            i+=1
               }
        
//        var schoolInits = ""
//        for (_,value) in selectedSchools{
//             schoolInits = value
//        }
//
//        for a in allAthletes{
//            if schoolInits.contains(a.school){
//                selectedAthletes.append(a)
//            }
//        }
        if let oldMeet = selectedMeet{
            for i in 0 ... meets.count - 1{
                if oldMeet.name == meets[i].name{
                    meets.remove(at: i)
                    print("removed meet")
                    break;
                }
            }
        }
        meet = Meet(name: meetNameOutlet.text!, date: datePickerOutlet.date, schools: selectedSchools, gender: gen, levels: lev , events: eventLeveled, indPoints: indP, relpoints: relP,  beenScored: beenScored)
        meets.append(meet)
      //reCalcPoints()
     
        performSegue(withIdentifier: "unwindToMeetsSegue", sender: self)
        //print("\(meet)")
    }
    

    @IBAction func addSchoolAction(_ sender: UIButton) {
        let alert = UIAlertController(title: "Add School", message: "", preferredStyle: .alert)
        
        alert.addTextField(configurationHandler: { (textField) in
            textField.autocapitalizationType = .allCharacters
            textField.placeholder = "Full School Name"
            
        })
        
        alert.addTextField(configurationHandler: { (textField) in
            textField.autocapitalizationType = .allCharacters
                   textField.placeholder = "School Initials"
                   
               })
        
        alert.addTextField(configurationHandler: { (textField) in
      
               textField.placeholder = "Roster csv url"
        })
        
        alert.addAction(UIAlertAction(title: "Add", style: .default, handler: { (updateAction) in
            var badInput = false
            var error = ""
            var fullSchool = alert.textFields![0].text!
            var initSchool = alert.textFields![1].text!
            var csvURL = alert.textFields![2].text!
            if fullSchool == ""{
                error = "Must include school name"
                badInput = true
            }
            else if initSchool == ""{
                error = "Must include school initials"
                badInput = true
            }
            else if self.schoolKeys.contains(fullSchool){
                error = "\(fullSchool) is already in database"
                badInput = true
            }
            else if self.initials.contains(initSchool){
                error = "The initials \(initSchool) are already in use"
                badInput = true
            }
            
            else{
                if csvURL != ""{
                    self.readCSVURL(csvURL: csvURL, fullSchool: fullSchool, initSchool: initSchool)
                    
                }
                        
    

                self.schools[alert.textFields![0].text!] = alert.textFields![1].text!
                
                // Save school to UserDefaults
                let userDefaults = UserDefaults.standard
                do {
                    try userDefaults.setObjects(self.schools, forKey: "schools")
                    print("Saved Schools in Add Meet VC")
                       } catch {
                           print(error.localizedDescription)
                        print("Error saving schools in AddMeet")
                       }
                
                do {
                    try userDefaults.setObjects(self.allAthletes, forKey: "allAthletes")
                               print("Saving Athletes")
                           }
                           catch{
                               print("error saving athletes")
                           }
                
                
                self.schoolKeys.append(alert.textFields![0].text!)
                self.tableView.reloadData()
            }
            if badInput{
            let alert2 = UIAlertController(title: "Error", message: error, preferredStyle: .alert)
            let okAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
            alert2.addAction(okAction)
            self.present(alert2, animated: true, completion: nil)
            }
        }))
    
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        present(alert, animated: true, completion: nil)
    }
    
    
    func readCSVURL(csvURL: String, fullSchool: String, initSchool: String){
        if csvURL != ""{
            if let editRange = csvURL.range(of: "edit"){
            let start = editRange.lowerBound
            var urlCut = csvURL[csvURL.startIndex..<start]
            var urlcompleted = urlCut + "pub?output=csv"
            let url = URL(string: String(urlcompleted))
            
            
//                url of TrackMeet minus edit and adding pub?output=csv
//            let url = URL(string: "https://docs.google.com/spreadsheets/d/1puxn4zdVrYcJwrEksSktMF-McK6VQhguOqnPOLjaSYQ/pub?output=csv")
//            let url = URL(string: "https://docs.google.com/spreadsheets/d/e/2PACX-1vQyjHaFeP9kJpDr_7bl9iF_OzrvMJ3mo-crGQ34DXTRF5Mx7f5NtYfwIPA5c6Ir3ESfVTGAG8Bfbo93/pub?output=csv")
                 guard let requestUrl = url else { fatalError() }
                 // Create URL Request
                 var request = URLRequest(url: requestUrl)
                 // Specify HTTP Method to use
                 request.httpMethod = "GET"
                 // Send HTTP Request
                 let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
                     
                     // Check if Error took place
                     if let error = error {
                         print("Error took place \(error)")
                         return
                     }
                     
                     // Read HTTP Response Status code
                     if let response = response as? HTTPURLResponse {
                         print("Response HTTP Status code: \(response.statusCode)")
                     }
                     
                     // Convert HTTP Response Data to a simple String
                     if let data = data, let dataString = String(data: data, encoding: .utf8) {
                         print("Response data string:\n \(dataString)")
                         let rows = dataString.components(separatedBy: "\r\n")
                         for row in rows{
                            
                             var person = [String](row.components(separatedBy: ","))
                            if person[0] != "First"{
                             var athlete = Athlete(f: person[0], l: person[1], s: initSchool, g: Int(person[2])!, sf: fullSchool)
                            print(athlete)
                            self.allAthletes.append(athlete)
                            }
                             
                         }
                     }
                     

                     
                 }
                 task.resume()
        }
    }
    
    
}
    
        func reCalcPoints(){
//            print("Recalculating points")
//
//            for eventName in eve{
//                var eventAthletes = [Athlete]()
//                for a in allAthletes{
//                    for event in a.events{
//                        if event.meetName == meet.name && eventName == event.name{
//                            eventAthletes.append(a)
//                        }
//                    }
//                }
//                for ea in eventAthletes{
//                    for event in ea.events{
//                       if event.meetName == meet.name && eventName == event.name{
//                            if let place = event.place{
//                                var scoring = [Int]()
//                                if event.name.contains("4x"){
//                                    scoring = meet.relPoints
//                                 }
//                                else{scoring = meet.indPoints}
//                                if place <= scoring.count{
//                                    let ties = checkForTies(place: place, athletes: eventAthletes)
//                                    var points = 0
//                                    if ties != 0{
//                                        for i in place - 1 ..< place - 1 + ties{
//                                            if i > scoring.count - 1{
//                                                points += 0
//                                            }
//                                            else{
//                                                points += scoring[i]
//                                            }
//                                        }
//                                        event.points = Double(points)/Double(ties)
//                                    }
//                                    else{event.points = 0}
//                                    //print("\(a.last) points added = \(event.points)")
//                                    }
//
//                        }
//                    }
//                    }
//                }
//
//
//        }
        
    }
    
    func checkForTies(place: Int, athletes: [Athlete])-> Int{
//           var ties = 0
//           for a in athletes{
//               if let event = a.getEvent(eventName: self.title!, meetName: meet.name){
//                   if event.place == place{
//                       ties += 1
//                   }
//           }
//       }
//           return ties
        return 0
       }
    
}
