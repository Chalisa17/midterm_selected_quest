//
//  InsertViewController.swift
//  test_sql
//
//  Created by Admin on 4/3/2562 BE.
//  Copyright © 2562 Admin. All rights reserved.
//

import UIKit
import SQLite3

class InsertViewController: UIViewController {

    @IBOutlet weak var phone: UITextField!
    @IBOutlet weak var name: UITextField!
    @IBOutlet weak var inputTextField: UITextField!
    @IBOutlet weak var satisfaction: UITextField!
    let fileName = "db6.sqlite"
    let fileManager = FileManager .default
    var dbPath = String()
    var sql = String()
    var db: OpaquePointer?
    var stmt: OpaquePointer?
    var pointer: OpaquePointer?
    
    @IBAction func bad(_ sender: Any) {
        satisfaction.text = "ไม่พอใจ"
        
    }
    @IBAction func merely(_ sender: Any) {
        satisfaction.text = "เฉยๆ"
    }
    @IBAction func smile(_ sender: Any) {
        satisfaction.text = "ยิ้ม"
    }
    @IBAction func savedate(_ sender: Any) {
        let name1 = name.text! as NSString
        let phone1 = phone.text! as NSString
        let currentDate = inputTextField.text! as NSString
        let satisfaction1 = satisfaction.text! as NSString
        
        self.sql = "INSERT INTO people VALUES (null, ?, ?, ?, ?)"
        sqlite3_prepare(self.db, self.sql, -1, &self.stmt, nil)
        sqlite3_bind_text(self.stmt, 1, name1.utf8String, -1, nil)
        sqlite3_bind_text(self.stmt, 2, phone1.utf8String, -1, nil)
        sqlite3_bind_text(self.stmt, 3, satisfaction1.utf8String, -1, nil)
        sqlite3_bind_text(self.stmt, 4, currentDate.utf8String, -1, nil)
        sqlite3_step(self.stmt)
        
    }
    private var datePicker: UIDatePicker?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        satisfaction.isUserInteractionEnabled = false
        let dbURL = try! fileManager .url(
            for: .documentDirectory,
            in: .userDomainMask,
            appropriateFor: nil,
            create: false)
            .appendingPathComponent(fileName)
        
        let opendb = sqlite3_open(dbURL.path, &db)
        if opendb != SQLITE_OK {
            print("Opening Database Error")
            return
        }
        else {
            print("Opening Database")
        }
        
        datePicker = UIDatePicker()
        datePicker?.datePickerMode = .date
        datePicker?.addTarget(self, action: #selector(InsertViewController.dateChanged(datePicker:)), for: .valueChanged)
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(InsertViewController.viewTapped(gestureRecognizer:)))
        
        view.addGestureRecognizer(tapGesture)
        
        inputTextField.inputView = datePicker
        
        // Do any additional setup after loading the view.
    }
    
    @objc func viewTapped(gestureRecognizer: UITapGestureRecognizer){
        view.endEditing(true)
    }
    
    @objc func dateChanged(datePicker: UIDatePicker){
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MM/dd/yyyy"
        inputTextField.text = dateFormatter.string(from: datePicker.date)
        view.endEditing(true)
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
