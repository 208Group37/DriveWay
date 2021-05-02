//
//  LearnerProfileViewController.swift
//  DriveWay
//
//  Created by Morgan Eckersley on 28/04/2021.
//

import UIKit
import FirebaseFirestore
import FirebaseAuth

class LearnerProfileViewController: UIViewController {
    
    // MARK: - Outlets and Variables
    
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var ageLabel: UILabel!
    @IBOutlet weak var vehicleTypeLabel: UILabel!
    @IBOutlet weak var postcodeLabel: UILabel!
    @IBOutlet weak var numberOfLessonsLabel: UILabel!
    
    // Availability Label Outlets
    @IBOutlet weak var mondayTimesLabel: UILabel!
    @IBOutlet weak var tuesdayTimesLabel: UILabel!
    @IBOutlet weak var wednesdayTimesLabel: UILabel!
    @IBOutlet weak var thursdayTimesLabel: UILabel!
    @IBOutlet weak var fridayTimesLabel: UILabel!
    @IBOutlet weak var saturdayTimesLabel: UILabel!
    @IBOutlet weak var sundayTimesLabel: UILabel!
    
    @IBOutlet weak var aboutMeTextView: UITextView!
    
    let userAccInfo = Auth.auth().currentUser

    // MARK: UI Setup
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        setUpObjects()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        self.navigationController?.navigationItem.hidesBackButton = true
        getUserInformation()
    }
    
    func setUpObjects() {
        Utilities.styleTextViewNonInteractive(aboutMeTextView)
    }
    
    // MARK: - Data Retrieval
    func getUserInformation() {
        let database = Firestore.firestore()
        let collectionReference = database.collection("Students")
        let query = collectionReference.whereField("userID", isEqualTo: userAccInfo!.uid)
        
        query.getDocuments { (snapshot, err) in
            if err != nil {
                print(err.debugDescription)
            } else {
                for document in snapshot!.documents {
                    // All the information stored in the document about the user
                    let userDocData = document.data()
                    
                    // Getting the map of the users name and converting it to a dictionary
                    let names = userDocData["name"] as? [String : String]
                    // Concatonating the names
                    let fullName = names!["first"]! + " " + names!["last"]!
                    // Setting the name label to be the users name
                    self.nameLabel.text = fullName
                    
                    // Getting the map of the users public info and converting it to a dictionary
                    let publicInfo = userDocData["publicInfo"] as! [String : String]
                    // Getting birthdate
                    let birthday = publicInfo["birthDate"]!
                    // Calculate age
                    let age = Utilities.calculateAge(birthday: birthday)
                    // Displaying age
                    self.ageLabel.text = "\(age) Years Old"
                    
                    // Getting the vehicle type from the database
                    let vehicleType = userDocData["vehicle"] as? String
                    // Setting the vehicle type label to the correct type
                    self.vehicleTypeLabel.text = vehicleType?.capitalized
                    
                    // Getting the users postcode from the database
                    let privateInfo = userDocData["privateInfo"] as! [String : Any]
                    let addresses = privateInfo["addresses"] as! [String : Any]
                    let homeAddress = addresses["homeAddress"] as! [String : String]
                    let postcode = homeAddress["postcode"]!
                    
                    // Setting the postcode label to the users postcode
                    self.postcodeLabel.text = postcode
                    
                    // Getting the users current lesson count
                    let lessonCount = userDocData["lessonCount"] as? String
                    
                    // Setting the label to the count value
                    self.numberOfLessonsLabel.text = lessonCount ?? "0"
                    
                    // Getting the users availabilty from the database
                    let availability = userDocData["availability"] as! [String : [String]]
                    for day in availability {
                        var labelText = String()
                        if day.value[0] != "" {
                            labelText = labelText + "Morning, "
                        }
                        if day.value[1] != "" {
                            labelText = labelText + "Afternoon, "
                        }
                        if day.value[2] != "" {
                            labelText = labelText + "Evening"
                        }
                        switch day.key {
                        case "monday":
                            self.mondayTimesLabel.text = labelText
                        case "tuesday":
                            self.tuesdayTimesLabel.text = labelText
                        case "wednesday":
                            self.wednesdayTimesLabel.text = labelText
                        case "thursday":
                            self.thursdayTimesLabel.text = labelText
                        case "friday":
                            self.fridayTimesLabel.text = labelText
                        case "saturday":
                            self.saturdayTimesLabel.text = labelText
                        case "sunday":
                            self.sundayTimesLabel.text = labelText
                        default:
                            print("Doesnt work")
                        }
                    }
                    // Getting the about me text entered by the user
                    let aboutMeText = userDocData["aboutMe"] as! String
                    // Setting the about me text field to contain the users entry
                    self.aboutMeTextView.text = aboutMeText
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
