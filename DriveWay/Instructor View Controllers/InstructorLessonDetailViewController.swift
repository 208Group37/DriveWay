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
        
        statusLabel.text = "Status: \(status)"
        notesTextView.text = notes
        notesTextView.isEditable = false
        
        //This bit is to get the placename of the pickup location from the coordinates
        //Convert the coordinates into a Location object
        let firstLocation = CLLocation(latitude: pickup.latitude, longitude: pickup.longitude)
        var pickupName = ""
        //Reverse Geocode to get the place name
        CLGeocoder().reverseGeocodeLocation(firstLocation, completionHandler: { (placemarks, error) in
            if error != nil {
                print(error!)
            } else {
                //Adding different bits of the placename into the string
                if let placemark = placemarks?[0] {
                    if placemark.subThoroughfare != nil {
                        pickupName += placemark.subThoroughfare! + " "
                    }
                    if placemark.thoroughfare != nil {
                        pickupName += placemark.thoroughfare!
                        pickupName += ", " + placemark.locality!
                    }
                    //display the placename
                    self.pickupLabel.text = "Pickup: " + pickupName
                }
            }
        }
        )
        //This bit is to get the placename of the pickup location from the coordinates
        //Convert the coordinates into a Location object
        let secondLocation = CLLocation(latitude: pickup.latitude, longitude: pickup.longitude)
        var dropoffName = ""
        //Reverse Geocode to get the place name
        CLGeocoder().reverseGeocodeLocation(secondLocation, completionHandler: { (placemarks, error) in
            if error != nil {
                print(error!)
            } else {
                //Adding different bits of the placename into the string
                if let placemark = placemarks?[0] {
                    if placemark.subThoroughfare != nil {
                        dropoffName += placemark.subThoroughfare! + " "
                    }
                    if placemark.thoroughfare != nil {
                        dropoffName += placemark.thoroughfare!
                        dropoffName += ", " + placemark.locality!
                    }
                    //display the placename
                    self.dropoffLabel.text = "Dropoff: \(dropoffName)"
                }
            }
        }
        )
        //call the function to change the colour of the box and the cancel button depending on the status of the lesson
        changeView(view: dateTimeBackgroundView, button: cancelButton, status: status)
        //style the cancel button
        Utilities.styleButtonNeutral(cancelButton)
        cancelButton.layer.borderWidth = 1
    }
    
    //This function changes the box at the top of the screen and the cancel button inside it depending on the status of the lesson
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
