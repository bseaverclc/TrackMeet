//
//  ViewController.swift
//  TrackMeet
//
//  Created by Brian Seaver on 5/17/20.
//  Copyright © 2020 clc.seaver. All rights reserved.
//

import UIKit

extension UIResponder {
    func findParentTableViewCell () -> UITableViewCell? {
        var parent: UIResponder = self
        while let next = parent.next {
            if let tableViewCell = parent as? UITableViewCell {
                return tableViewCell
            }
            parent = next
        }
        return nil
    }
}

extension UITableView {
    // allow to move tableview up when keyboard shows
    func setBottomInset(to value: CGFloat) {
        let edgeInset = UIEdgeInsets(top: 0, left: 0, bottom: value, right: 0)

        self.contentInset = edgeInset
        self.scrollIndicatorInsets = edgeInset
    }
}

class EventEditViewController: UIViewController, UITableViewDelegate,UITableViewDataSource, UINavigationControllerDelegate, UITabBarDelegate {
    
    @IBOutlet weak var processOutlet: UIButton!
    
    
    var selectedRow : Int!
    
    @IBOutlet weak var tableViewOutlet: UITableView!
    var tabBarY : CGFloat!
    var fieldEvents = ["Long Jump", "Triple Jump", "High Jump", "Pole Vault", "Shot Put", "Discus"]
    var fieldEventsLev = [String]()
    var meet : Meet!
    var sections = false
    //var allAthletes = [Athlete]()
    var eventAthletes = [Athlete]()
    var heat1 = [Athlete]()
    var heat2 = [Athlete]()
    var screenTitle = ""
    
    @IBOutlet weak var tabBarOutlet: UITabBar!
    
    @objc func keyboardWillShow(notification: Notification){
        if let keyboardHeight = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue.height {
               print("Notification: Keyboard will show")
               tableViewOutlet.setBottomInset(to: keyboardHeight)
            
            tabBarOutlet.frame.origin.y = tabBarY - keyboardHeight
    }
    }
    
