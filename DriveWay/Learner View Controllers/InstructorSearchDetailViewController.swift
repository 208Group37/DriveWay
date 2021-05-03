//
//  InstructorSearchDetailViewController.swift
//  DriveWay
//
//  Created by Morgan Eckersley on 02/05/2021.
//

import UIKit
import FirebaseFirestore
import CoreLocation
import FirebaseAuth

class InstructorSearchDetailViewController: UIViewController {

    // MARK: - Oultets and Variables
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
    
    @IBOutlet weak var requestEnrolmentButton: UIButton!
    
    // Getting the currently signed in user
    let userAccInfo = Auth.auth().currentUser
    // The instructor ID that was passed from the previous view via segue
    var instructorID = String()
    
    // MARK: - UI Setup
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        setUpObjects()
    }
    
    // Styling the view
    func setUpObjects() {
        getInstructorInformation()
        Utilities.styleTextViewNonInteractive(aboutMeTextView)
        Utilities.styleTextViewNonInteractive(reviewBodyTextView)
        Utilities.styleButtonGreen(requestEnrolmentButton)
    }
    
    // MARK: - Button Functions
    
    @IBAction func requestEnrolmentButtonPressed(_ sender: Any) {
        let database = Firestore.firestore()
        var collectionReference = database.collection("Students")
        var query = collectionReference.whereField("userID", isEqualTo: userAccInfo!.uid)
        
        var dataToAdd = ["hasInstructor" : true,
                                     "instructorID" : self.instructorID] as [String : Any]
                    
        Utilities.addDataToUserDocument(self.userAccInfo! , collection: "Students", dataToAdd: dataToAdd)
        
        collectionReference = database.collection("Instructors")
        query = collectionReference.whereField("userID", isEqualTo: self.instructorID)
        // Getting the documents that forfill the query
        query.getDocuments() { (snapshot, err) in
            // If there is an error
            if err != nil {
                // Print the error and a message
                print("There was an error obtaining the documentID: \(err!)")
            // Otherwise
            } else {
                // For every document in the snapshot
                for document in snapshot!.documents {
                    // get the instructor information
                    let instructorDocData = document.data()
                    // Get their list of students
                    var students = instructorDocData["students"] as! [String]
                    // adding the new student to the array
                    students.append(self.userAccInfo!.uid)
                    // adding the array back to the database
                    dataToAdd = ["students" : students]
                    let documentReference = collectionReference.document(document.documentID)
                    documentReference.setData(dataToAdd, merge: true)
                }
            }
        }
        
        
        
        // visual representation that the student has enrolled
        requestEnrolmentButton.isEnabled = false
        requestEnrolmentButton.backgroundColor = .lightGray
        
        // sending the user back to their profile
        performSegue(withIdentifier: "backToProfile", sender: nil)
        
        // creating and showing the alert that tells the user they have enrolled
        let alertController = UIAlertController(title: "Enrolled", message: "You have enrolled with this instructor", preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "Okay", style: .default))
        self.present(alertController, animated: true,completion: nil)
    }
    
    // MARK: - Data Retrieval
    func getInstructorInformation() {
        print("Getting insructor info car")
        // creating a database reference
        let database = Firestore.firestore()
        // creating a reference to the students collection
        var collectionReference = database.collection("Students")
        // creating a query that is looking for a document where the userID field is the same as the current user's uid
        var query = collectionReference.whereField("userID", isEqualTo: userAccInfo!.uid)
        
        // executing the query
        query.getDocuments { (snapshot, err) in
            // if error print it (for debugging)
            if err != nil {
                print(err.debugDescription)
            } else {
                // for every document in the snapshot
                for document in snapshot!.documents {
                    // get all the users data from the document
                    let userDocData = document.data()
                    // Getting the users address from the database
                    let privateInfo = userDocData["privateInfo"] as! [String : Any]
                    let addresses = privateInfo["addresses"] as! [String : Any]
                    let homeAddress = addresses["homeAddress"] as! [String : String]
                    
                    let userAddress = "\(homeAddress["line1"]!), \(homeAddress["line2"]!), \(homeAddress["city"]!)"
                    
                    // All the information stored in the document about the instructor
                    collectionReference = database.collection("Instructors")
                    query = collectionReference.whereField("userID", isEqualTo: self.instructorID)
                    // executing the next query
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
                                
                                // getting the instuctor ID as a string
                                let instructorAddress = "\(homeAddress["line1"]!), \(homeAddress["line2"]!), \(homeAddress["city"]!)"
                                
                                // geocoders used to get the coordinates from the address
                                let geocoder1 = CLGeocoder()
                                let geocoder2 = CLGeocoder()
                                
                                // the two locations as cl location objects
                                var userLocation = CLLocation()
                                var instructorLocation = CLLocation()
                                
                                // this is a method that gets the coordinates of a place based on the street number and location
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
                                                        // get the distance in meters
                                                        let CLdistance = userLocation.distance(from: instructorLocation)
                                                        
                                                        // convert to miles and round up
                                                        let distance = Float(CLdistance/1600).rounded(.up)
                                                        
                                                        // setting the label
                                                        self.distanceLabel.text =  String(Int(distance)) + " Miles"
                                                    }
                                                }
                                            }
                                        }
                                    }
                                }
                                // setting the lesson count to zero
                                self.lessonCountLabel.text = "0"
                                
                                // setting the availability labels
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
                                
                                // getting and setting the about me text field
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
