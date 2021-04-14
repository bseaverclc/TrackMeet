//
//  LaunchViewController.swift
//  TrackMeet
//
//  Created by Brian Seaver on 7/13/20.
//  Copyright © 2020 clc.seaver. All rights reserved.
//

import UIKit
import SafariServices
import FirebaseDatabase
import GoogleSignIn
import Firebase

class Data{
    static var meets = [Meet]()
    static var allAthletes = [Athlete]()
    //static var schools = [String:String]()
    static var userID = ""
    static var coach = ""
    static var manager = ""
    static var schoolsNew = [School]()
}


class LaunchViewController: UIViewController {
    
    @IBOutlet weak var QuickMeetLabel: UILabel!
    @IBOutlet weak var nameOutlet: UILabel!
    
    @IBOutlet weak var logOutOutlet: UIButton!
    @IBOutlet weak var logInOutlet: GIDSignInButton!
    //var meets = [Meet]()
    //var allAthletes = [Athlete]()
   // var schools = [String:String]()
    var initials = [String]()
 
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: animated)
        self.navigationController?.toolbar.isHidden = true
        
     
    }
    override func viewDidAppear(_ animated: Bool) {
        print("View Did appear")
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.setNavigationBarHidden(false, animated: animated)
     
        //storeToUserDefaults()
    }
    

    

    
    @objc func didSignIn(){
        
        //if let blah = GID
        if let user = Auth.auth().currentUser{
            Data.userID = user.uid
           
            nameOutlet.text = "\(user.email!)"
            logInOutlet.isHidden = true
            logOutOutlet.isHidden = false
        }
       else{
            nameOutlet.text = "Not Logged in"
        logInOutlet.isHidden = false
        logOutOutlet.isHidden = true
       }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        NotificationCenter.default.addObserver(self, selector: #selector(didSignIn), name: NSNotification.Name("SuccessfulSignInNotification"), object: nil)
        GIDSignIn.sharedInstance().presentingViewController = self
        GIDSignIn.sharedInstance()?.restorePreviousSignIn()
        didSignIn()
        print("view is loading")
       
                    
        //QuickMeetLabel.text = QuickMeetLabel.text! + "\n1.9.2"
        self.title = "Home"
        self.navigationController?.toolbar.isHidden = true
       
        getAthletesFromFirebase()
        
        //storeSchoolsToFirebase()
        getSchoolsFromFirebase()
        getMeetsFromFirebase()
        athleteChangedInFirebase2()
        athleteDeletedInFirebase()
        beenScoredChangedInFirebase()
     
      
    
        
        Data.allAthletes.sort(by: {$0.last.localizedCaseInsensitiveCompare($1.last) == .orderedAscending})
        
        

    }
    
    @IBAction func logInAction(_ sender: GIDSignInButton) {
        
    }
    
    
    @IBAction func logOutAction(_ sender: UIButton) {
        //GIDSignIn.sharedInstance().signOut()
        print(GIDSignIn.sharedInstance()?.currentUser != nil) // true - signed in
        GIDSignIn.sharedInstance()?.signOut()
        print(GIDSignIn.sharedInstance()?.currentUser != nil) // false - signed out
        
        let firebaseAuth = Auth.auth()
      do {
        try firebaseAuth.signOut()
        Data.userID = ""
      } catch let signOutError as NSError {
        print ("Error signing out: %@", signOutError)
      }
        
        //if let blah = GID
        if let user = Auth.auth().currentUser{
            Data.userID = user.uid
           
            nameOutlet.text = "Welcome \(user.displayName!)"
            logInOutlet.isHidden = true
            logOutOutlet.isHidden = false
        }
       else{
            nameOutlet.text = "Not Logged in"
        logInOutlet.isHidden = false
        logOutOutlet.isHidden = true
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
           // letnvc = segue.destination as! MeetsViewController
            //nvc.allAthletes = allAthletes
            //nvc.meets = meets
           // nvc.schools = schools
            print("sent stuff to meets")
        }
        else{
          //  let nvc = segue.destination as! SchoolsViewController
            //nvc.allAthletes = allAthletes
           // nvc.schools = schools
           // nvc.meets = meets
        }
    }
    
    @IBAction func unwind3(_ seg: UIStoryboardSegue){
          // let pvc = seg.source as! SchoolsViewController
           //allAthletes = pvc.allAthletes
       // schools = pvc.schools
        //meets = pvc.meets
           print("unwinding from Schools VC")
       }
    
    @IBAction func unwindFromMeets(_ seg: UIStoryboardSegue){
             // let pvc = seg.source as! MeetsViewController
             // allAthletes = pvc.allAthletes
              //schools = pvc.schools
             // meets = pvc.meets
             // print("unwinding from Meets VC")
          }
    
//    func storeSchoolsToFirebase(){
//        let ref = Database.database().reference().child("schools")
//        ref.updateChildValues(Data.schools)
//
//    }
    
    
    
    func getSchoolsFromFirebase(){
//        var ref: DatabaseReference!
//
//        ref = Database.database().reference()
//        ref.child("schools").observe(.childAdded, with: { (snapshot) in
//            Data.schools = snapshot.value as! [String:String]
//        })
        
        // works if a school is there already
//        ref.child("schools").observeSingleEvent(of: .value, with: { (snapshot) in
//            Data.schools = snapshot.value as! [String:String]
//            print("got schools from firebase \(Data.schools)")
//        })
        
        let ref2 = Database.database().reference()
        ref2.child("schoolsNew").observe(.childAdded, with: { (snapshot) in

            let dict = snapshot.value as! [String:Any]
            let s = School(key: snapshot.key, dict: dict)
            if Data.schoolsNew.contains(where: {$0.uid == s.uid}){
                print("school already in Data.schoolsNew")
            }
            else{
            Data.schoolsNew.append(s)
            }
            print("added a schoolsNew \(s.full)")
        })
        
        ref2.child("schoolsNew").observe(.childChanged, with: { (snapshot) in
            let uid = snapshot.key
            let dict = snapshot.value as! [String:Any]
            let school = School(key: snapshot.key, dict: dict)

          for i in 0..<Data.schoolsNew.count{
                if(Data.schoolsNew[i].uid == uid){
                   Data.schoolsNew[i] = school
                    print("SchoolNew \(i)Changed \(Data.schoolsNew[i].full)")
                }
                }

        })
        
        ref2.child("schoolsNew").observe(.childRemoved) { (snapshot) in
            print("a school has been removed from firebase")
            let key = snapshot.key
            Data.schoolsNew.removeAll(where: {$0.uid == key})
            
        }
        
        
       
    }
    
    func getMeetsFromFirebase(){
        var ref: DatabaseReference!

        ref = Database.database().reference()
        ref.child("meets").observe(.childAdded, with: { (snapshot) in
            
            let dict = snapshot.value as! [String:Any]
            Data.meets.append(Meet(key: snapshot.key, dict: dict))
        })
        
//        ref.child("meets").observe(.childRemoved, with: { (snapshot) in
//            let dict = snapshot.value as! [String:Any]
//            for i in 0..<Data.meets.count{
//                if let n = dict["name"] as? String{
//                    if Data.meets[i].name == n{
//                        Data.meets.remove(at: i)
//                        break
//
//                    }
//                }
//            }
//        })
       
    }
    
    func getAthletesFromFirebase(){
        var ref: DatabaseReference!
        var handle1 : UInt! // These did not work!
        var handle2 : UInt!  // These did not work!

        ref = Database.database().reference()
        
        handle1 = ref.child("athletes").observe(.childAdded) { (snapshot) in
            //print("athlete observed")
            let uid = snapshot.key
            //print(uid)
           
            guard let dict = snapshot.value as? [String:Any]
            else{ print("Error")
                return
            }
            
            var addAth = true
            let a = Athlete(key: uid, dict: dict)
            for ath in Data.allAthletes{
                if ath.uid == a.uid{
                    addAth = false
                }
            }
            if addAth{
            Data.allAthletes.append(a)
            //print("Added Athlete to allAthletes \(Data.allAthletes[Data.allAthletes.count-1].first) ")
            }
            for e in a.events{
                //print(e.name)
            }
            handle2 = ref.child("athletes").child(uid).child("events").observe(.childAdded) { (snapshot2) in
                guard let dict2 = snapshot2.value as? [String:Any]
                else{ print("Error")
                    return
                }
//                print("printing events")
//                print(dict2)
                var add = true
                for e in a.events{
                    if dict2["name"] as! String == e.name && dict2["meetName"] as! String == e.meetName{
                        add = false
                    }
                }
                if add{
                a.addEvent(key: snapshot2.key, dict: dict2)
                //print("Added Event")
                //print("\(a.first) \(a.events[a.events.count-1].name)")
                }
                
            }
            ref.removeObserver(withHandle: handle2)
            //print("removing handle2")
               }
        
        ref.removeObserver(withHandle: handle1)
        //print("removing handle1")
        
        ref.removeAllObservers()
    }
    
    func athleteChangedInFirebase2(){
        var ref: DatabaseReference!

        ref = Database.database().reference()
        
        ref.child("athletes").observe(.childChanged) { (snapshot) in
            //print("athlete observed2")
            let uid = snapshot.key
            //print(uid)
           
            guard let dict = snapshot.value as? [String:Any]
            else{ print("Error")
                return
            }
            
            
            let a = Athlete(key: uid, dict: dict)
            
           // Data.allAthletes.append(a)
           // ref.child("athletes").child(uid).child("events").
            ref.child("athletes").child(uid).child("events").observe(.childRemoved, with: { (snapshot2) in
                print("event removed")
            })
            
            
            ref.child("athletes").child(uid).child("events").observe(.childAdded, with: { (snapshot2) in
                //print("snapshot2 \(snapshot2)")
                
                    
                
                guard let dict2 = snapshot2.value as? [String:Any]
                else{ print("Error")
                    return
                }
                
                var add = true
                for e in a.events{
                    if dict2["name"] as! String == e.name && dict2["meetName"] as! String == e.meetName{
                        add = false
                    }
                }
                if add{
                a.addEvent(key: snapshot2.key, dict: dict2)
                print("in changed event added")
                
                }
                    
                
                
            })
        
               
        
        for i in 0..<Data.allAthletes.count{
            if(Data.allAthletes[i].uid == uid){
                Data.allAthletes[i] = a
                print("Athlete \(i)Changed \(Data.allAthletes[i].last)")
            }
        
                
            }
            
        }
          
                
//                print("printing events")
//                print(dict2)
                
    }
    
    func athleteDeletedInFirebase(){
        var ref: DatabaseReference!
        print("Removing athleted observed")
        ref = Database.database().reference()
        ref.child("athletes").observe(.childRemoved, with: { (snapshot) in
            print("Removing athleted observed from Array")
            for i in 0..<Data.allAthletes.count{
                
                if Data.allAthletes[i].uid == snapshot.key{
                    print("\(Data.allAthletes[i].last) has been removed")
                    Data.allAthletes.remove(at: i)
                    break
                }
            }
            
        })
    }
    
    func readCSVURL(csvURL: String, fullSchool: String, initSchool: String){
            var urlCut = csvURL
            if csvURL != ""{
                if let editRange = csvURL.range(of: "/edit"){
                let start = editRange.lowerBound
                urlCut = String(csvURL[csvURL.startIndex..<start])
                }
                let urlcompleted = urlCut + "/pub?output=csv"
                let url = URL(string: String(urlcompleted))
                print(url ?? "URL Reading Didn't work")
                
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
                                
                                let person = [String](row.components(separatedBy: ","))
                                if person[0] != "First"{
                                    let athlete = Athlete(f: person[0], l: person[1], s: initSchool, g: Int(person[2])!, sf: fullSchool)
                                print(athlete)
                                    Data.allAthletes.append(athlete)
                                }
                                 
                             }
                         }
                         
                            
                         

                        
                     }
                     task.resume()
            
        }
        
        
    }
}

func beenScoredChangedInFirebase(){
    var ref: DatabaseReference!

    ref = Database.database().reference()
    
    ref.child("meets").observe(.childChanged) { (snapshot) in
        print("meet changed")
        print(snapshot.key)
        let uid = snapshot.key
        for meet in Data.meets{
            print("looping through meets")
            if meet.uid == uid{
                
                guard let dict = snapshot.value as? [String:Any]
                else{ print("Error")
                    return
                }
                meet.beenScored =  dict["beenScored"] as! Array
                print("Heard beenScored change in firebase and updated")
                print(meet.beenScored)
            }
        }
    }
}
