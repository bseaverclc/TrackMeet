//
//  HomeViewController.swift
//  TrackMeet
//
//  Created by Brian Seaver on 5/18/20.
//  Copyright © 2020 clc.seaver. All rights reserved.
//

import UIKit

public protocol DataBackDelegate: class {
    func savePreferences (athletes: [Athlete])
}


class HomeViewController: UIViewController, DataBackDelegate {
    func savePreferences(athletes: [Athlete]) {
        allAthletes = athletes
        allAthletes.sort(by: {$0.last.localizedCaseInsensitiveCompare($1.last) == .orderedAscending})
        print("delegate function called")
    }
    
  
    

    var allAthletes = [Athlete]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        allAthletes.append(Athlete(f: "Owen", l: "Mize", s: "CLC", g: 12))
               allAthletes.append(Athlete(f: "Jakhari", l: "Anderson", s: "CG", g: 12))
               allAthletes.append(Athlete(f: "Drew", l: "McGinness", s: "CLS", g: 9))
        let letters = "abcdefghijklmnopqrstuvwxyz"
        let chars = Array(letters)
        let schoolArray = ["CLC","CG","CLS","PR"]
        
        for _ in 3...75{
            var first = ""
            var last = ""
            for _ in 0...4{
                first.append(String(chars[Int.random(in: 0 ..< chars.count)]))
                last.append(String(chars[Int.random(in: 0 ..< chars.count)]))
            }
            let school = schoolArray.randomElement()!
            let grade = Int.random(in: 9...12)
            
            allAthletes.append(Athlete(f: first, l: last, s: school, g: grade))
            
        }
        var teams = ["A","B","C","D","E"]
        var levels = ["VAR", "F/S"]
        for school in schoolArray{
            for letter in teams{
                allAthletes.append(Athlete(f: letter, l: school, s: school, g: 12))
        }
        }
               allAthletes[0].addEvent(name: "200M VAR", level: "VAR")
               allAthletes[1].addEvent(name: "100M F/S", level: "F/S")
               allAthletes[2].addEvent(name: "100M VAR", level: "VAR")
        allAthletes.sort(by: {$0.last.localizedCaseInsensitiveCompare($1.last) == .orderedAscending})

        // Do any additional setup after loading the view.
    }
    

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        print(segue.description)
        if segue.identifier == "eventsSegue"{
            let nvc = segue.destination as! EventsTableViewController
            nvc.athletes = allAthletes
        }
        else if segue.identifier == "scoresSegue"{
            let nvc = segue.destination as! ScoresViewController
            nvc.allAthletes = allAthletes
        }
        else{
            let nvc = segue.destination as! AthletesViewController
            nvc.allAthletes = allAthletes
            nvc.delegate = self
        }
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    
   @IBAction func unwind( _ seg: UIStoryboardSegue) {
   let pvc = seg.source as! EventsTableViewController
    allAthletes = pvc.athletes
    allAthletes.sort(by: {$0.last.localizedCaseInsensitiveCompare($1.last) == .orderedAscending})
    print("unwind to home screen")
    
    
    }
    

//    @IBAction func apiTestAction(_ sender: UIButton) {
//        
//       let configuration = URLSessionConfiguration.default
//           let session = URLSession(configuration: configuration)
//        let url = URL(string: "https://docs.google.com/spreadsheets/d/1puxn4zdVrYcJwrEksSktMF-McK6VQhguOqnPOLjaSYQ/edit#gid=0")
//           //let url = NSURL(string: urlString as String)
//           var request : URLRequest = URLRequest(url: url!)
//        https://sheets.googleapis.com/v4/spreadsheets/{spreadsheetId}/values:batchGet
//           request.httpMethod = "GET"
//       
//           request.addValue("application/json", forHTTPHeaderField: "Content-Type")
//           request.addValue("application/json", forHTTPHeaderField: "Accept")
//           let dataTask = session.dataTask(with: url!) { data,response,error in
//              // 1: Check HTTP Response for successful GET request
//              guard let httpResponse = response as? HTTPURLResponse, let receivedData = data
//              else {
//                 print("error: not a valid http response")
//                 return
//              }
//              switch (httpResponse.statusCode) {
//                 case 200:
//                    //success response.
//                    break
//                 case 400:
//                    break
//                 default:
//                    break
//              }
//           }
//           dataTask.resume()
//        }
//    
}
