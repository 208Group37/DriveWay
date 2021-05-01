//
//  LearnerHasInstructorViewController.swift
//  DriveWay
//
//  Created by Morgan Eckersley on 29/04/2021.
//

import UIKit
import FirebaseFirestore
import FirebaseAuth
import CoreLocation

class LearnerHasCarInstructorViewController: UIViewController {

    // MARK: - Outlets and Variables
    @IBOutlet weak var instructorsNameLabel: UILabel!
    @IBOutlet weak var ageGenderLabel: UILabel!
    @IBOutlet weak var reviewAvgLabel: UILabel!
    @IBOutlet weak var carMakeModelLabel: UILabel!
    @IBOutlet weak var fuelTypeTransmissionLabel: UILabel!
    @IBOutlet weak var postcodeLabel: UILabel!
    
    @IBOutlet weak var carImageView: UIImageView!
    
    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var crashCourseLabel: UILabel!
    @IBOutlet weak var distanceLabel: UILabel!
    @IBOutlet weak var lessonCountLabel: UILabel!
    
    @IBOutlet weak var mondayTimesLabel: UILabel!
    @IBOutlet weak var tuesdayTimesLabel: UILabel!
    @IBOutlet weak var wednesdayTimesLabel: UILabel!
    @IBOutlet weak var thursdayTimesLabel: UILabel!
    @IBOutlet weak var fridayTimesLabel: UILabel!
    @IBOutlet weak var saturdayTimesLabel: UILabel!
    @IBOutlet weak var sundayTimesLabel: UILabel!
    
    @IBOutlet weak var aboutMeTextView: UITextView!
    
    @IBOutlet weak var reviewerNameLabel: UILabel!
    @IBOutlet weak var reviewStarRatingLabel: UILabel!
    @IBOutlet weak var reviewBodyTextView: UITextView!
    
    @IBOutlet weak var requestLessonButton: UIButton!
    @IBOutlet weak var leaveInstructorButton: UIButton!
    
    let userAccInfo = Auth.auth().currentUser
    
