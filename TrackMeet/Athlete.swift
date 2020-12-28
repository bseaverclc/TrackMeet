//
//  Athlete.swift
//  TrackMeet
//
//  Created by Brian Seaver on 5/17/20.
//  Copyright © 2020 clc.seaver. All rights reserved.
//

import Foundation
import FirebaseDatabase
enum levels{
    
}

public class Athlete : Codable{
    var first: String
    var last: String
    var school: String
    var schoolFull: String
    var grade: Int
    var events: [Event]
    var uid: String?
    
    init(f: String, l: String, s: String, g: Int, sf: String) {
        first = f
        last = l
        school = s
        grade = g
        events = [Event]()
        schoolFull = sf
        //saveToFirebase()
    }
    
    func addEvent(name: String, level: String, meetName: String){
        events.append(Event(name: name, level: level, meetName: meetName))
    }
    
    func getEvent(eventName: String, meetName: String) -> Event?{
        for e in events{
            if e.name == eventName && e.meetName == meetName{
                return e
            }
        }
        return nil
    }
    
    func equals(other: Athlete) -> Bool{
        if (self.first == other.first && self.last == other.last && self.school == other.school){
            return true
        }
        else{return false}
    }
    
    func saveToFirebase() {
        let ref = Database.database().reference()
       
        let dict = ["first": self.first, "last":self.last, "school": self.school, "schoolFull":self.schoolFull, "grade":self.grade] as [String : Any]
       
        
        let thisUserRef = ref.child("athletes").childByAutoId()
        uid = thisUserRef.key
        thisUserRef.setValue(dict)
        
        for e in events{
            let eventDict = ["meetName": e.meetName,"name": e.name, "level":e.level, "mark": e.mark, "markString": e.markString, "place":e.place ?? 0 , "points": e.points] as [String : Any]
            let eventsID = thisUserRef.childByAutoId()
            e.uid = eventsID.key
            eventsID.setValue(eventDict)
            
        }
     print("saving athlete to firebase")
     }
    
    func updateFirebase(){
        let ref = Database.database().reference().child("athletes").child(uid!)
        let dict = ["first": self.first, "last":self.last, "school": self.school, "schoolFull":self.schoolFull, "grade":self.grade] as [String : Any]
        
        ref.updateChildValues(dict)
        
        for e in events{
            let eventDict = ["meetName": e.meetName,"name": e.name, "level":e.level, "mark": e.mark, "markString": e.markString, "place":e.place ?? 0 , "points": e.points] as [String : Any]
            ref.child(e.uid!).updateChildValues(eventDict)
        
        print("updating athlete in firebase")
        
    }
}
   
    func deleteFromFirebase(){
        let ref = Database.database().reference().child("athletes").child(uid!)
        ref.removeValue()
    }
    
    
}



public class Event:Codable{
    var name: String
    var level: String
    var mark: Float
    var markString: String
    var place: Int?
    var points = 0.0
    var heat = 0
    var meetName = ""
    var uid : String?
    
    init(name: String, level: String, meetName: String) {
        self.name = name
        self.level = level
        self.mark = 0.0
        markString = ""
        self.meetName = meetName
        
        
    }
    
}
