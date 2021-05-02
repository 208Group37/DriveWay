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
    
    // MARK: - Lesson Struct
    struct lesson: Equatable {
        var duration: String
        var startTime: String
        var endTime: String
        var date: String
        var startLocation: GeoPoint
        var endLocation: GeoPoint
        var instructorId: String
        var studentId: String
    }
    
    @IBOutlet weak var greetingLabel: UILabel!
    @IBOutlet weak var timeTableView: UITableView!
    
    let userInfo = Auth.auth().currentUser
    var viewingDate = ""
    var lessonArray = [lesson]()
    var instructorName = ""
    
    // MARK: - Table set up
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return lessonArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "myCell", for: indexPath) as! timetableViewCell
        let lesson = lessonArray[indexPath.row]
        
        let database = Firestore.firestore()
        let collectionReference = database.collection("Students")
        let query = collectionReference.whereField("userID", isEqualTo: lesson.studentId)
        
        query.getDocuments { (snapshot, err) in
            if err != nil {
                print("There was an error, \(err.debugDescription)")
            } else {
                for document in snapshot!.documents {
                    let nameData = document.data()["name"] as? [String: String]
                    let name = nameData!["first"]! + " " + nameData!["last"]!
                    cell.lessonDetailField.text = name + " at " + "placeholder"
                }
            }
        }
        
        cell.timeField.text = lesson.startTime + " - " + lesson.endTime
        return cell
    }
    
    /*
    func getLocationName(pointToGeocode: GeoPoint) -> String {
        var locationName = ""
        
        return locationName
    }*/

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let formatter = DateFormatter()
        formatter.dateStyle = .full
        let dateString = formatter.string(from: Date())
        viewingDate = dateString
        
        let database = Firestore.firestore()
        let collectionReference = database.collection("Instructors")
        let query = collectionReference.whereField("userID", isEqualTo: userInfo?.uid)
        
        query.getDocuments { (snapshot, err) in
            if err != nil {
                print("There was an error, \(err.debugDescription)")
            } else {
                for document in snapshot!.documents {
                    let nameData = document.data()["name"] as? [String: String]
                    self.greetingLabel.text = "Hi, " + (nameData?["first"])!
                }
            }
        }
        let testStart = GeoPoint(latitude: 1.0, longitude: 0.1)
        let testEnd = GeoPoint(latitude: 30.2, longitude: 12.1)
        let newLesson = lesson(duration: "2", startTime: "18:00", endTime: "19:00", date: "Sunday, May 2, 2021", startLocation: testStart, endLocation: testEnd, instructorId: "lx8GcYCUE8M7QDSjRrJrBsorJwp2", studentId: "mHhitRpSyZUVuooVE4982IP11Z83")
        self.lessonArray.append(newLesson)
        retrieveLessons()
        lessonArray.sort(by: {
            ($0.startTime as? Date)! > ($1.startTime as? Date)!
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

    // MARK: - Load lessons
    func retrieveLessons() {
        let database = Firestore.firestore()
        let collectionReference = database.collection("Lessons")
        let query = collectionReference.whereField("date", isEqualTo: viewingDate)//.whereField("instructor", isEqualTo: userInfo!.uid)
        
        query.getDocuments { (snapshot, err) in
            if err != nil {
                print("There was an error, \(err.debugDescription)")
            } else {
                for document in snapshot!.documents {
                    let userDocData = document.data()
                    let times = userDocData["time"] as? [String: String]
                    let locations = userDocData["location"] as? [String: GeoPoint]
                    let people = userDocData["people"] as? [String: String]
                    let newLesson = lesson(duration: times!["duration"]!, startTime: times!["start"]!, endTime: times!["end"]!, date: userDocData["date"] as! String,startLocation: locations!["start"]!, endLocation: locations!["end"]!, instructorId: people!["instructorID"]!, studentId: people!["studentID"]!)
                    self.lessonArray.append(newLesson)
                }
                print(self.lessonArray)
                self.timeTableView.reloadData()
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
