//
//  ViewController.swift
//  TrackMeet
//
//  Created by Brian Seaver on 5/17/20.
//  Copyright © 2020 clc.seaver. All rights reserved.
//

import UIKit

extension UITableView {

    func setBottomInset(to value: CGFloat) {
        let edgeInset = UIEdgeInsets(top: 0, left: 0, bottom: value, right: 0)

        self.contentInset = edgeInset
        self.scrollIndicatorInsets = edgeInset
    }
}

class EventEditViewController: UIViewController, UITableViewDelegate,UITableViewDataSource, UINavigationControllerDelegate, UITabBarDelegate {
    
    @IBOutlet weak var tableViewOutlet: UITableView!
    
    var allAthletes = [Athlete]()
    var eventAthletes = [Athlete]()
    var screenTitle = ""
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return eventAthletes.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "myCell") as! TimeTableViewCell
        for event in eventAthletes[indexPath.row].events{
            if event.name == title{
                if let place = event.place{
                cell.configure(text: event.markString, placeholder: "Enter a time", placeText: "\(place)")
                }
                else{
                    cell.configure(text: event.markString, placeholder: "Enter a time")
                    
                }
            }
        }
        
        let athlete = eventAthletes[indexPath.row]
        cell.nameOutlet.text = "\(athlete.last), \(athlete.first)"
        cell.schoolOutlet.text = athlete.school
        cell.timeOutlet.tag = indexPath.row
        cell.placeOutlet.tag = indexPath.row
        return cell
    }
    
    override func viewWillAppear(_ animated: Bool) {
          NotificationCenter.default.addObserver(self, selector: #selector(EventEditViewController.keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        
                 NotificationCenter.default.addObserver(self, selector: #selector(EventEditViewController.keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
         super.viewWillDisappear(animated)

           NotificationCenter.default.removeObserver(self)
    }
    

    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = screenTitle
        for a in allAthletes{
                  for e in a.events{
                      if e.name == screenTitle{
                          eventAthletes.append(a)
                      }
                  }
              }
        tableViewOutlet.reloadData()
        print("eventEditVDL")
 
      
        // Do any additional setup after loading the view.
    }
    

    @objc func keyboardWillShow(notification: Notification){
        if let keyboardHeight = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue.height {
               print("Notification: Keyboard will show")
               tableViewOutlet.setBottomInset(to: keyboardHeight)
    }
    }
    
    @objc func keyboardWillHide(notification: Notification){
        print("Notification: Keyboard will hide")
        tableViewOutlet.setBottomInset(to: 0.0)
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print(indexPath.row)
    }
    
    
    

    

    @IBAction func timeAction(_ sender: UITextField) {
         //print(sender.tag)
        // print(sender.text)
         var indexPath = IndexPath(row: sender.tag, section: 0)
         var cell = tableViewOutlet.cellForRow(at: indexPath) as! TimeTableViewCell
         
         if let time = sender.text{
             for event in eventAthletes[indexPath.row].events{
                 if event.name == title{
            event.markString = time
                 }
             }
         }
        
    }
    
    
    @IBAction func placeAction(_ sender: UITextField) {
                var indexPath = IndexPath(row: sender.tag, section: 0)
                var cell = tableViewOutlet.cellForRow(at: indexPath) as! TimeTableViewCell
        
                if let place = sender.text{
                    for event in eventAthletes[indexPath.row].events{
                        if event.name == title{
                            if let intPlace = Int(place){
                   event.place = intPlace
                            }
        
        
                        }
                    }
                }
    }
    
    
    
  
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let nvc = segue.destination as! AddAthleteToEventViewController
        nvc.allAthletes = allAthletes
        nvc.eventAthletes = eventAthletes
        nvc.screenTitle = screenTitle
    }
    
    
    
//    func navigationController(_ navigationController: UINavigationController, willShow viewController: UIViewController, animated: Bool) {
//    if let vc = viewController as? EventsTableViewController{
//        vc.athletes = allAthletes
//        
//    
//        }
//    }
    
 @IBAction func unwind( _ seg: UIStoryboardSegue) {
     let pvc = seg.source as! AddAthleteToEventViewController
      allAthletes = pvc.allAthletes
      screenTitle = pvc.screenTitle
    eventAthletes = pvc.eventAthletes
      tableViewOutlet.reloadData()
      print("unwinding done")

  }
    
    func tabBar(_ tabBar: UITabBar, didSelect item: UITabBarItem) {
       
        if item.title == "School"{
            eventAthletes = eventAthletes.sorted { (struct1, struct2) -> Bool in
                if (struct1.school.lowercased() != struct2.school.lowercased()) { // if it's not the same section sort by section
                    return struct1.school < struct2.school
                } else { // if it the same section sort by order.
                    return struct1.last.lowercased() < struct2.last.lowercased()
                }
            }
            print("Done sorting by name")
            
           
            
//            eventAthletes.sort(by: {$0.school.localizedCaseInsensitiveCompare($1.school) == .orderedAscending && $0.last.localizedCaseInsensitiveCompare($1.last) == .orderedAscending})
           
        }
        else if item.title == "Name"{
           eventAthletes = eventAthletes.sorted(by: {$0.last.localizedCaseInsensitiveCompare($1.last) == .orderedAscending})
            print("sorting by name")
            
        }
        
        else if item.title == "Place"{
            eventAthletes = eventAthletes.sorted { (lhs, rhs) -> Bool in
                         let a = lhs.getEvent(eventName: self.title!)?.place
                         let b = rhs.getEvent(eventName: self.title!)?.place
                         switch (a ,b) {
                           case let(a?, b?): return a < b // Both lhs and rhs are not nil
                           case (nil, _): return false    // Lhs is nil
                           case (_?, nil): return true    // Lhs is not nil, rhs is nil
                           }
                       }
            
            
                print("sorting by place")
                
            
        }
        else if item.title == "Mark"{
            eventAthletes = eventAthletes.sorted { (lhs, rhs) -> Bool in
                                 let a = lhs.getEvent(eventName: self.title!)?.markString
                                 let b = rhs.getEvent(eventName: self.title!)?.markString
                                 switch (a ,b) {
                                   case ("", _): return false    // Lhs is empty
                                   case (_?, ""): return true    // Lhs is not nil, rhs is empty
                                 default: return a! < b!
                                   }
                               }
           
        }
        
        
        tableViewOutlet.reloadData()
        
      
        
        
    }
    
}