    @objc func keyboardWillHide(notification: Notification){
        print("Notification: Keyboard will hide")
        tabBarOutlet.frame.origin.y = tabBarY
        tableViewOutlet.setBottomInset(to: 0.0)
        
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
             NotificationCenter.default.addObserver(self, selector: #selector(EventEditViewController.keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
           
                    NotificationCenter.default.addObserver(self, selector: #selector(EventEditViewController.keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
        if (self.title!.contains("100M")  || (self.title!.contains("200") && !(self.title!.contains("3200M"))) || self.title!.contains("400M")) {
                tableViewOutlet.isEditing = true
               sections = true
           }
       }
       
       override func viewWillDisappear(_ animated: Bool) {
            super.viewWillDisappear(animated)
        print("editEvent is disappearing")
        //calcPoints()
        let userDefaults = UserDefaults.standard
                         do {
                                 try userDefaults.setObjects(Data.allAthletes, forKey: "allAthletes")
                                } catch {
                                    print(error.localizedDescription)
                                }
           if isMovingFromParent{
           performSegue(withIdentifier: "unwindToEventsSegue", sender: self)
           }

              NotificationCenter.default.removeObserver(self)
           tabBarOutlet.frame.origin.y = tabBarY
       }
       
       override func viewDidAppear(_ animated: Bool) {
           tabBarY = tabBarOutlet.frame.origin.y
           
       }
       
       override func viewDidLoad() {
           super.viewDidLoad()
        eventAthletes = [Athlete]()
           if meet.beenScored[selectedRow]{
                processOutlet.setTitle("Processed", for: .normal)
               processOutlet.backgroundColor = UIColor.green
           }
           else{
               processOutlet.setTitle("Process Event", for: .normal)
               processOutlet.backgroundColor = UIColor.lightGray
           }
          
           
           let fontAttributes2 = [NSAttributedString.Key.font: UIFont.preferredFont(forTextStyle: UIFont.TextStyle.title3)]
           UITabBarItem.appearance().setTitleTextAttributes(fontAttributes2, for: .normal)
        
//           for lev in meet.levels{
//           for event in fieldEvents{
//               fieldEventsLev.append("\(event) \(lev)")
//               }
//           }
           
           self.title = screenTitle
           for a in Data.allAthletes{
                     for e in a.events{
                       if e.name == screenTitle && e.meetName == meet.name{
                           switch e.heat{
                           //case 0: eventAthletes.append(a)
                           case 1: heat1.append(a)
                           case 2: heat2.append(a)
                           default: eventAthletes.append(a)
                           }
                             
                         }
                     }
                 }
           sortByMark()
           sortByPlace()
           tableViewOutlet.reloadData()
           print("eventEditVDL")
    
         
           // Do any additional setup after loading the view.
       }
    
    // tableview functions
    func numberOfSections(in tableView: UITableView) -> Int {
        if sections{return 3}
        else{ return 1}
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if sections{
        if section == 0{return "Heat 1"}
        else if section == 1{return "Heat 2"}
        else{ return "Open"}
        }
        else{return self.title}
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if sections{
        if section == 0{return heat1.count}
        else if section == 1 {return heat2.count}
        else{ return eventAthletes.count}
        }
        
        else{return eventAthletes.count}
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
           // customized cell
           let cell = tableView.dequeueReusableCell(withIdentifier: "myCell") as! TimeTableViewCell
         
          
           
           var currentAthletes = [Athlete]()
           if !sections{ currentAthletes = eventAthletes}
           else{ if indexPath.section == 0 {currentAthletes = heat1}
           else if indexPath.section == 1 {currentAthletes = heat2}
           else {currentAthletes = eventAthletes}
           }
           
           for event in currentAthletes[indexPath.row].events{
            
               if event.name == title  && event.meetName == meet.name{
                   if let place = event.place{
                    if !meet.beenScored[selectedRow]{
                   cell.configure(text: event.markString, placeholder: "Mark", placeText: "\(place)")
                   }
                    else{
                        cell.configure(text: event.markString, placeholder: "Mark", placeText: "\(place)", pointsText: String(event.points))
                    }
                   }
                   else{
                       cell.configure(text: event.markString, placeholder: "Mark")
                       
                   }
               }
           }
           
           let athlete = currentAthletes[indexPath.row]
           cell.nameOutlet.text = "\(athlete.last), \(athlete.first)"
           cell.schoolOutlet.text = athlete.school
           cell.timeOutlet.tag = indexPath.row
           cell.placeOutlet.tag = indexPath.row
           return cell
       }
    
    func tableView(_ tableView: UITableView, moveRowAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
        meet.beenScored[selectedRow] = false
        processOutlet.backgroundColor = UIColor.lightGray
        processOutlet.setTitle("Process Event", for: .normal)
        
        var movingAthlete: Athlete!
        if sections{
         if (sourceIndexPath != destinationIndexPath ) {
            let sectionFrom = sourceIndexPath.section
            let sectionTo = destinationIndexPath.section
           
            if sectionFrom == 0{
                movingAthlete = heat1[sourceIndexPath.row]
                heat1.remove(at: sourceIndexPath.row)
            }
            else if sectionFrom == 1 {
                movingAthlete = heat2[sourceIndexPath.row]
                heat2.remove(at: sourceIndexPath.row)
            }
            else{
                movingAthlete = eventAthletes[sourceIndexPath.row]
                eventAthletes.remove(at: sourceIndexPath.row)
            }
            
            if sectionTo == 0 {
                heat1.insert(movingAthlete, at: destinationIndexPath.row)
                movingAthlete.getEvent(eventName: screenTitle, meetName: meet.name)?.heat = 1
                
            }
            else if sectionTo == 1 {
                heat2.insert(movingAthlete, at: destinationIndexPath.row)
                movingAthlete.getEvent(eventName: screenTitle, meetName: meet.name
                    )?.heat = 2
            }
            
            else {eventAthletes.insert(movingAthlete, at: destinationIndexPath.row)
                movingAthlete.getEvent(eventName: screenTitle, meetName: meet.name)?.heat = 0
            }
            }
            
            
        }
        else{
            movingAthlete = eventAthletes[sourceIndexPath.row]
            eventAthletes.remove(at: sourceIndexPath.row)
            eventAthletes.insert(movingAthlete, at: destinationIndexPath.row)
            
        }
        
        tableView.reloadData()


           }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print(indexPath.row)
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete{
            meet.beenScored[selectedRow] = false
            processOutlet.backgroundColor = UIColor.lightGray
            processOutlet.setTitle("Process Event", for: .normal)
            if sections{
            var sec = indexPath.section
            
            switch sec{
            case 0:
                heat1[indexPath.row].events.removeAll { (e) -> Bool in
                    e.name == self.title && e.meetName == self.meet.name
                }
                heat1.remove(at: indexPath.row)
                tableView.deleteRows(at: [indexPath], with: .fade)
            case 1:
                heat2[indexPath.row].events.removeAll { (e) -> Bool in
                    e.name == self.title && e.meetName == self.meet.name
                }
                heat2.remove(at: indexPath.row)
                tableView.deleteRows(at: [indexPath], with: .fade)
            default:
                eventAthletes[indexPath.row].events.removeAll { (e) -> Bool in
                    e.name == self.title && e.meetName == self.meet.name
                }
                eventAthletes.remove(at: indexPath.row)
                tableView.deleteRows(at: [indexPath], with: .fade)
            }
            }
            else{
                eventAthletes[indexPath.row].events.removeAll { (e) -> Bool in
                                   e.name == self.title && e.meetName == self.meet.name
                               }
                               eventAthletes.remove(at: indexPath.row)
                               tableView.deleteRows(at: [indexPath], with: .fade)
                
            }

            
        }
    }
  
    // Actions
    @IBAction func timeAction(_ sender: UITextField) {
         //print(sender.tag)
        // print(sender.text)
//         var indexPath = IndexPath(row: sender.tag, section: 0)
//         var cell = tableViewOutlet.cellForRow(at: indexPath) as! TimeTableViewCell
        
        print("time action happening")
        
        meet.beenScored[selectedRow] = false
        processOutlet.backgroundColor = UIColor.lightGray
        processOutlet.setTitle("Process Event", for: .normal)
        
         var editingArray : [Athlete]!
         guard let cell2 = sender.findParentTableViewCell (),
             let indexPath2 = tableViewOutlet.indexPath(for: cell2) else {
                 print("This textfield is not in the tableview!")
                 return
         }
        if let mark = sender.text{
        
       if sections{
               if indexPath2.section == 0{
                   for event in heat1[indexPath2.row].events{
                    if event.name == title && event.meetName == meet.name{
                            
                           event.markString = mark
                           print("section 0 set mark")
                            
                        }
                    }
                   
               }
               else if indexPath2.section == 1{
                   for event in heat2[indexPath2.row].events{
                        if event.name == title && event.meetName == meet.name{
                            
                   event.markString = mark
                            print("section 1 set mark")
                            
                        }
                    }
               }
               else{
                   for event in eventAthletes[indexPath2.row].events{
                        if event.name == title && event.meetName == meet.name{
                           
                   event.markString = mark
                            print("sections but no section set mark")
                            
                        }
                    }
                   
               }
           }
       else{
           for event in eventAthletes[indexPath2.row].events{
               if event.name == title && event.meetName == meet.name{
                  
                       event.markString = mark
                       print("no sections set mark")
                                
                            }
                        }
            }
                       
                   
       }
        
    }
    
    @IBAction func placeAction(_ sender: UITextField) {
        
        meet.beenScored[selectedRow] = false
        processOutlet.backgroundColor = UIColor.lightGray
        processOutlet.setTitle("Process Event", for: .normal)
        var editingArray : [Athlete]!
        print(sender.tag)
        guard let cell2 = sender.findParentTableViewCell (),
            let indexPath2 = tableViewOutlet.indexPath(for: cell2) else {
                print("This textfield is not in the tableview!")
                return
        }
        //print("The indexPath is \(indexPath2)")
      
                //var indexPath = IndexPath(row: sender.tag, section: 0)
        var place = sender.text!
            
        if sections{
            if indexPath2.section == 0{
                for event in heat1[indexPath2.row].events{
                     if event.name == title && event.meetName == meet.name{
                         if let intPlace = Int(place){
                event.place = intPlace
                         }
                         else{
                            sender.text = ""
                            event.place = nil}
                     }
                 }
                
            }
            else if indexPath2.section == 1{
                for event in heat2[indexPath2.row].events{
                     if event.name == title && event.meetName == meet.name{
                         if let intPlace = Int(place){
                event.place = intPlace
                         }
                        else{
                        sender.text = ""
                        event.place = nil}
                     }
                 }
            }
            else{
                for event in eventAthletes[indexPath2.row].events{
                     if event.name == title && event.meetName == meet.name{
                         if let intPlace = Int(place){
                event.place = intPlace
                         }
                        else{
                        sender.text = ""
                        event.place = nil}
                     }
                 }
                
            }
        }
        else{
        for event in eventAthletes[indexPath2.row].events{
            if event.name == title && event.meetName == meet.name{
                if let intPlace = Int(place){
                    event.place = intPlace
                             }
                else{
                sender.text = ""
                event.place = nil}
                         }
                     }
            }
                    
                
    
    }
    
    @IBAction func processEventAction(_ sender: UIButton) {
           processOutlet.backgroundColor = UIColor.green
           processOutlet.setTitle("Processed", for: .normal)
        meet.beenScored[selectedRow] = true
           calcPoints()
           // save to userdefaults
        
              let userDefaults = UserDefaults.standard
              do {
                      try userDefaults.setObjects(Data.allAthletes, forKey: "allAthletes")
                     } catch {
                         print(error.localizedDescription)
                     }
       // save to firebase
        for a in eventAthletes{
            a.updateFirebase()
        }

       }
    
    @IBAction func tapAction(_ sender: UITapGestureRecognizer) {
        view.endEditing(true)
    }
   
  // Sorting Functions
    func sortBySchool(){
        eventAthletes = eventAthletes.sorted { (struct1, struct2) -> Bool in
                        if (struct1.school.lowercased() != struct2.school.lowercased()) { // if it's not the same section sort by section
                            return struct1.school < struct2.school
                        } else { // if it the same section sort by order.
                            return struct1.last.lowercased() < struct2.last.lowercased()
                        }
                    }
        heat1 = heat1.sorted { (struct1, struct2) -> Bool in
            if (struct1.school.lowercased() != struct2.school.lowercased()) { // if it's not the same section sort by section
                return struct1.school < struct2.school
            } else { // if it the same section sort by order.
                return struct1.last.lowercased() < struct2.last.lowercased()
            }
        }
        heat2 = heat2.sorted { (struct1, struct2) -> Bool in
            if (struct1.school.lowercased() != struct2.school.lowercased()) { // if it's not the same section sort by section
                return struct1.school < struct2.school
            } else { // if it the same section sort by order.
                return struct1.last.lowercased() < struct2.last.lowercased()
            }
        }
                    print("Done sorting by school")
                    
                   
                    
        //            eventAthletes.sort(by: {$0.school.localizedCaseInsensitiveCompare($1.school) == .orderedAscending && $0.last.localizedCaseInsensitiveCompare($1.last) == .orderedAscending})
        
    }
    
    func sortByName(){
        eventAthletes = eventAthletes.sorted(by: {$0.last.localizedCaseInsensitiveCompare($1.last) == .orderedAscending})
        heat1 = heat1.sorted(by: {$0.last.localizedCaseInsensitiveCompare($1.last) == .orderedAscending})
                 
        heat2 = heat2.sorted(by: {$0.last.localizedCaseInsensitiveCompare($1.last) == .orderedAscending})
        print("sorting by name")
    }
    
    func sortByPlace(){
        eventAthletes = eventAthletes.sorted { (lhs, rhs) -> Bool in
            let a = lhs.getEvent(eventName: self.title!, meetName: meet.name
                )?.place
            let b = rhs.getEvent(eventName: self.title!, meetName: meet.name)?.place
                     switch (a ,b) {
                       case let(a?, b?): return a < b // Both lhs and rhs are not nil
                       case (nil, _): return false    // Lhs is nil
                       case (_?, nil): return true    // Lhs is not nil, rhs is nil
                       }
                   }
        heat1 = heat1.sorted { (lhs, rhs) -> Bool in
        let a = lhs.getEvent(eventName: self.title!, meetName: meet.name
            )?.place
        let b = rhs.getEvent(eventName: self.title!, meetName: meet.name)?.place
                 switch (a ,b) {
                   case let(a?, b?): return a < b // Both lhs and rhs are not nil
                   case (nil, _): return false    // Lhs is nil
                   case (_?, nil): return true    // Lhs is not nil, rhs is nil
                   }
               }
        
        heat2 = heat2.sorted { (lhs, rhs) -> Bool in
        let a = lhs.getEvent(eventName: self.title!, meetName: meet.name
            )?.place
        let b = rhs.getEvent(eventName: self.title!, meetName: meet.name)?.place
                 switch (a ,b) {
                   case let(a?, b?): return a < b // Both lhs and rhs are not nil
                   case (nil, _): return false    // Lhs is nil
                   case (_?, nil): return true    // Lhs is not nil, rhs is nil
                   }
               }
            print("sorting by place")
            
        
    }
    
    func sortByMark(){
        eventAthletes = eventAthletes.sorted { (lhs, rhs) -> Bool in
            var a = lhs.getEvent(eventName: self.title!, meetName: meet.name)?.markString
            var b = rhs.getEvent(eventName: self.title!, meetName: meet.name
                )?.markString
                       
                                        switch (a ,b) {
                                          case ("", _): return false    // Lhs is empty
                                          case (_?, ""): return true    // Lhs is not nil, rhs is empty
                                        default:
                                           while a!.count < b!.count{a = "0\(a!)"
                                               print(a!)
                                           }
                                           while b!.count < a!.count{b = "0\(b!)"
                                               print(b!)
                                           }
                                           if fieldEventsLev.contains(self.title!){
                                           return a! > b!
                                           }
                                           else{return a! < b!}
                                          }
                                      }
        heat1 = heat1.sorted { (lhs, rhs) -> Bool in
        var a = lhs.getEvent(eventName: self.title!, meetName: meet.name)?.markString
        var b = rhs.getEvent(eventName: self.title!, meetName: meet.name
            )?.markString
                   
                                    switch (a ,b) {
                                      case ("", _): return false    // Lhs is empty
                                      case (_?, ""): return true    // Lhs is not nil, rhs is empty
                                    default:
                                       while a!.count < b!.count{a = "0\(a!)"
                                           print(a!)
                                       }
                                       while b!.count < a!.count{b = "0\(b!)"
                                           print(b!)
                                       }
                                       if fieldEventsLev.contains(self.title!){
                                       return a! > b!
                                       }
                                       else{return a! < b!}
                                      }
                                  }
        heat2 = heat2.sorted { (lhs, rhs) -> Bool in
        var a = lhs.getEvent(eventName: self.title!, meetName: meet.name)?.markString
        var b = rhs.getEvent(eventName: self.title!, meetName: meet.name
            )?.markString
                   
                                    switch (a ,b) {
                                      case ("", _): return false    // Lhs is empty
                                      case (_?, ""): return true    // Lhs is not nil, rhs is empty
                                    default:
                                       while a!.count < b!.count{a = "0\(a!)"
                                           print(a!)
                                       }
                                       while b!.count < a!.count{b = "0\(b!)"
                                           print(b!)
                                       }
                                       if fieldEventsLev.contains(self.title!){
                                       return a! > b!
                                       }
                                       else{return a! < b!}
                                      }
                                  }
                   print("sorting by mark")
    }
    
    func tabBar(_ tabBar: UITabBar, didSelect item: UITabBarItem) {
       
        if item.title == "School"{
            sortBySchool()
        }
        else if item.title == "Name"{
             sortByName()
        }
        
        else if item.title == "Place"{
            sortByPlace()
        }
        else if item.title == "Mark"{
             sortByMark()
           
        }
        
        
        tableViewOutlet.reloadData()
        
      
        
        
    }
    
    // support functions
    func calcPoints(){
            print("starting to calculate points.  Ind points \(meet.indPoints)")
            
            var scoringAthletes = [Athlete]()
            for a in heat1{
                scoringAthletes.append(a)
            }
            for a in heat2{
                scoringAthletes.append(a)
            }
        for a in eventAthletes{
            scoringAthletes.append(a)
        }
            for a in scoringAthletes{
                
                print("Scoring \(a.last)")
                if let event = a.getEvent(eventName: self.title!, meetName: meet.name){
                    if let place = event.place{
                   // print("event.meetName \(event.meetName) meet.name \(meet.name)")
                    if event.meetName == meet.name{
                    var scoring = [Int]()
                    if event.name.contains("4x"){
                        scoring = meet.relPoints
                    }
                    else{scoring = meet.indPoints}
                    if place <= scoring.count{
                        let ties = checkForTies(place: place, athletes: scoringAthletes)
                        var points = 0
                        if ties != 0{
                            for i in place - 1 ..< place - 1 + ties{
                                if i > scoring.count - 1{
                                    points += 0
                                }
                                else{
                                    points += scoring[i]
                                    print("Added some points")
                                }
                            }
                            event.points = Double(points)/Double(ties)
                            
                        }
                        else{event.points = 0}  // if ties somehow = 0
                        
                        print("\(a.last) points added = \(event.points)")
                        for blah in a.events{
                            print("\(a.last) \(blah.name) \(blah.points)")
                        }
                        
                        }
                    else{
                        event.points = 0  // if place is not for a score
                        }

            }
        }
                        // if there is no place
                    else{
                        event.points = 0
                    }
                }
        }
       
        
        tableViewOutlet.reloadData()
    }
    
    func checkForTies(place: Int, athletes: [Athlete])-> Int{
        var ties = 0
        for a in athletes{
            if let event = a.getEvent(eventName: self.title!, meetName: meet.name){
                if event.place == place{
                    ties += 1
                }
        }
    }
        return ties
    }
   
    //segue Functions
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
           print("prepare for segue")
           if segue.identifier == "unwindToEventsSegue"{
               // save to userdefaults
                  let userDefaults = UserDefaults.standard
                  do {
                          try userDefaults.setObjects(Data.allAthletes, forKey: "allAthletes")
                         } catch {
                             print(error.localizedDescription)
                         }
               
              //calcPoints()
              // print("Calculated Points")
           }
           else {
           
           
           let nvc = segue.destination as! AddAthleteToEventViewController
          // nvc.allAthletes = allAthletes
           nvc.eventAthletes = eventAthletes
           nvc.screenTitle = screenTitle
               nvc.meet = meet
           }
       }
       
    @IBAction func unwind( _ seg: UIStoryboardSegue) {
       meet.beenScored[selectedRow] = false
      processOutlet.backgroundColor = UIColor.lightGray
       processOutlet.setTitle("Process Event", for: .normal)
       
       
       
       if let pvc = seg.source as? AddAthleteToEventViewController{
         //allAthletes = pvc.allAthletes
         screenTitle = pvc.screenTitle
       eventAthletes = pvc.eventAthletes
         tableViewOutlet.reloadData()
         print("unwinding from AddAthleteToEvent")
        print("checking events after unwinding to eventeditvc")
        for ath in eventAthletes{
            for eve in ath.events{
                print("\(ath.last) \(eve.name)")
            }
        }
       }
       else{
           let pvc = seg.source as! addAthleteViewController
          // allAthletes = pvc.allAthletes
             screenTitle = pvc.from
           eventAthletes = pvc.eventAthletes
      
            
             tableViewOutlet.reloadData()
             print("unwinding from addAthlete")
           
       }
       
       // save to userdefaults
       let userDefaults = UserDefaults.standard
       do {
               try userDefaults.setObjects(Data.allAthletes, forKey: "allAthletes")
              } catch {
                  print(error.localizedDescription)
              }

     }
}

