//
//  LearnerLessonDetailViewController.swift
//  DriveWay
//
//  Created by Jake Darby on 02/05/2021.
//

import UIKit
import FirebaseFirestore
import FirebaseAuth

class LearnerLessonDetailViewController: UIViewController {
    
    // MARK: - Variable declaration
    var date: String = ""
    var time: String = ""
    var studentName: String = ""
    var instructorName: String = ""
    var pickup: String = ""
    var dropoff: String = ""
    var notes: String = ""
    var status: String = ""
    var documentID = ""
    
    // MARK: - Outlets
    @IBOutlet weak var dateTimeBackgroundView: UIView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var instructorLabel: UILabel!
    @IBOutlet weak var statusLabel: UILabel!
    @IBOutlet weak var pickupLabel: UILabel!
    @IBOutlet weak var dropoffLabel: UILabel!
    @IBOutlet weak var notesTextView: UITextView!
    @IBOutlet weak var cancelButton: UIButton!
    
    // MARK: - Button actions
    @IBAction func cancelButton(_ sender: Any) {
        let database = Firestore.firestore()
        database.collection("Lessons").document(documentID).delete() { err in
            if let err = err {
                print("Error removing document: \(err)")
                let failure = UIAlertController(title: "Cancellation failed", message: "Try again", preferredStyle: .alert)
                failure.addAction(UIAlertAction(title: "Okay", style: .default, handler: nil))
                self.present(failure, animated: true, completion: nil)
            } else {
                print("Document successfully removed!")
                let success = UIAlertController(title: "Cancelled successfully", message: "Your lesson has been cancelled", preferredStyle: .alert)
                success.addAction(UIAlertAction(title: "Okay", style: .default, handler: nil))
                self.present(success, animated: true, completion: nil)
            }
        }
    }
    
    // MARK: - Built-in Functions
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        nameLabel.text = "Hi, \(studentName)"
        dateLabel.text = date
        timeLabel.text = time
        instructorLabel.text = "Instructor: \(instructorName)"
        statusLabel.text = "Status: \(status)"
        pickupLabel.text = "Pick-up: \(pickup)"
        dropoffLabel.text = "Drop-off: \(dropoff)"
        notesTextView.text = notes
        notesTextView.isEditable = false
        changeView(view: dateTimeBackgroundView, button: cancelButton, status: status)
        Utilities.styleButtonNeutral(cancelButton)
        cancelButton.layer.borderWidth = 1
    }
    
    
    // MARK: - Custom functions
    // A function that changes the look of the screen depending on the status of the lesson
    func changeView(view: UIView, button: UIButton, status: String) {
        switch status {
        case "Accepted":
            view.backgroundColor = UIColor.driveWayGreen
            notesTextView.textColor = UIColor.darkGray
            notesTextView.text = "You've not had this lesson yet, so there are no notes."
            notesTextView.font = UIFont.italicSystemFont(ofSize: 14)
        case "Pending":
            view.backgroundColor = UIColor.driveWayYellow
            notesTextView.textColor = UIColor.darkGray
            notesTextView.text = "You've not had this lesson yet, so there are no notes."
            notesTextView.font = UIFont.italicSystemFont(ofSize: 14)
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
