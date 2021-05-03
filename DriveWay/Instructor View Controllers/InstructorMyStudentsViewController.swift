//
//  InstructorMyStudentViewController.swift
//  DriveWay
//
//  Created by Morgan Eckersley on 03/05/2021.
//

import UIKit
import FirebaseAuth
import FirebaseFirestore

class InstructorMyStudentsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    //MARK: - Outlets and Variables
    
    @IBOutlet weak var studentTableView: UITableView!
    
    
    let userAccInfo = Auth.auth().currentUser!
    var selectedIndex = Int()
    
    struct studentInfo {
        var name: String
        var id: String
    }
    
    var students = [studentInfo]()
    
    // MARK: - UI Setup
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        getStudentInformation()
    }
    

    // MARK: - Table View Functions
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return students.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = studentTableView.dequeueReusableCell(withIdentifier: "myCell") as! myStudentsTableViewCell
        
        cell.studentNameLabel.text = students[indexPath.row].name
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selectedIndex = indexPath.row
        performSegue(withIdentifier: "showStudentDetail", sender: nil)
        
    }
    
    // MARK: - Data Retrieval
    func getStudentInformation() {
        let database = Firestore.firestore()
        let collectionReference = database.collection("Students")
        let query = collectionReference.whereField("instructorID", isEqualTo: userAccInfo.uid)
        
        query.getDocuments { snapshot, err in
            if err != nil {
                print(err.debugDescription)
            } else {
                for document in snapshot!.documents {
                    let studentDocData = document.data()
                    let name = studentDocData["name"]! as! [String : String]
                    let fullName = name["first"]! + " " + name["last"]!
                    
                    let studentID = studentDocData["userID"] as! String
                    
                    let student = studentInfo(name: fullName, id: studentID)
                    
                    self.students.append(student)
                    
                    self.refreshTables()
                }
            }
        }
    }
    
    
    func refreshTables() {
        studentTableView.reloadData()
    }
    
    
    // MARK: - Navigation

     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destination.
     // Pass the selected object to the new view controller.
     let segueName = segue.identifier
     if segueName == "showStudentDetail" {
         let destination = segue.destination as! InstructorMyStudentsDetailsViewController
         destination.studentID = students[selectedIndex].id
        }
     }

}

// MARK: - Custom Student Table View Cell
class myStudentsTableViewCell: UITableViewCell {
    @IBOutlet weak var studentImageView: UIImageView!
    @IBOutlet weak var studentNameLabel: UILabel!
    
}
