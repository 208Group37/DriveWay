//
//  LearnerDisplayCalendarViewController.swift
//  DriveWay
//
//  Created by Jake Darby on 30/04/2021.
//
//  This file is responsible for showing the learner their calendar, if they have an instructor.

import UIKit
import FirebaseFirestore
import FirebaseAuth

// Define specific colours for use in the cells
extension UIColor {
    static let driveWayRed = UIColor(red: 0.9412, green: 0.4078, blue: 0.4118, alpha: 1) /* #f06869 */
    static let driveWayYellow = UIColor(red: 0.9961, green: 0.8902, blue: 0.5686, alpha: 1) /* #fee391 */
    static let driveWayGreen = UIColor(red: 0.5059, green: 0.8392, blue: 0.3333, alpha: 1) /* #81d655 */
    static let driveWayBlue = UIColor(red: 0.102, green: 0.651, blue: 0.9255, alpha: 1) /* #1aa6ec */
}

class LearnerDisplayCalendarViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    // MARK: - Variable Declaration
    @IBOutlet weak var requestLessonButton: UIButton!
    @IBOutlet weak var lessonTableView: UITableView!
    @IBOutlet weak var lessonDetailTableView: UITableView!
    @IBOutlet weak var nextWeekButton: UIButton!
    @IBOutlet weak var lastWeekButton: UIButton!
    @IBOutlet weak var lastWeekLabel: UILabel!
    @IBOutlet weak var nextWeekLabel: UILabel!
    @IBOutlet weak var nameLabel: UILabel!
    
    struct lesson: Equatable {
        var startTime: String
        var endTime: String
        var date: String
        var status: String
        var studentID: String
        var instructorID: String
        var notes: String
        var dropoff: String
        var pickup: String
        var documentID: String
    }
    
    let userInfo = Auth.auth().currentUser
    var currentWeek = 0
    var selectedLesson = 0
    var firstName = ""
    var instructorName = ""
    var instructorID = ""
    var studentID = ""
    var instructorCost = ""
    
    var lessons = [lesson]()
    
    // MARK: - Button actions
    @IBAction func nextWeekButton(_ sender: Any) {
        currentWeek += 1
        if (currentWeek == 1) {
            nextWeekButton.isHidden = true;
            lastWeekButton.isHidden = false;
            
            nextWeekLabel.isHidden = true;
            lastWeekLabel.text = "This week"
        }
        if (currentWeek == 0) {
            revertButtonsAndLabels()
            
        }
        refreshTables()
    }
    
    @IBAction func lastWeekButton(_ sender: Any) {
        currentWeek -= 1
        if (currentWeek == -1) {
            nextWeekButton.isHidden = false;
            lastWeekButton.isHidden = true;
            
            nextWeekLabel.text = "This week"
            lastWeekLabel.isHidden = true
        }
        if (currentWeek == 0) {
            revertButtonsAndLabels()
        }
        refreshTables()
    }
    
    @IBAction func requestButton(_ sender: Any) {
        let database = Firestore.firestore()
        let collectionReference = database.collection("Instructors")
        let query = collectionReference.whereField("userID", isEqualTo: instructorID)
        query.getDocuments { (snapshot, err) in
            if err != nil {
                print(err.debugDescription)
            } else {
                for document in snapshot!.documents {
                    // All the information stored in the document about the user
                    let userDocData = document.data()
                    let lessonInfo = userDocData["lesson"] as! [String: Any]
                    self.instructorCost = lessonInfo["price"]! as! String
                }
                self.performSegue(withIdentifier: "lessonRequestSegue", sender: nil)
            }
        }
    }
    
    // MARK: - Additional Setup
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        lessonTableView.dataSource = self
        lessonTableView.delegate = self
        lessonDetailTableView.dataSource = self
        lessonDetailTableView.delegate = self
        Utilities.styleTableNeutral(lessonTableView)
        Utilities.styleTableNeutral(lessonDetailTableView)
        lessonTableView.bounces = false
        lessonDetailTableView.bounces = false
        refreshTables()
        displayFirstName()
        Utilities.styleButtonNeutral(requestLessonButton)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        lessons = [lesson]()
        let database = Firestore.firestore()
        let collectionReference = database.collection("Lessons")
        
        collectionReference.getDocuments { (snapshot, err) in
            if err != nil {
                print(err.debugDescription)
            } else {
                for document in snapshot!.documents {
                    // All the information stored in the document about the user
                    let userDocData = document.data()
                    let people = userDocData["people"] as? [String: String]
                    if (people!["studentID"] == self.userInfo!.uid) {
                        let times = userDocData["time"] as? [String: Any]
                        let location = userDocData["location"] as! [String: Any]
                        let newLesson = lesson(startTime: times!["start"]! as! String, endTime: times!["end"]! as! String, date: userDocData["date"] as! String, status: userDocData["status"] as! String, studentID: people!["studentID"]!, instructorID: people!["instructorID"]!, notes: userDocData["notes"] as! String, dropoff: location["end"]! as! String, pickup: location["start"]! as! String, documentID: document.documentID)
                        self.instructorID = people!["instructorID"]!
                        self.studentID = people!["studentID"]!
                        self.lessons.append(newLesson)
                    }
                }
                self.refreshTables()
            }
        }
    }
    
    // What to do when a segue happens
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let detailViewController = segue.destination as? LearnerLessonDetailViewController {
            detailViewController.date = lessons[selectedLesson].date
            detailViewController.time = " \(lessons[selectedLesson].startTime) - \(lessons[selectedLesson].endTime)"
            detailViewController.studentName = firstName
            detailViewController.instructorName = instructorName
            detailViewController.pickup = lessons[selectedLesson].pickup
            detailViewController.dropoff = lessons[selectedLesson].dropoff
            detailViewController.notes = lessons[selectedLesson].notes
            detailViewController.status = lessons[selectedLesson].status
            detailViewController.documentID = lessons[selectedLesson].documentID
        }
        if let lessonRequestViewController = segue.destination as? LearnerLessonRequestViewController {
            lessonRequestViewController.instructorID = self.instructorID
            lessonRequestViewController.studentID = self.studentID
            lessonRequestViewController.instructorCost = Int(self.instructorCost)!
        }
    }
    
    // MARK: - Custom Functions
    // A function that gets the current week of dates
    func getNextWeekDates(_ week: Int) -> [String] {
        let date = Date()
        let formatter = DateFormatter()
        formatter.dateFormat = "EEEE, d MMM yyyy"
        var dateWeek = [String]()
        
        for i in week*7...week*7+7 {
            dateWeek.append(formatter.string(from: date.addingTimeInterval(TimeInterval(86400*i))))
        }
        return dateWeek
    }
    
    // A function that reloads both tables in the view controller
    func refreshTables() {
        lessonTableView.reloadData()
        lessonDetailTableView.reloadData()
    }
    
    // A function that sets the buttons and labels on this view controller back to their default state
    func revertButtonsAndLabels() {
        nextWeekButton.isHidden = false;
        lastWeekButton.isHidden = false;
        
        nextWeekLabel.text = "Next week"
        lastWeekLabel.text = "Last week"
        nextWeekLabel.isHidden = false
        lastWeekLabel.isHidden = false
    }
    
    // A function that pulls the user's first name from the database and sets the label in the view controller
    func displayFirstName() {
        let database = Firestore.firestore()
        let collectionReference = database.collection("Students")
        let query = collectionReference.whereField("userID", isEqualTo: userInfo!.uid)
        var firstName = ""
        
        query.getDocuments { (snapshot, err) in
            if err != nil {
                print(err.debugDescription)
            } else {
                for document in snapshot!.documents {
                    // All the information stored in the document about the user
                    let userDocData = document.data()
                    let names = userDocData["name"] as? [String: String]
                    firstName = names!["first"]!
                    self.instructorID = userDocData["instructorID"] as! String
                    self.nameLabel?.text = "Hi, \(firstName)"
                    self.firstName = firstName
                }
            }
        }
    }
    
    // Sets the colour of a cell, given the status of the lesson
    func changeCellColour(cell: UITableViewCell, lessonStatus: String) {
        switch lessonStatus {
        case "Accepted":
            cell.backgroundColor = UIColor.driveWayGreen
        case "Pending":
            cell.backgroundColor = UIColor.driveWayYellow
        case "Cancelled":
            cell.backgroundColor = UIColor.driveWayRed
        case "Done":
            cell.backgroundColor = UIColor.driveWayBlue
        default:
            cell.backgroundColor = UIColor.white
        }
    }
    
    // MARK: - Table View Functions
    
    // Sets the number of rows per section in a table
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 7
    }
    
    // Defines what values are put in the separate table views
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let dates = getNextWeekDates(currentWeek)
        // If the table view is the table that contains the dates
        if (tableView == lessonTableView) {
            let cell = tableView.dequeueReusableCell(withIdentifier: "date", for: indexPath)
            cell.textLabel?.text = dates[indexPath.row]
            cell.textLabel?.numberOfLines = 2
            cell.selectionStyle = UITableViewCell.SelectionStyle(rawValue: 0)!
            return cell
        }
        
        // If the table view is the table that contains lesson information
        else if (tableView == lessonDetailTableView) {
            let cell = tableView.dequeueReusableCell(withIdentifier: "lessonDetails", for: indexPath)
            if (lessons != [lesson]()) {
                for i in 0..<lessons.count {
                    if (lessons[i].date == dates[indexPath.row]) {
                        cell.textLabel?.text = "\(lessons[i].startTime) - \(lessons[i].endTime) (\(lessons[i].status))"
                        cell.detailTextLabel?.text = lessons[i].pickup
                        changeCellColour(cell: cell, lessonStatus: lessons[i].status)
                        cell.selectionStyle = UITableViewCell.SelectionStyle(rawValue: 1)!
                        return cell
                    }
                    else if (lessons[i].date != dates[indexPath.row] && i == lessons.count-1) {
                        cell.textLabel?.text = ""
                        cell.detailTextLabel?.text = ""
                        cell.backgroundColor = UIColor.lightGray
                        cell.selectionStyle = UITableViewCell.SelectionStyle(rawValue: 0)!
                        return cell
                    }
                }
            }
        }
        // Dummy cell created so that the app won't crash if, for some reason, the correct table view isn't found
        return UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let dates = getNextWeekDates(currentWeek)
        for i in 0..<lessons.count {
            if (lessons[i].date == dates[indexPath.row]) {
                selectedLesson = i
            }
        }
        let database = Firestore.firestore()
        let collectionReference = database.collection("Instructors")
        let query = collectionReference.whereField("userID", isEqualTo: lessons[selectedLesson].instructorID)
        print(lessons[selectedLesson].instructorID)
        query.getDocuments { (snapshot, err) in
            if err != nil {
                print(err.debugDescription)
            } else {
                for document in snapshot!.documents {
                    // All the information stored in the document about the user
                    let userDocData = document.data()
                    let name = userDocData["name"] as? [String: String]
                    self.instructorName = "\(name!["first"]!) \(name!["last"]!)"
                    self.performSegue(withIdentifier: "toLessonDetailSegue", sender: nil)
                }
            }
        }
    }
    
    

}
