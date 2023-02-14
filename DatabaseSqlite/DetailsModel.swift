//
//  DetailsModel.swift
//  DatabaseSqlite
//
//  Created by shoeb on 13/02/23.
//

import Foundation

class Details{
    
    var id : Int!
    var name : String!
    var age : Int!
    
    init(id: Int, name: String, age: Int){
        self.id = id
        self.name = name
        self.age = age
    }
}
