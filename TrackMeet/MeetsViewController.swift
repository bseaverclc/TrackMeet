//
//  MeetsViewController.swift
//  TrackMeet
//
//  Created by Brian Seaver on 5/28/20.
//  Copyright © 2020 clc.seaver. All rights reserved.
//

import UIKit


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

func readFromURL(){
    
    // my google sheets api  888132519905-jg10rta9qlig4voa44lr4850et6lqmla.apps.googleusercontent.com
    
    let url = URL(string: "https://docs.google.com/spreadsheets/d/17itHVEOa9JBKnWo6-IJWVG8yqtuduzo_hpff-B-UcNw/edit#gid=1747035338")!

    let task = URLSession.shared.downloadTask(with: url) { localURL, urlResponse, error in
        if let localURL = localURL {
            if let string = try? String(contentsOf: localURL) {
                print(string)
            }
        }
    }

    task.resume()
}




class MeetsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    var meets = [Meet]()
    
    @IBOutlet weak var tableView: UITableView!
    
    var allAthletes = [Athlete]()
    var events = [Event]()
 
    var selectedMeet : Meet?
    var schools = [String:String]()
   // var schools = ["CRYSTAL LAKE CENTRAL": "CLC", "CRYSTAL LAKE SOUTH": "CLS", "CARY-GROVE": "CG", "PRAIRIE RIDGE": "PR"]
    
    
    override func viewDidLoad() {
               super.viewDidLoad()
        readFromURL()
        let userDefaults = UserDefaults.standard
        
        // Get athletes from UserDefaults
        do {
                   let athletes = try userDefaults.getObjects(forKey: "allAthletes", castTo: [Athlete].self)
            for athlete in athletes{
                allAthletes.append(athlete)
            }
            
                   //print(playingItMyWay[0].schoolFull)
               } catch {
                   print(error.localizedDescription)
                  randomizeAthletes()
               }
               //randomizeAthletes()
                sortByName()
        
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
            } catch {
                schools = ["CRYSTAL LAKE CENTRAL": "CLC", "CRYSTAL LAKE SOUTH": "CLS", "CARY-GROVE": "CG", "PRAIRIE RIDGE": "PR"]
                      print(error.localizedDescription)
                    }
           }
    
    func randomizeAthletes(){
        allAthletes.append(Athlete(f: "OWEN", l: "MIZE", s: "CLC", g: 12, sf: "CRYSTAL LAKE CENTRAL"))
            allAthletes.append(Athlete(f: "JAKHARI", l: "ANDERSON", s: "CG", g: 12, sf: "CARY-GROVE"))
            allAthletes.append(Athlete(f: "DREW", l: "MCGINNESS", s: "CLS", g: 9, sf: "CRYSTAL LAKE SOUTH"))
        let letters = "ABCDEFGHIJKLMNOPQRSTUVWXYZ"
        let chars = Array(letters)
        let schoolArray = ["CLC","CG","CLS","PR"]
        let schoolFullArray = ["CRYSTAL LAKE CENTRAL", "CARY-GROVE", "CRYSTAL LAKE SOUTH", "PRAIRIE RIDGE"]
                            
        
        for _ in 3...1000{
            var first = ""
            var last = ""
            for _ in 0...4{
                first.append(String(chars[Int.random(in: 0 ..< chars.count)]))
                last.append(String(chars[Int.random(in: 0 ..< chars.count)]))
            }
            var choice = Int.random(in: 0..<schoolArray.count)
            let school = schoolArray[choice]
            let schoolF = schoolFullArray[choice]
            //let school = schoolArray.randomElement()!
            let grade = Int.random(in: 9...12)
            
            allAthletes.append(Athlete(f: first, l: last, s: school, g: grade, sf: schoolF))
            
        }
//        var teams = ["A","B","C"]
//        var levels = ["VAR", "F/S"]
//        for school in schoolArray{
//            for letter in teams{
//                allAthletes.append(Athlete(f: letter, l: school, s: school, g: 12))
//        }
//     }
             
        
    }
    
    func sortByName(){
        allAthletes.sort(by: {$0.last.localizedCaseInsensitiveCompare($1.last) == .orderedAscending})
    }
    
    
    
   

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toAddMeetSegue"{
            let nvc = segue.destination as! AddMeetViewController
            nvc.allAthletes = allAthletes
            nvc.schools = schools
        }
        if segue.identifier == "toHomeSegue"{
            let nvc = segue.destination as! HomeViewController
            nvc.meet = selectedMeet
            nvc.allAthletes = allAthletes
        }
    
        
    }
    
    
    
    
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        meets.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "myCell", for: indexPath)
      
        let formatter1 = DateFormatter()
        formatter1.dateStyle = .short
        var dateString = formatter1.string(from: meets[indexPath.row].date)
        
        cell.textLabel?.text = dateString
        cell.detailTextLabel?.text = meets[indexPath.row].name
        return cell
        
        
    }
    
    @IBAction func unwind2(_ seg: UIStoryboardSegue){
        let pvc = seg.source as! HomeViewController
        allAthletes = pvc.allAthletes
        print("unwinding from Home VC")
    }
    
  @IBAction func unwind( _ seg: UIStoryboardSegue) {
        print("unwinding from Meets VC")
     
     let pvc = seg.source as! AddMeetViewController
        if let m = pvc.meet{
        meets.append(m)
            tableView.reloadData()
            
            // store meets to UserDefaults
            
               let userDefaults = UserDefaults.standard
               do {
                       try userDefaults.setObjects(meets, forKey: "meets")
                      } catch {
                          print(error.localizedDescription)
                      }
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selectedMeet = meets[indexPath.row]
        performSegue(withIdentifier: "toHomeSegue", sender: nil)
    }
    


}
