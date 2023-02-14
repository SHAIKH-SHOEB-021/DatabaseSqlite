//
//  DBManager.swift
//  DatabaseSqlite
//
//  Created by shoeb on 13/02/23.
//

import Foundation
import SQLite3

class DBManager{
    
    init(){
        db = openDatabase()
        createTable()
    }
    
    let dbPath = "DatabaseSqlite.db"
    var db : OpaquePointer?
    
    func openDatabase() -> OpaquePointer? {
        let filePath = try! FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false).appendingPathComponent(dbPath)
        var db: OpaquePointer? = nil
        if sqlite3_open(filePath.path, &db) != SQLITE_OK{
            print("Can't open database")
            return nil
        }else{
            print("Successfully created connection to database at \(filePath.path)")
            return db
        }
    }
    
    func createTable(){
        let createTableStr = "CREATE TABLE IF NOT EXISTS details(id, name, age);"
        var createTableStatement : OpaquePointer? = nil
        if sqlite3_prepare_v2(db, createTableStr, -1, &createTableStatement, nil) == SQLITE_OK {
            if sqlite3_step(createTableStatement) == SQLITE_DONE{
                print("Details Table Created")
            }else{
                print("Details Table Could Not Be Created")
            }
        }else{
            print("Create Table Statement Could Not Be Prepare")
        }
        sqlite3_finalize(createTableStatement)
    }
    
    func insert(id: Int, name: String, age: Int){
        let details = read()
        for d in details
        {
            if d.id == id
            {
                return
            }
        }
        let insertStatementStr = "INSERT INTO details(id, name, age) VALUES (?, ?, ?);"
        var insertStatement: OpaquePointer? = nil
        if sqlite3_prepare_v2(db, insertStatementStr, -1, &insertStatement, nil) == SQLITE_OK {
            sqlite3_bind_int(insertStatement, 1, Int32(id))
            sqlite3_bind_text(insertStatement, 2, (name as NSString).utf8String, -1, nil)
            sqlite3_bind_int(insertStatement, 3, Int32(age))
            if sqlite3_step(insertStatement) == SQLITE_DONE{
                print("Successfully Insert Row")
            }else{
                print("Could Not Insert Row")
            }
        }else{
            print("Insert Statement could Not Prepare")
        }
        sqlite3_finalize(insertStatement)
    }
    
    func read() -> [Details] {
        let queryStatementStr = "SELECT * FROM details"
        var queryStatement : OpaquePointer? = nil
        var detailDatas : [Details] = []
        if sqlite3_prepare_v2(db, queryStatementStr, -1, &queryStatement, nil) == SQLITE_OK {
            while sqlite3_step(queryStatement) == SQLITE_ROW{
                let id = sqlite3_column_int(queryStatement, 0)
                let name = String(describing: String(cString: sqlite3_column_text(queryStatement, 1)))
                let age = sqlite3_column_int(queryStatement, 3)
                detailDatas.append(Details(id: Int(id), name: name, age: Int(age)))
                print("Query Result:")
                print("\(id) | \(name) | \(age)")
            }
        } else {
            print("SELECT statement could not be prepared")
        }
        sqlite3_finalize(queryStatement)
        return detailDatas
    }
    
    func deleteByID(id:Int) {
        let deleteStatementStirng = "DELETE FROM details WHERE id = ?;"
        var deleteStatement: OpaquePointer? = nil
        if sqlite3_prepare_v2(db, deleteStatementStirng, -1, &deleteStatement, nil) == SQLITE_OK {
            sqlite3_bind_int(deleteStatement, 1, Int32(id))
            if sqlite3_step(deleteStatement) == SQLITE_DONE {
                print("Successfully Deleted Row.")
            } else {
                print("Could Not Delete Row.")
            }
        } else {
            print("Delete Statement Could Not Be Prepare")
        }
        sqlite3_finalize(deleteStatement)
    }
}
