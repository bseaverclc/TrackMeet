//
//  Meet.swift
//  TrackMeet
//
//  Created by Brian Seaver on 5/24/20.
//  Copyright © 2020 clc.seaver. All rights reserved.
//

import Foundation

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
    }
    
    
    
}
