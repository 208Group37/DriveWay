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
    //This will hold the data of each lesson to be displayed
    struct lesson: Equatable {
        var duration: String
        var startTime: String
        var endTime: String
        var date: String
        var startLocation: String
        var endLocation: String
        var instructorId: String
        var studentId: String
        var status: String
        var notes: String
        var lessonId: String
    }
    
    //Label outlets
    @IBOutlet weak var greetingLabel: UILabel!
    @IBOutlet weak var timeTableView: UITableView!
    @IBOutlet weak var viewingDateLabel: UILabel!
    
    // MARK: - Button actions
    //These are the actions for the buttons that change the day that the user is looking at. Each of them changes the date by one day (forward or backward), clears the array that holds the lessons for the day being viewed, then calls the function to retrieve the lessons for the day that has been changed to
    @IBAction func previousDayButton(_ sender: Any) {
        viewingDate = Calendar.current.date(byAdding: .day, value: -1, to: viewingDate)!
        let formatter = DateFormatter()
        formatter.locale = Locale.init(identifier: "en_GB")
        formatter.dateStyle = .full
        viewingDateString = formatter.string(from: viewingDate)
        viewingDateLabel.text = viewingDateString
        lessonArray = []
        retrieveLessons()
    }
    
    @IBAction func nextDayButton(_ sender: Any) {
        viewingDate = Calendar.current.date(byAdding: .day, value: 1, to: viewingDate)!
        let formatter = DateFormatter()
        formatter.locale = Locale.init(identifier: "en_GB")
        formatter.dateStyle = .full
        viewingDateString = formatter.string(from: viewingDate)
        viewingDateLabel.text = viewingDateString
        lessonArray = []
        retrieveLessons()
    }
    
    
    let userInfo = Auth.auth().currentUser
    //Storing the date currently being viewed in both a date object and a string for convenience
    var viewingDate = Date()
    var viewingDateString = ""
    //This array holds all the lessons for the day that is being viewed
    var lessonArray = [lesson]()
    var instructorName = ""
    var selectedLesson = -1
    
    // MARK: - Table set up
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return lessonArray.count
    }
    
    //Fill the table with the lessons for the day being viewed. It fills in the time and then the student's name for each lesson. To get the student's name it has to query the database.
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "myCell", for: indexPath) as! timetableViewCell
        //get an individual lesson
        let lesson = lessonArray[indexPath.row]
        //make a query
        let database = Firestore.firestore()
        let collectionReference = database.collection("Students")
        let query = collectionReference.whereField("userID", isEqualTo: lesson.studentId)
        //get the name and put it into the label
        query.getDocuments { (snapshot, err) in
            if err != nil {
                print("There was an error, \(err.debugDescription)")
            } else {
                for document in snapshot!.documents {
                    let nameData = document.data()["name"] as? [String: String]
                    let name = nameData!["first"]! + " " + nameData!["last"]!
                    if lesson.status == "Pending" {
                        cell.lessonDetailField.text = name + " - Request Pending"
                    } else {
                        cell.lessonDetailField.text = name
                    }
                }
            }
        }
        //put the time into the time label
        cell.timeField.text = lesson.startTime + " - " + lesson.endTime
        return cell
    }
    
    override func viewDidAppear(_ animated: Bool) {
        //get today's date and format it into a string
        let formatter = DateFormatter()
        formatter.locale = Locale.init(identifier: "en_GB")
        formatter.dateStyle = .full
        viewingDateString = formatter.string(from: Date())
        //then display it
        viewingDateLabel.text = viewingDateString
        
        //Make a query to get the instructors name
        let database = Firestore.firestore()
        let collectionReference = database.collection("Instructors")
        let query = collectionReference.whereField("userID", isEqualTo: userInfo?.uid)
        //This is just for getting the name for the greeting label
        query.getDocuments { (snapshot, err) in
            if err != nil {
                print("There was an error, \(err.debugDescription)")
            } else {
                for document in snapshot!.documents {
                    let nameData = document.data()["name"] as? [String: String]
                    //put the name into a greeting label
                    self.greetingLabel.text = "Hi, " + (nameData?["first"])!
                }
            }
        }
        //clear the timetable then get the lessons, with any updates if they have been made
        lessonArray = []
        retrieveLessons()
    }

    //All set up is done in the viewDidAppear as that will do it each time the screen is viewed
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
    }
    
    // MARK: - Lesson sorting functions
    //This function is to make the comparison of times in the sortLessons function more convienient
    func parseTimeForComparison(timeString: String) -> Int {
        let componentArray = timeString.components(separatedBy: ":")
        let comparisonNumb = Int(componentArray[0]) ?? 0 * 60 + Int(componentArray[1])!
        return comparisonNumb
    }
    
    //This function uses an insertion sort to sort the array of lessons by time
    func sortLessons(array: [lesson]) -> [lesson] {
        var outputArray = array
        
        for item in 0..<array.count {
            let key = parseTimeForComparison(timeString: outputArray[item].startTime)
            var i = item-1
            
            while (i > 0 && parseTimeForComparison(timeString: outputArray[i].startTime) > key){
                outputArray[i+1] = outputArray[i]
                i = i-1
            }
            outputArray[i+1] = outputArray[item]
        }
        return outputArray
    }

    // MARK: - Load lessons
    func retrieveLessons() {
        //Make a query to get the lessons
        let database = Firestore.firestore()
        let collectionReference = database.collection("Lessons")
        //They have to be on the day being viewed and for the instructor/user
        let query = collectionReference.whereField("date", isEqualTo: viewingDateString)//.whereField("instructorID", isEqualTo: userInfo!.uid as! String)
        
        query.getDocuments { (snapshot, err) in
            if err != nil {
                print("There was an error, \(err.debugDescription)")
            } else {
                for document in snapshot!.documents {
                    //put the details for each lesson into a lesson object
                    let userDocData = document.data()
                    //some of the data has to be split into dictionaries because in the database they're mapped and so can't be accessed otherwise
                    let times = userDocData["time"] as? [String: String]
                    let locations = userDocData["location"] as? [String: String]
                    let people = userDocData["people"] as? [String: String]
                    let newLesson = lesson(duration: times!["duration"]!, startTime: times!["start"]!, endTime: times!["end"]!, date: userDocData["date"] as! String,startLocation: locations!["start"]!, endLocation: locations!["end"]!, instructorId: people!["instructorID"]!, studentId: people!["studentID"]!, status: userDocData["status"] as! String, notes: userDocData["notes"] as! String, lessonId: document.documentID)
                    //store this object in the lesson array
                    self.lessonArray.append(newLesson)
                }
                print(self.lessonArray)
                self.lessonArray = self.sortLessons(array: self.lessonArray)
                print(self.lessonArray)
                self.timeTableView.reloadData()
            }
        }
    }
    

    // MARK: - Navigation
    
    //If a lesson in the table has been tapped on, it should take the user to a detail view
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selectedLesson = indexPath.row
        performSegue(withIdentifier: "TimetableToLessonDetail", sender: nil)
    }
    
    //Get the lesson data ready to send with the segue so the details can be filled in on the detail view
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let detailViewController = segue.destination as? InstructorLessonDetailViewController {
            detailViewController.date = viewingDateString
            detailViewController.time = " \(lessonArray[selectedLesson].startTime) - \(lessonArray[selectedLesson].endTime)"
            detailViewController.studentId = lessonArray[selectedLesson].studentId
            detailViewController.pickup = lessonArray[selectedLesson].startLocation
            detailViewController.dropoff = lessonArray[selectedLesson].endLocation
            detailViewController.notes = lessonArray[selectedLesson].notes
            detailViewController.status = lessonArray[selectedLesson].status
            detailViewController.lessonId = lessonArray[selectedLesson].lessonId
        }
    }

}
