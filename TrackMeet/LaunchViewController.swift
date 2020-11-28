//
//  LaunchViewController.swift
//  TrackMeet
//
//  Created by Brian Seaver on 7/13/20.
//  Copyright © 2020 clc.seaver. All rights reserved.
//

import UIKit
import SafariServices
//import FirebaseDatabase

class LaunchViewController: UIViewController {
   var meets = [Meet]()
   var allAthletes = [Athlete]()
   var schools = [String:String]()
    var initials = [String]()
 
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: animated)
        self.navigationController?.toolbar.isHidden = true
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.setNavigationBarHidden(false, animated: animated)
        storeToUserDefaults()
    }
    
    func getCoreData(){
        let userDefaults = UserDefaults.standard
        // Delete data from userdefaults
//        let domain = Bundle.main.bundleIdentifier!
//        userDefaults.removePersistentDomain(forName: domain)
//        userDefaults.synchronize()
        // Get athletes from UserDefaults
        do {
            let athletes = try userDefaults.getObjects(forKey: "allAthletes", castTo: [Athlete].self)
            print("loading athletes from userdefaults")
            for athlete in athletes{
                allAthletes.append(athlete)
            }
            
                   //print(playingItMyWay[0].schoolFull)
               } catch {
                   print(error.localizedDescription)
                   readCSVURL(csvURL: "https://docs.google.com/spreadsheets/d/1WLDFBqmA6GyiTYBHjeuNOBMl_id64vZ6HNLCFRzCIQc/edit#gid=0", fullSchool: "Cary-Grove", initSchool: "CG")
                self.schools["Cary-Grove"] = "CG"
                readCSVURL(csvURL: "https://docs.google.com/spreadsheets/d/1puxn4zdVrYcJwrEksSktMF-McK6VQhguOqnPOLjaSYQ/edit#gid=0", fullSchool: "Crystal Lake Central", initSchool: "CLC")
             self.schools["Crystal Lake Central"] = "CLC"
                readCSVURL(csvURL: "https://docs.google.com/spreadsheets/d/1gfZWGg0cjEdOO_9tKKSHrWm8KufLt8MViYOrzlC-XpY/edit#gid=0", fullSchool: "Crystal Lake South", initSchool: "CLS")
             self.schools["Crystal Lake South"] = "CLS"
                  //randomizeAthletes()
               }
               //randomizeAthletes()
                //sortByName()
        
        // get meets from userdefaults
        do {
               let inMeets = try userDefaults.getObjects(forKey: "meets", castTo: [Meet].self)
        for meet in inMeets{
            meets.append(meet)
        }
        
               //print(playingItMyWay[0].schoolFull)
           } catch {
               print(error.localizedDescription)
           }
        
        // get schools from UserDefaults
        do {
            let inSchools = try userDefaults.getObjects(forKey: "schools", castTo: [String:String].self)
               for (key,value) in inSchools{
                   schools[key] = value
               }
            initials = Array(schools.values)
            print("Got schools from file")
            print(schools)
            } catch {
                      print(error.localizedDescription)
                print(schools)
                    }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
       // let ref = Database.database().reference()
        
        
        self.title = "Home"
        self.navigationController?.toolbar.isHidden = true
        getCoreData()
        for a in allAthletes{
            //a.saveToFirebase()
            for i in 0 ..< a.events.count{
                if a.events[i].name.contains("4x400 VAR"){
                    a.events[i].name = "4x400M VAR"
                }
                if a.events[i].name.contains("4x400 F/S"){
                    a.events[i].name = "4x400M F/S"
                }
                if a.events[i].name.contains("4x200 VAR"){
                    a.events[i].name = "4x200M VAR"
                }
                if a.events[i].name.contains("4x200 F/S"){
                    a.events[i].name = "4x200M F/S"
                }
                if a.events[i].name.contains("4x800 VAR"){
                    a.events[i].name = "4x800M VAR"
                }
                if a.events[i].name.contains("4x800 F/S"){
                    a.events[i].name = "4x800M F/S"
                }
               
            }
        }
        for m in meets{
            for i in 0 ..< m.events.count{
            
                if m.events[i] == ("4x400 F/SM"){
                    m.events[i] = "4x400M F/S"
                }
                if m.events[i] == ("4x400 VARM"){
                    m.events[i] = "4x400M VAR"
                }
                if m.events[i] == ("4x800 F/SM"){
                    m.events[i] = "4x800M F/S"
                }
                if m.events[i] == ("4x800 VARM"){
                    m.events[i] = "4x800M VAR"
                }
                if m.events[i] == ("4x200 F/SM"){
                    m.events[i] = "4x200M F/S"
                }
                if m.events[i] == ("4x200 VARM"){
                    m.events[i] = "4x200M VAR"
                }
                 
            }
        
        

        }
    }
    
     func randomizeAthletes(){
//            allAthletes.append(Athlete(f: "OWEN", l: "MIZE", s: "CLC", g: 12, sf: "CRYSTAL LAKE CENTRAL"))
//                allAthletes.append(Athlete(f: "JAKHARI", l: "ANDERSON", s: "CG", g: 12, sf: "CARY-GROVE"))
//                allAthletes.append(Athlete(f: "DREW", l: "MCGINNESS", s: "CLS", g: 9, sf: "CRYSTAL LAKE SOUTH"))
//            let letters = "ABCDEFGHIJKLMNOPQRSTUVWXYZ"
//            let chars = Array(letters)
//            let schoolArray = ["CLC","CG","CLS","PR"]
//            let schoolFullArray = ["CRYSTAL LAKE CENTRAL", "CARY-GROVE", "CRYSTAL LAKE SOUTH", "PRAIRIE RIDGE"]
//
//
//            for _ in 3...1000{
//                var first = ""
//                var last = ""
//                for _ in 0...4{
//                    first.append(String(chars[Int.random(in: 0 ..< chars.count)]))
//                    last.append(String(chars[Int.random(in: 0 ..< chars.count)]))
//                }
//                var choice = Int.random(in: 0..<schoolArray.count)
//                let school = schoolArray[choice]
//                let schoolF = schoolFullArray[choice]
//                //let school = schoolArray.randomElement()!
//                let grade = Int.random(in: 9...12)
//
//                allAthletes.append(Athlete(f: first, l: last, s: school, g: grade, sf: schoolF))
//
//            }
    //        var teams = ["A","B","C"]
    //        var levels = ["VAR", "F/S"]
    //        for school in schoolArray{
    //            for letter in teams{
    //                allAthletes.append(Athlete(f: letter, l: school, s: school, g: 12))
    //        }
    //     }


        }
  

    @IBAction func athleticNetAction(_ sender: UIButton) {
        if let url = URL(string: "https://www.athletic.net/TrackAndField/Illinois/") {
            UIApplication.shared.open(url)
        }
        
//        let url = URL(string: "https://www.athletic.net/TrackAndField/Illinois/")
//        let svc = SFSafariViewController(url: url!)
//        present(svc, animated: true, completion: nil)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toMeetsSegue"{
            let nvc = segue.destination as! MeetsViewController
            nvc.allAthletes = allAthletes
            nvc.meets = meets
            nvc.schools = schools
            print("sent stuff to meets")
        }
        else{
            let nvc = segue.destination as! SchoolsViewController
            nvc.allAthletes = allAthletes
            nvc.schools = schools
            nvc.meets = meets
        }
    }
    
    @IBAction func unwind3(_ seg: UIStoryboardSegue){
           let pvc = seg.source as! SchoolsViewController
           allAthletes = pvc.allAthletes
        schools = pvc.schools
        meets = pvc.meets
           print("unwinding from Schools VC")
       }
    
    @IBAction func unwindFromMeets(_ seg: UIStoryboardSegue){
              let pvc = seg.source as! MeetsViewController
              allAthletes = pvc.allAthletes
              schools = pvc.schools
              meets = pvc.meets
              print("unwinding from Meets VC")
          }
    
    func storeToUserDefaults(){
        let userDefaults = UserDefaults.standard
           do {
                   try userDefaults.setObjects(meets, forKey: "meets")
            
                  } catch {
                      print(error.localizedDescription)
                  }
        do {
            try userDefaults.setObjects(allAthletes, forKey: "allAthletes")
            print("Saving Athletes")
        }
        catch{
            print("error saving athletes")
        }
        
        do {
                       try userDefaults.setObjects(schools, forKey: "schools")
                       print("Saving Schools")
                   }
                   catch{
                       print("error saving schools")
                   }
    }
    
    func writeToFirebase(){
        
    }
    
    
    func getFromFirebase(){
        
    }
    
    func readCSVURL(csvURL: String, fullSchool: String, initSchool: String){
            var urlCut = csvURL
            if csvURL != ""{
                if let editRange = csvURL.range(of: "/edit"){
                let start = editRange.lowerBound
                urlCut = String(csvURL[csvURL.startIndex..<start])
                }
                var urlcompleted = urlCut + "/pub?output=csv"
                let url = URL(string: String(urlcompleted))
                print(url)
                
                     guard let requestUrl = url else {
                        //fatalError()
                        print("fatal error")
                        return
                }
                     // Create URL Request
                     var request = URLRequest(url: requestUrl)
                     // Specify HTTP Method to use
                     request.httpMethod = "GET"
                
                     // Send HTTP Request
                     let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
                       
                         // Check if Error took place
                         if let error = error {
                             print("Error took place \(error)")
    //                        let alert = UIAlertController(title: "Error!", message: "Could not load athletes", preferredStyle: .alert)
    //                        let ok = UIAlertAction(title: "ok", style: .default)
    //                        alert.addAction(ok)
    //                        self.present(alert, animated: true, completion: nil)
                            //self.showAlert(errorMessage: "Error loading Athletes from file")
                             
                         }
                         
                         // Read HTTP Response Status code
                         if let response = response as? HTTPURLResponse {
                             print("Response HTTP Status code: \(response.statusCode)")
                           
                            //return
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
