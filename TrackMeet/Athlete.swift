//
//  Athlete.swift
//  TrackMeet
//
//  Created by Brian Seaver on 5/17/20.
//  Copyright © 2020 clc.seaver. All rights reserved.
//

import Foundation

public class Athlete{
    var first: String
    var last: String
    var school: String
    var grade: Int
    var events: [Event]
    
    init(f: String, l: String, s: String, g: Int) {
        first = f
        last = l
        school = s
        grade = g
        events = [Event]()
    }
    
    func addEvent(name: String, level: String){
        events.append(Event(name: name, level: level))
    }
    
    func getEvent(eventName: String) -> Event?{
        for e in events{
            if e.name == eventName{
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
    
}



public class Event{
    var name: String
    var level: String
    var mark: Float
    var markString: String
    var place: Int?
    var points = 0.0
    var heat = 0
    
    init(name: String, level: String) {
        self.name = name
        self.level = level
        self.mark = 0.0
        markString = ""
        
        
    }
    
}
