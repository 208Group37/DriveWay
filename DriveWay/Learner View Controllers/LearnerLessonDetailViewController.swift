//
//  LearnerLessonDetailViewController.swift
//  DriveWay
//
//  Created by Jake Darby on 02/05/2021.
//

import UIKit

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
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        nameLabel.text = "Hi, \(studentName)"
        dateLabel.text = date
        timeLabel.text = time
        instructorLabel.text = "Instructor: \(instructorName)"
        statusLabel.text = "Status: \(status)"
        notesTextView.text = notes
        notesTextView.isEditable = false
        changeView(view: dateTimeBackgroundView, button: cancelButton, status: status)
        Utilities.styleButtonNeutral(cancelButton)
        cancelButton.layer.borderWidth = 1
    }
    
    func changeView(view: UIView, button: UIButton, status: String) {
        switch status {
        case "Accepted":
            view.backgroundColor = UIColor.driveWayGreen
        case "Pending":
            view.backgroundColor = UIColor.driveWayYellow
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