    // MARK: - UI Setup
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        setUpObjects()
    }
    
    func setUpObjects() {
        getInstructorInformation()
        Utilities.styleTextViewNonInteractive(aboutMeTextView)
        Utilities.styleTextViewNonInteractive(reviewBodyTextView)
        Utilities.styleButtonGreen(requestLessonButton)
        Utilities.styleButtonRed(leaveInstructorButton)
    }
    
    // MARK: - Data Retrieval
    func getInstructorInformation() {
        print("Getting insructor info car")
        let database = Firestore.firestore()
        var collectionReference = database.collection("Students")
        var query = collectionReference.whereField("userID", isEqualTo: userAccInfo!.uid)
        
        query.getDocuments { (snapshot, err) in
            if err != nil {
                print(err.debugDescription)
            } else {
                for document in snapshot!.documents {
                    let userDocData = document.data()
                    // Getting the users address from the database
                    let privateInfo = userDocData["privateInfo"] as! [String : Any]
                    let addresses = privateInfo["addresses"] as! [String : Any]
                    let homeAddress = addresses["homeAddress"] as! [String : String]
                    
                    let userAddress = "\(homeAddress["line1"]!), \(homeAddress["line2"]!), \(homeAddress["city"]!)"
                    
                    // All the information stored in the document about the instructor
                    let instructorID = document.data()["instructorID"] as! String
                    
                    collectionReference = database.collection("Instructors")
                    query = collectionReference.whereField("userID", isEqualTo: instructorID)
                    
                    query.getDocuments { snapshot, err in
                        if err != nil {
                            print(err.debugDescription)
                        } else {
                            for document in snapshot!.documents {
                                let instructorDocData = document.data()
                                
                                // Getting the map of the instructors name and converting it to a dictionary
                                let names = instructorDocData["name"] as? [String : String]
                                // Concatonating the names
                                let fullName = names!["first"]! + " " + names!["last"]!
                                // Setting the name label to be the instructors name
                                self.instructorsNameLabel.text = fullName
                                
                                // Getting the map of the users public info and converting it to a dictionary
                                let publicInfo = instructorDocData["publicInfo"] as! [String : String]
                                // Getting birthdate
                                let birthday = publicInfo["birthDate"]!
                                // Calculate age
                                let age = Utilities.calculateAge(birthday: birthday)
                                
                                // Getting the gender of the instructor from the database
                                let gender = publicInfo["sex"]!
                                // Adding the age and the gender of the instructor to the correct label
                                self.ageGenderLabel.text = "\(age), \(gender)"
                                
                                // Getting the instructors postcode from the database
                                let privateInfo = instructorDocData["privateInfo"] as! [String : Any]
                                let addresses = privateInfo["addresses"] as! [String : Any]
                                let homeAddress = addresses["homeAddress"] as! [String : String]
                                let postcode = homeAddress["postcode"]!
                                // Setting the postcode label to the instructors postcode
                                self.postcodeLabel.text = postcode
                                
                                // Getting the info about the instructors car from the database
                                let carInfo = instructorDocData["car"] as? [String : String]
                                // getting the make and model of the car
                                let makeModelText = carInfo!["make"]! + " " + carInfo!["model"]!
                                // Setting the text to say the make and model
                                self.carMakeModelLabel.text = makeModelText
                                
                                // Getting the fuel typpe and transmission type from the database and making it a string
                                let fuelTypeTransmissionText = carInfo!["fuelType"]! + ", " + carInfo!["transmission"]!
                                // Setting the text label
                                self.fuelTypeTransmissionLabel.text = fuelTypeTransmissionText
                                
                                // Getting lessing info from the database
                                let lessonInfo = instructorDocData["lesson"] as? [String : Any]
                                // Getting the price of one instructors lesson
                                let price = lessonInfo!["price"]! as! String
                                // Setting the label
                                self.priceLabel.text = price
                                
                                // Getting the instructors crash course value
                                let crashCourseBool = lessonInfo!["crashCourses"] as! Bool
                                // Changing true or false to yes or no
                                if crashCourseBool {
                                    // Presenting the label
                                    self.crashCourseLabel.text = "Yes"
                                } else {
                                    // Presenting the label
                                    self.crashCourseLabel.text = "No"
                                }
                                
                                let instructorAddress = "\(homeAddress["line1"]!), \(homeAddress["line2"]!), \(homeAddress["city"]!)"
                                
                                let geocoder1 = CLGeocoder()
                                let geocoder2 = CLGeocoder()
                                
                                var userLocation = CLLocation()
                                var instructorLocation = CLLocation()
                                
                                geocoder1.geocodeAddressString(userAddress) { placemark, err in
                                    if err != nil {
                                        print("There was an error, \(err.debugDescription)")
                                    } else {
                                        for place in placemark! {
                                            userLocation = place.location!
                                            geocoder2.geocodeAddressString(instructorAddress) { placemark, err in
                                                if err != nil {
                                                    print("There was an error, \(err.debugDescription)")
                                                } else {
                                                    for place in placemark! {
                                                        instructorLocation = place.location!
                                                        print(instructorLocation)
                                                        let CLdistance = userLocation.distance(from: instructorLocation)
                                                        
                                                        
                                                        let distance = Float(CLdistance/1600).rounded(.up)
                                                        
                                                        self.distanceLabel.text =  String(Int(distance)) + " Miles"
                                                    }
                                                }
                                            }
                                        }
                                    }
                                }
                                self.lessonCountLabel.text = "0"
                                
                                let availability = instructorDocData["availability"] as! [String : [String]]
                                for day in availability {
                                    var labelText = String()
                                    if day.value.count != 0 {
                                        for i in day.value {
                                            labelText = labelText + i
                                        }
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
                                
                                let instructorAboutMeText = instructorDocData["aboutMe"] as! String
                                self.aboutMeTextView.text = instructorAboutMeText
                            }
                        }
                    }
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
