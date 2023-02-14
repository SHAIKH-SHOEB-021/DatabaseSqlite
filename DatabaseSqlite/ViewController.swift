//
//  ViewController.swift
//  DatabaseSqlite
//
//  Created by shoeb on 13/02/23.
//

import UIKit

class ViewController: UIViewController {

    var db = DBManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        db.insert(id: 3, name: "Nitesh", age: 24)
        db.read()
    }


}

