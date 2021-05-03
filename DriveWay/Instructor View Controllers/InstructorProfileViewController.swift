//
//  InstructorProfileViewController.swift
//  DriveWay
//
//  Created by Christian Carroll on 28/04/2021.
//

import UIKit
import FirebaseFirestore
import FirebaseAuth

class InstructorProfileViewController: UIViewController {
    
    // MARK: - Creating Outlets
    //Connecting all the outlets
    @IBOutlet weak var nameLabel: UITextField!
    @IBOutlet weak var ageGenderLabel: UILabel!
    @IBOutlet weak var avgStarLabel: UILabel!
    @IBOutlet weak var CarMakeModelLabel: UILabel!
    @IBOutlet weak var fuelAndTransmissionLabel: UILabel!
    @IBOutlet weak var registrationLabel: UILabel!
    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var crashCourseLabel: UILabel!
    @IBOutlet weak var lessonCountLabel: UILabel!
    @IBOutlet weak var mondayTimesLabel: UILabel!
    @IBOutlet weak var tuesdayTimesLabel: UILabel!
    @IBOutlet weak var wednesdayTimesLAbel: UILabel!
    @IBOutlet weak var thursdayTimesLabel: UILabel!
    @IBOutlet weak var fridayTimesLabel: UILabel!
    @IBOutlet weak var saturdayTimesLabel: UILabel!
    @IBOutlet weak var sundayTimesLabel: UILabel!
    @IBOutlet weak var aboutMeBox: UITextView!
    
    
    //get the info of the user, such as their userid which is useful for getting their data from the database
    let userInfo = Auth.auth().currentUser
    //var userDocInfo = [QueryDocumentSnapshot]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        Utilities.styleTextViewNonInteractive(aboutMeBox)
        getAndFillInfo()
        // Do any additional setup after loading the view.
    }
    
    func convertArrayToString(array : [String]) -> String {
        var outputString = ""
        for item in array {
            outputString = outputString + " " + item
        }
        return outputString
    }
    
    // MARK: - Get info and display
    //This function queries the database for the data about the user for putting into their profile, then puts the information into all of the labels on the profile
    func getAndFillInfo() {
        //set up the query
        let database = Firestore.firestore()
        let collectionReference = database.collection("Instructors")
        //just looking for the data associated with the user
        let query = collectionReference.whereField("userID", isEqualTo: userInfo!.uid)
        
        //use the query to get the data
        query.getDocuments { (snapshot, err) in
            if err != nil {
                print("There was an error, \(err.debugDescription)")
            } else {
                for document in snapshot!.documents {
                    //save the data
                    let userDocData = document.data()
                    //get the name information and display it
                    let names = userDocData["name"] as? [String: String]
                    let fullname = names!["first"]! + " " + names!["last"]!
                    self.nameLabel.text = fullname
                    
                    let publicInfo = userDocData["publicInfo"] as! [String : String]
                    // Getting birthdate
                    let birthday = publicInfo["birthDate"]!
                    // Calculate age
                    let age = Utilities.calculateAge(birthday: birthday)
                    self.ageGenderLabel.text = String(age) + ", " + publicInfo["sex"]!
                    //get the car information and display it
                    let carInfo = userDocData["car"] as? [String: String]
                    self.CarMakeModelLabel.text = carInfo!["make"]! + " " + carInfo!["model"]!
                    self.fuelAndTransmissionLabel.text = carInfo!["fuelType"]! + ", " + carInfo!["transmission"]!
                    self.registrationLabel.text = carInfo!["numberPlate"]
                    //get the information about their lessons and display it
                    let lessonInfo = userDocData["lesson"] as? [String: Any]
                    self.priceLabel.text = "£" + ((lessonInfo!["price"] as? String)!) + "/hr"
                    var crashCourseString: String
                    if lessonInfo!["crashCourses"] as! Bool == true {
                        crashCourseString = "Yes"
                    } else {
                        crashCourseString = "No"
                    }
                    self.crashCourseLabel.text = crashCourseString
                    //get informatyion about their availability and display it
                    let times = userDocData["availability"] as? [String : Array<String>]
                    self.mondayTimesLabel.text = self.convertArrayToString(array: times!["monday"] ?? [])
                    self.tuesdayTimesLabel.text = self.convertArrayToString(array: times!["tuesday"] ?? [])
                    self.wednesdayTimesLAbel.text = self.convertArrayToString(array: times!["wednesday"] ?? [])
                    self.thursdayTimesLabel.text = self.convertArrayToString(array: times!["thursday"] ?? [])
                    self.fridayTimesLabel.text = self.convertArrayToString(array: times!["friday"] ?? [])
                    self.saturdayTimesLabel.text = self.convertArrayToString(array: times!["saturday"] ?? [])
                    self.sundayTimesLabel.text = self.convertArrayToString(array: times!["sunday"] ?? [])
                    self.aboutMeBox.text = userDocData["aboutMe"] as! String
                    
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
