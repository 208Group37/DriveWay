//
//  InstructorLessonDetailViewController.swift
//  DriveWay
//
//  Created by Christian Carroll on 02/05/2021.
//

import UIKit
import CoreLocation
import FirebaseFirestore
import FirebaseAuth

class InstructorLessonDetailViewController: UIViewController {

    // MARK: - Variable declaration
    //These will be filled in by the information sent with the segue
    var date: String = ""
    var time: String = ""
    var studentId: String = ""
    var pickup: String = ""
    var dropoff: String = ""
    var notes: String = ""
    var status: String = ""
    var lessonId: String = ""
    
    // MARK: - Outlets
    @IBOutlet weak var dateTimeBackgroundView: UIView!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var studentLabel: UILabel!
    @IBOutlet weak var statusLabel: UILabel!
    @IBOutlet weak var pickupLabel: UILabel!
    @IBOutlet weak var dropoffLabel: UILabel!
    @IBOutlet weak var notesTextView: UITextView!
    @IBOutlet weak var cancelButton: UIButton!
    @IBOutlet weak var acceptButton: UIButton!
    @IBOutlet weak var denyButton: UIButton!
    
    // MARK: - Button Actions
    //This allows the accept button to update the status of the lesson. It hides the buttons and then updates the database
    @IBAction func acceptButtonAction(_ sender: Any) {
        acceptButton.isHidden = true
        denyButton.isHidden = true
        let database = Firestore.firestore()
        //Getting the lesson document with the document ID (lesson id) then setting the data to be updated
        let collectionReference: Void = database.collection("Lessons").document(lessonId).setData(["status": "Accepted"], merge: true)
    }
    //This allows the deny button to update the status of the lesson. It hides the buttons and then updates the database
    @IBAction func denyButtonAction(_ sender: Any) {
        acceptButton.isHidden = true
        denyButton.isHidden = true
        let database = Firestore.firestore()
        //Getting the lesson document with the document ID (lesson id) then setting the data to be updated
        let collectionReference: Void = database.collection("Lessons").document(lessonId).setData(["status": "Cancelled"], merge: true)
    }
    //This allows the cancel button to cancel the lesson
    @IBAction func cancelButtonAction(_ sender: Any) {
        let database = Firestore.firestore()
        //Getting the lesson document with the document ID (lesson id) then setting the data to be updated
        let collectionReference: Void = database.collection("Lessons").document(lessonId).setData(["status": "Cancelled"], merge: true)
    }
    
    // MARK: - View did load
    override func viewDidLoad() {
        super.viewDidLoad()

        //putting the information into the labels to be displayed
        dateLabel.text = date
        timeLabel.text = time
        //This query is for getting the student's name
        let database = Firestore.firestore()
        let collectionReference = database.collection("Students")
        let query = collectionReference.whereField("userID", isEqualTo: self.studentId)
        
        query.getDocuments { (snapshot, err) in
            if err != nil {
                print("There was an error, \(err.debugDescription)")
            } else {
                for document in snapshot!.documents {
                    let nameData = document.data()["name"] as? [String: String]
                    let studentName = nameData!["first"]! + " " + nameData!["last"]!
                    //display the student's name
                    self.studentLabel.text = "Student: \(studentName)"
                }
            }
        }
        //putting the information into the labels to be displayed
        statusLabel.text = "Status: \(status)"
        notesTextView.text = notes
        notesTextView.isEditable = false
        pickupLabel.text = "Pickup: \(pickup)"
        dropoffLabel.text = "Dropoff: \(dropoff)"
        
        //call the function to change the colour of the box and the cancel button depending on the status of the lesson
        changeView(view: dateTimeBackgroundView, button: cancelButton, status: status)
        //style the cancel button
        Utilities.styleButtonNeutral(cancelButton)
        cancelButton.layer.borderWidth = 1
        //styling the accept/deny buttons if the lesson is pending, if not then hide them
        if status == "Pending" {
            Utilities.styleButtonGreen(acceptButton)
            Utilities.styleButtonRed(denyButton)
        } else {
            acceptButton.isHidden = true
            denyButton.isHidden = true
        }
    }
    
    // MARK: - Changing the view
    //This function changes the box at the top of the screen and the cancel button inside it depending on the status of the lesson
    func changeView(view: UIView, button: UIButton, status: String) {
        switch status {
        case "Accepted":
            view.backgroundColor = UIColor.driveWayGreen
        case "Pending":
            view.backgroundColor = UIColor.driveWayYellow
            button.isHidden = true
        case "Cancelled":
            view.backgroundColor = UIColor.driveWayRed
            button.isHidden = true
        case "Done":
            view.backgroundColor = UIColor.driveWayBlue
            button.isHidden = true
        default:
            view.backgroundColor = UIColor.white
        }
        view.layer.borderColor = UIColor.black.cgColor
        view.layer.borderWidth = 2
    }

}
