//
//  InstructorTimetableViewController.swift
//  DriveWay
//
//  Created by Christian Carroll on 30/04/2021.
//

import UIKit
import FirebaseFirestore
import FirebaseAuth

class InstructorTimetableViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var greetingLabel: UILabel!
    
    let userInfo = Auth.auth().currentUser
    var viewingDate = ""
    var lessonArray: [Dictionary<String, Any>] = []
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return lessonArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCell(withIdentifier: "myCell", for: indexPath) as! timetableViewCell
        let lesson = self.lessonArray[indexPath.row]
        cell.timeField.text = (lesson["start"] as! String) + "/n" + (lesson["end"] as! String)
        let studentName = retrieveName(databaseChoice: "Student",id: lesson["studentID"] as! String)
        cell.lessonDetailField.text = studentName + "/n" + "placeholder"
        return cell
    }
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let formatter = DateFormatter()
        formatter.dateStyle = .short
        let dateString = formatter.string(from: Date())
        viewingDate = dateString
        let instructorName = retrieveName(databaseChoice: "Instructors",id: userInfo!.uid)
        self.greetingLabel.text = "Hi, " + instructorName
        retrieveLessons()
        lessonArray.sort(by: {
            ($0["start"] as? Date)! > ($1["start"] as? Date)!
        })

        // Do any additional setup after loading the view.
    }
    
    func retrieveName(databaseChoice: String ,id : String) -> String {
        var name = ""
        let database = Firestore.firestore()
        let collectionReference = database.collection(databaseChoice)
        let query = collectionReference.whereField("userID", isEqualTo: id)
        
        query.getDocuments { (snapshot, err) in
            if err != nil {
                print("There was an error, \(err.debugDescription)")
            } else {
                for document in snapshot!.documents {
                    let nameData = document.data()["name"] as? [String: String]
                    name = name + nameData!["first"]! + " " + nameData!["last"]!
                }
            }
        }
        return name
    }

    func retrieveLessons() {
        let database = Firestore.firestore()
        let collectionReference = database.collection("Lessons")
        let query = collectionReference.whereField("instructor", isEqualTo: userInfo!.uid).whereField("date", isEqualTo: viewingDate)
        
        query.getDocuments { (snapshot, err) in
            if err != nil {
                print("There was an error, \(err.debugDescription)")
            } else {
                for document in snapshot!.documents {
                    self.lessonArray.append(document.data())
                }
            }
        }
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
