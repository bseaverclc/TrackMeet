//
//  Meet.swift
//  TrackMeet
//
//  Created by Brian Seaver on 5/24/20.
//  Copyright © 2020 clc.seaver. All rights reserved.
//

import Foundation
import Firebase

public class Meet: Codable{
    
    var name : String
    var date : Date
     var schools: [String : String]
    var gender : String
    var levels: [String]
    var events: [String]
    var indPoints: [Int]
    var relPoints: [Int]
    var beenScored: [Bool]
    var uid : String?
    
    
    init(key: String, dict: [String:Any]  ){
        uid = key
        name = dict["name"] as! String
        
        let formatter1 = DateFormatter()
        formatter1.dateFormat = "MM/dd/yy"
        if let d = formatter1.date(from: dict["date"] as! String){
        date = d
        }
        else{ date = Date()}
        
        gender = dict["gender"] as! String
        
        
        schools = dict["schools"] as! [String:String]
        
        levels = [String]()
        if let levelsArray = dict["levels"] as? NSArray{
        for i in 0..<levelsArray.count{
            levels.append(levelsArray[i] as! String)
        }
        }
        
        events = [String]()
        if let eventsArray = dict["events"] as? NSArray{
        for i in 0..<eventsArray.count{
            events.append(eventsArray[i] as! String)
        }
        }
        
        indPoints = [Int]()
        if let indPointsArray = dict["indPoints"] as? NSArray{
        for i in 0..<indPointsArray.count{
            indPoints.append(indPointsArray[i] as! Int)
        }
        }
        
        relPoints = [Int]()
        if let relPointsArray = dict["relPoints"] as? NSArray{
        for i in 0..<relPointsArray.count{
            relPoints.append(relPointsArray[i] as! Int)
        }
        }
        
        beenScored = [Bool]()
        if let beenScoredArray = dict["beenScored"] as? NSArray{
        for i in 0..<beenScoredArray.count{
            beenScored.append(beenScoredArray[i] as! Bool)
        }
        }
        

    }
    
    init(name n : String, date d:Date, schools s: [String:String], gender g: String, levels l : [String], events e : [String], indPoints ip:  [Int], relpoints rp : [Int],  beenScored se: [Bool] ){
        name = n
        date = d
        schools = s
        gender = g
        levels = l
        events = e
        indPoints = ip
        relPoints = rp
        beenScored = se
        saveMeetToFirebase()
    }
    
    func saveMeetToFirebase(){
        let ref = Database.database().reference()
        
        
        let formatter1 = DateFormatter()
        formatter1.dateStyle = .short
        let dateString = formatter1.string(from: date)
       
        let dict = ["name": self.name, "date": dateString, "schools": self.schools, "gender":self.gender, "levels":self.levels, "events": self.events, "indPoints":self.indPoints, "relPoints": self.relPoints, "beenScored": self.beenScored] as [String : Any]
       
        
        let thisUserRef = ref.child("meets").childByAutoId()
        uid = thisUserRef.key
        
        thisUserRef.setValue(dict)
    }
    
    func deleteFromFirebase(){
        if let ui = uid{
        let ref = Database.database().reference().child("meets").child(ui).removeValue()
        print("Meet has been removed from Firebase")
        }
        else{
            print("Error Deleting Athlete! Athlete not in Firebase")
        }
    }
    
    
    
}
