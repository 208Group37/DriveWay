//
//  LearnerHasInstructorViewController.swift
//  DriveWay
//
//  Created by Morgan Eckersley on 29/04/2021.
//

import UIKit
import FirebaseFirestore
import FirebaseAuth

class LearnerHasInstructorViewController: UIViewController {

    // MARK: - Outlets
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
        let database = Firestore.firestore()
        var collectionReference = database.collection("Students")
        var query = collectionReference.whereField("userID", isEqualTo: userAccInfo!.uid)
        
        query.getDocuments { (snapshot, err) in
            if err != nil {
                print(err.debugDescription)
            } else {
                for document in snapshot!.documents {
                    // All the information stored in the document about the user
                    let instructorID = document.data()["instructorID"] as! String
                    
                    collectionReference = database.collection("Instructors")
                    query = collectionReference.whereField("userID", isEqualTo: instructorID)
                    
                    query.getDocuments { snapshot, err in
                        if err != nil {
                            print(err.debugDescription)
                        } else {
                            for document in snapshot!.documents {
                                let instructorDocData = document.data()
                                
                                // Getting the map of the users name and converting it to a dictionary
                                let names = instructorDocData["name"] as? [String : String]
                                // Concatonating the names
                                let fullName = names!["first"]! + " " + names!["last"]!
                                // Setting the name label to be the users name
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
