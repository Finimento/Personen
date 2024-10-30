//
//  Person.swift
//  Personen
//
//  Created by Mike Finimento on 30.10.24.
//

import Foundation

class Person: Codable{
    
    var name: String
    
    init(name: String){
        self.name = name
    }
    
    static func loadPersons() -> [Person]{
        var myPersonsArray = [Person]()
        myPersonsArray.append(Person(name: "Max Mustermann"))
        myPersonsArray.append(Person(name: "Frieda Willhemson"))
        myPersonsArray.append(Person(name: "Karl der Große"))
        
        return myPersonsArray
    }
}
