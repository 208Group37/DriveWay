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
    var date: String = ""
    var time: String = ""
    var studentName: String = ""
    var pickup = GeoPoint(latitude: 0.0, longitude: 0.0)
    var dropoff = GeoPoint(latitude: 0.0, longitude: 0.0)
    var notes: String = ""
    var status: String = ""
    
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
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        dateLabel.text = date
        timeLabel.text = time
        studentLabel.text = "Student: \(studentName)"
        statusLabel.text = "Status: \(status)"
        notesTextView.text = notes
        notesTextView.isEditable = false
        let firstLocation = CLLocation(latitude: pickup.latitude, longitude: pickup.longitude)
        var pickupName = ""
        CLGeocoder().reverseGeocodeLocation(firstLocation, completionHandler: { (placemarks, error) in
            if error != nil {
                print(error!)
            } else {
                if let placemark = placemarks?[0] {
                    if placemark.subThoroughfare != nil {
                        pickupName += placemark.subThoroughfare! + " "
                    }
                    if placemark.thoroughfare != nil {
                        pickupName += placemark.thoroughfare!
                        pickupName += ", " + placemark.locality!
                    }
                    self.pickupLabel.text = "Pickup: " + pickupName
                }
            }
        }
        )
        let secondLocation = CLLocation(latitude: pickup.latitude, longitude: pickup.longitude)
        var dropoffName = ""
        CLGeocoder().reverseGeocodeLocation(secondLocation, completionHandler: { (placemarks, error) in
            if error != nil {
                print(error!)
            } else {
                if let placemark = placemarks?[0] {
                    if placemark.subThoroughfare != nil {
                        dropoffName += placemark.subThoroughfare! + " "
                    }
                    if placemark.thoroughfare != nil {
                        dropoffName += placemark.thoroughfare!
                        dropoffName += ", " + placemark.locality!
                    }
                    self.dropoffLabel.text = "Dropoff: \(dropoffName)"
                }
            }
        }
        )
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
