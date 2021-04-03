//
//  School.swift
//  TrackMeet
//
//  Created by Brian Seaver on 4/2/21.
//  Copyright © 2021 clc.seaver. All rights reserved.
//

import Foundation
import Firebase

public class School{
    var full: String
    var inits: String
    var coaches = [String]()
    var uid: String?
    
    init(full: String, inits: String) {
        self.full = full
        self.inits = inits
        
    }
    
    init(key: String, dict: [String:Any]  ){
        uid = key
        full = dict["full"] as! String
        inits = dict["inits"] as! String
        
        //levels = [String]()
        if let coachesArray = dict["coaches"] as? NSArray{
        for i in 0..<coachesArray.count{
            coaches.append(coachesArray[i] as! String)
        }
        }
        
    }
    
    func addCoach(email: String){
        coaches.append(email)
    }
    
    func saveToFirebase(){
        let ref = Database.database().reference()
       
        let dict = ["full": self.full, "inits":self.inits, "coaches": coaches] as [String : Any]
       
        
        let thisUserRef = ref.child("schoolsNew").childByAutoId()
        //var uid = thisUserRef.key
        thisUserRef.setValue(dict)
        
//        for c in coaches{
//            let emails = ["email": c] as [String : Any]
//            let coachID = thisUserRef.child("coaches").childByAutoId()
//            //uid = eventsID.key
//            coachID.setValue(emails)
//            
//        }
    }
    
}