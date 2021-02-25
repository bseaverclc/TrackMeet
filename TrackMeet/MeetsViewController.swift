//
//  MeetsViewController.swift
//  TrackMeet
//
//  Created by Brian Seaver on 5/28/20.
//  Copyright © 2020 clc.seaver. All rights reserved.
//

import UIKit
import SafariServices

//import GTMSessionFetcher
//import GoogleAPIClientForREST
// Testing Moving Folders

protocol ObjectSavable {
    func setObjects<Object>(_ object: Object, forKey: String) throws where Object: Encodable
    func getObjects<Object>(forKey: String, castTo type: Object.Type) throws -> Object where Object: Decodable
}

enum ObjectSavableError: String, LocalizedError {
    case unableToEncode = "Unable to encode object into data"
    case noValue = "No data object found for the given key"
    case unableToDecode = "Unable to decode object into given type"
    
    var errorDescription: String? {
        rawValue
    }
}

extension UserDefaults: ObjectSavable {
    func setObjects<Object>(_ object: Object, forKey: String) throws where Object: Encodable {
        let encoder = JSONEncoder()
        do {
            let data = try encoder.encode(object)
            set(data, forKey: forKey)
        } catch {
            throw ObjectSavableError.unableToEncode
        }
    }
    
    func getObjects<Object>(forKey: String, castTo type: Object.Type) throws -> Object where Object: Decodable {
        guard let data = data(forKey: forKey) else { throw ObjectSavableError.noValue }
        let decoder = JSONDecoder()
        do {
            let object = try decoder.decode(type, from: data)
            return object
        } catch {
            throw ObjectSavableError.unableToDecode
        }
    }
}


class MeetsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    //var meets = [Meet]()
    //var allAthletes = [Athlete]()
    //var schools = [String:String]()
    var selectedMeet : Meet?
    
    @IBOutlet weak var tableView: UITableView!
   
    @IBOutlet weak var addMeetOutlet: UIBarButtonItem!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "All Meets"
        if(Data.userID == "")
        {
            addMeetOutlet.isEnabled = false
        }
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.toolbar.isHidden = false
        Meet.canCoach = false
        Meet.canManage = false
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        if isMovingFromParent{
            performSegue(withIdentifier: "unwindFromMeetsSegue", sender: nil)
        }
        storeToUserDefaults()
    }
    
    
    func sortByName(){
        Data.allAthletes.sort(by: {$0.last.localizedCaseInsensitiveCompare($1.last) == .orderedAscending})
    }
     
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        Data.meets.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "myCell", for: indexPath)
      
        let formatter1 = DateFormatter()
        formatter1.dateStyle = .short
        var dateString = formatter1.string(from: Data.meets[indexPath.row].date)
        
        cell.textLabel?.text = dateString
        cell.detailTextLabel?.text = Data.meets[indexPath.row].name
        return cell
        
        
    }
    
    
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        print(Data.meets[indexPath.row].name)
        print(Data.meets[indexPath.row].userId)
        print(Data.userID)
        if Data.meets[indexPath.row].userId != Data.userID
        {
            
            return false
        }
        return true
        
    }
    
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
                
        
                let delete = UITableViewRowAction(style: .destructive, title: "Delete") { (action, indexPath) in
                    let blankAlert = UIAlertController(title: "Are you sure?", message: "Deleting this meet will also delete all results", preferredStyle: .alert)
                    let ok = UIAlertAction(title: "Delete", style: .destructive) { (a) in
                        //var selected = Data.meets[indexPath.row]
                        Data.meets[indexPath.row].deleteFromFirebase()
                         
                        Data.meets.remove(at: indexPath.row)
                        tableView.deleteRows(at: [indexPath], with: .fade)
                        
                        let userDefaults = UserDefaults.standard
                        do {
                           try userDefaults.setObjects(Data.meets, forKey: "meets")
                           print("Saving meets")
                        }
                        catch{
                              print("error saving meets")
                        }
                    }
                    let cancel = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
                    blankAlert.addAction(ok)
                    blankAlert.addAction(cancel)
                    self.present(blankAlert, animated: true, completion: nil)
                    
                    
                    
                    
                }

                let edit = UITableViewRowAction(style: .normal, title: "Edit") { (action, indexPath) in
                  
                    self.selectedMeet = Data.meets[indexPath.row]
                    self.performSegue(withIdentifier: "changeMeetSegue", sender: nil)
                      

                

                
            }
        return [edit,delete]
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selectedMeet = Data.meets[indexPath.row]
        
        print(selectedMeet?.coachCode)
        print(selectedMeet?.managerCode)
        let errorAlert = UIAlertController(title: "Incorrect Code!", message: "", preferredStyle: .alert)
        errorAlert.addAction(UIAlertAction(title: "OK", style: .destructive, handler: nil))
        
        let coachAlert = UIAlertController(title: "", message: "Enter Coach Code", preferredStyle: .alert)
        
        coachAlert.addTextField(configurationHandler: { (textField) in
            textField.autocapitalizationType = .allCharacters
                   textField.placeholder = "CODE"
                   
               })
        
        coachAlert.addAction(UIAlertAction(title: "OK", style: .default, handler: { (updateAction) in
            
            var coachCode = coachAlert.textFields![0].text!
            if coachCode == self.selectedMeet?.coachCode{
                Data.coach = coachCode
                Meet.canCoach = true
                self.performSegue(withIdentifier: "toHomeSegue", sender: nil)
            }
            else{
                self.present(errorAlert, animated: true, completion: nil)
            }
        }))
        
        let manageAlert = UIAlertController(title: "", message: "Enter Meet Manager Code", preferredStyle: .alert)
        
        manageAlert.addTextField(configurationHandler: { (textField) in
            textField.autocapitalizationType = .allCharacters
                   textField.placeholder = "CODE"
                   
               })
        
        manageAlert.addAction(UIAlertAction(title: "OK", style: .default, handler: { (updateAction) in
            
            var manageCode = manageAlert.textFields![0].text!
            if manageCode == self.selectedMeet?.managerCode{
                Data.manager = manageCode
                Meet.canManage = true
                Meet.canCoach = true
                self.performSegue(withIdentifier: "toHomeSegue", sender: nil)
            }
            else{
                self.present(errorAlert, animated: true, completion: nil)
            }
        }))
        
        
            
        
        
        
        let chooseAlert = UIAlertController(title: "", message: "Choose Access", preferredStyle: .alert)
        let fan = UIAlertAction(title: "Fan", style: .default) { (alert) in
            self.performSegue(withIdentifier: "toHomeSegue", sender: nil)
        }
        let coach = UIAlertAction(title: "Coach", style: .default) { (alert) in
            self.present(coachAlert, animated: true, completion: nil)
        }
        let manager = UIAlertAction(title: "Meet Manager", style: .default) { (alert) in
            self.present(manageAlert, animated: true, completion: nil)
        }
        chooseAlert.addAction(fan)
        chooseAlert.addAction(coach)
        chooseAlert.addAction(manager)
        if(selectedMeet!.userId == Data.userID)
        {
            Meet.canCoach = true
            Meet.canManage = true
            self.performSegue(withIdentifier: "toHomeSegue", sender: nil)
        }
        else{
        self.present(chooseAlert, animated: true, completion: nil)
        }
        //performSegue(withIdentifier: "toHomeSegue", sender: nil)
    }
    
    @IBAction func athleticNetAction(_ sender: UIBarButtonItem) {
        let url = URL(string: "https://www.athletic.net/TrackAndField/School.aspx?SchoolID=16275")
        let svc = SFSafariViewController(url: url!)
        present(svc, animated: true, completion: nil)
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toAddMeetSegue"{
            let nvc = segue.destination as! AddMeetViewController
           // nvc.allAthletes = allAthletes
           // nvc.schools = schools
            //nvc.meets = meets
        }
        if segue.identifier == "toHomeSegue"{
            let nvc = segue.destination as! HomeViewController
            nvc.meet = selectedMeet
           // nvc.allAthletes = allAthletes
            //nvc.meets = meets
        }
        
        if segue.identifier == "changeMeetSegue"{
            let nvc = segue.destination as! AddMeetViewController
            //nvc.allAthletes = allAthletes
            //nvc.schools = schools
           // nvc.meets = meets
            nvc.selectedMeet = selectedMeet
            
        }
    
        
    }
    
    @IBAction func unwind2(_ seg: UIStoryboardSegue){
        let pvc = seg.source as! HomeViewController
       // allAthletes = pvc.allAthletes
        print("unwinding from Home VC")
    }
    
  @IBAction func unwind( _ seg: UIStoryboardSegue) {
        print("unwinding from addMeets VC")
     
     let pvc = seg.source as! AddMeetViewController
    // allAthletes = pvc.allAthletes
     //schools = pvc.schools
     //meets = pvc.meets
     if let m = pvc.meet{
       // meets.append(m)
        tableView.reloadData()
            
        // store meets to UserDefaults
        storeToUserDefaults()
               
        }
    }
    
    func storeToUserDefaults(){
        let userDefaults = UserDefaults.standard
           do {
            try userDefaults.setObjects(Data.meets, forKey: "meets")
            
                  } catch {
                      print(error.localizedDescription)
                  }
        do {
            try userDefaults.setObjects(Data.allAthletes, forKey: "allAthletes")
            print("Saving Athletes")
        }
        catch{
            print("error saving athletes")
        }
        
        do {
            try userDefaults.setObjects(Data.schools, forKey: "schools")
                       print("Saving Schools")
                   }
                   catch{
                       print("error saving schools")
                   }
    }
    
}
