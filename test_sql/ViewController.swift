//
//  ViewController.swift
//  test_sql
//
//  Created by Admin on 4/3/2562 BE.
//  Copyright © 2562 Admin. All rights reserved.
//

import UIKit
import SQLite3

class ViewController: UIViewController {
    @IBOutlet weak var textView: UITextView!
    let fileName = "db5.sqlite"
    let fileManager = FileManager.default
    var dbPath = String()
    var sql = String()
    var db : OpaquePointer?
    var stmt: OpaquePointer?
    var pointer: OpaquePointer?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let dbURL = try! fileManager.url(
            for: .documentDirectory,
            in: .userDomainMask,
            appropriateFor: nil,
            create: false)
            .appendingPathComponent(fileName)
        
        let openDb = sqlite3_open(dbURL.path, &db)
        if openDb != SQLITE_OK{
            print("Openting Database Error!")
            return
        }
        sql = "CREATE TABLE IF NOT EXISTS people " +
            "(id INTEGER PRIMARY KEY AUTOINCREMENT," +
            "name TEXT," +
            "place TEXT," +
            "satisfaction TEXT," +
        "datepic TEXT)"
        let createTb = sqlite3_exec(db, sql, nil, nil, nil)
        if createTb != SQLITE_OK{
            let err = String(cString: sqlite3_errmsg(db))
            print(err)
        }
        
        
        select()
    }
    
    
    
    @IBAction func buttonDeleteDidTap(_ sender: UIBarButtonItem) {
        let alert = UIAlertController(title: "Delete",
                                      message: "ใส่ ID ของแถวที่ต้องการลบ",
                                      preferredStyle: .alert)
        
        alert.addTextField(configurationHandler: { tf in
            tf.placeholder = "ID ของแถวที่ต้องการลบ"
            tf.font = UIFont.systemFont(ofSize: 18)
            tf.keyboardType = .numberPad
        })
        
        let btCancel = UIAlertAction(title: "Cancel",
                                     style: .cancel,
                                     handler: nil)
        
        let btOK = UIAlertAction(title: "OK",
                                 style: .default,
                                 handler: { _ in
                                    guard let id = Int32(alert.textFields!.first!.text!) else {
                                        return
                                    }
                                    self.sql = "DELETE FROM people WHERE id = \(id)"
                                    sqlite3_exec(self.db, self.sql, nil,nil,nil)
                                    self.select()
        })
        
        alert.addAction(btCancel)
        alert.addAction(btOK)
        present(alert, animated: true, completion: nil)
    }
    func select () {
        
        sql = "SELECT * FROM people"
        sqlite3_prepare(db, sql, -1, &pointer, nil)
        textView.text = ""
        var id: Int32
        var name: String
        var place: String
        var datepic: String
        var satisfaction: String
        
        while(sqlite3_step(pointer) == SQLITE_ROW){
            id = sqlite3_column_int(pointer, 0)
            
            
            name = String(cString: sqlite3_column_text(pointer,1))
            
            
            place = String(cString: sqlite3_column_text(pointer,2))
            
            
            satisfaction = String(cString: sqlite3_column_text(pointer, 3))
            
            
            datepic = String(cString: sqlite3_column_text(pointer, 4))
            
            textView.text?.append("id: \(id)\n")
            textView.text?.append("วันที่: \(datepic)\n")
            textView.text?.append("สถานที่: \(place)\n")
            textView.text?.append("สินค้า: \(name)\n")
            textView.text?.append("ความพึงพอใจ: \(satisfaction)\n")
            
            
            
           
            
            
            
        }
    }
}

