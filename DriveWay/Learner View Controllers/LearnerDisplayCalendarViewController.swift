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
        var duration: String
        var startTime: String
        var endTime: String
        var date: String
    }
    
    let userInfo = Auth.auth().currentUser
    var currentWeek = 0
    
    var lessons = [lesson]()
    
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
        
        Utilities.styleButtonNeutral(requestLessonButton)
        displayFirstName()
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
                        let times = userDocData["time"] as? [String: String]
                        let newLesson = lesson(duration: times!["duration"]!, startTime: times!["start"]!, endTime: times!["end"]!, date: userDocData["date"] as! String)
                        self.lessons.append(newLesson)
                    }
                }
                self.refreshTables()
            }
        }
    }
    
    // MARK: - Custom Functions
    // A function that gets the current week of dates
    func getNextWeekDates(_ week: Int) -> [String] {
        let date = Date()
        let formatter = DateFormatter()
        formatter.dateStyle = .full
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
                    self.nameLabel?.text = "Hi, \(firstName)"
                }
            }
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
        print(dates)
        // If the table view is the table that contains the dates
        if (tableView == lessonTableView) {
            let cell = tableView.dequeueReusableCell(withIdentifier: "date", for: indexPath)
            cell.textLabel?.text = dates[indexPath.row]
            cell.selectionStyle = UITableViewCell.SelectionStyle(rawValue: 0)!
            return cell
        }
        
        // If the table view is the table that contains lesson information
        else if (tableView == lessonDetailTableView) {
            let cell = tableView.dequeueReusableCell(withIdentifier: "lessonDetails", for: indexPath)
            if (lessons != [lesson]()) {
                print(lessons)
                for i in 0..<lessons.count {
                    if (lessons[i].date == dates[indexPath.row]) {
                        cell.textLabel?.text = "\(lessons[i].startTime) - \(lessons[i].endTime)"
                        cell.detailTextLabel?.text = "\(lessons[i].duration) hours"
                        cell.backgroundColor = UIColor.white
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
    
    

}
