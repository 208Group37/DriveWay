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
    
    
    @IBOutlet weak var nameLabel: UITextField!
    @IBOutlet weak var ageGenderLabel: UILabel!
    @IBOutlet weak var avgStarLabel: UILabel!
    @IBOutlet weak var CarMakeModelLabel: UILabel!
    @IBOutlet weak var fuelAndTransmissionLabel: UILabel!
    @IBOutlet weak var registrationLabel: UILabel!
    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var lessonLengthLabel: UILabel!
    @IBOutlet weak var crashCourseLabel: UILabel!
    @IBOutlet weak var distanceLabel: UILabel!
    @IBOutlet weak var lessonCountLabel: UILabel!
    @IBOutlet weak var mondayTimesLabel: UILabel!
    @IBOutlet weak var tuesdayTimesLabel: UILabel!
    @IBOutlet weak var wednesdayTimesLAbel: UILabel!
    @IBOutlet weak var thursdayTimesLabel: UILabel!
    @IBOutlet weak var fridayTimesLabel: UILabel!
    @IBOutlet weak var saturdayTimesLabel: UILabel!
    @IBOutlet weak var sundayTimesLabel: UILabel!
    @IBOutlet weak var aboutMeBox: UITextField!
    
    
    let userInfo = Auth.auth().currentUser
    var userDocInfo = [QueryDocumentSnapshot]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        documentRetrieve()
        
        

        // Do any additional setup after loading the view.
    }
    
    func convertArrayToString(array : [String]) -> String {
        var outputString = ""
        for item in array {
            outputString = outputString + ", " + item
        }
        return outputString
    }
    
    func documentRetrieve() {
        let database = Firestore.firestore()
        let collectionReference = database.collection("Instructors")
        let query = collectionReference.whereField("userID", isEqualTo: userInfo!.uid)
        
        query.getDocuments { (snapshot, err) in
            if err != nil {
                print("There was an error, \(err.debugDescription)")
            } else {
                for document in snapshot!.documents {
                    let userDocData = document.data()
                    
                    let names = userDocData["name"] as? [String: String]
                    let fullname = names!["first"]! + " " + names!["last"]!
                    self.nameLabel.text = fullname
                    
                    let carInfo = userDocData["car"] as? [String: String]
                    self.CarMakeModelLabel.text = carInfo!["make"]! + " " + carInfo!["model"]!
                    self.fuelAndTransmissionLabel.text = carInfo!["fuelType"]! + ", " + carInfo!["transmission"]!
                    self.registrationLabel.text = carInfo!["numberPlate"]
                    
                    let lessonInfo = userDocData["lesson"] as? [String: Any]
                    self.priceLabel.text = lessonInfo!["price"] as? String
                    var crashCourseString: String
                    if lessonInfo!["crashCourses"] as! Bool == true {
                        crashCourseString = "Yes"
                    } else {
                        crashCourseString = "No"
                    }
                    self.crashCourseLabel.text = crashCourseString
                    
                    let times = userDocData["availability"] as? [String : Array<String>]
                    self.mondayTimesLabel.text = self.convertArrayToString(array: times!["monday"] ?? [])
                    self.tuesdayTimesLabel.text = self.convertArrayToString(array: times!["tuesday"] ?? [])
                    self.wednesdayTimesLAbel.text = self.convertArrayToString(array: times!["wednesday"] ?? [])
                    self.thursdayTimesLabel.text = self.convertArrayToString(array: times!["thursday"] ?? [])
                    self.fridayTimesLabel.text = self.convertArrayToString(array: times!["friday"] ?? [])
                    self.saturdayTimesLabel.text = self.convertArrayToString(array: times!["saturday"] ?? [])
                    self.sundayTimesLabel.text = self.convertArrayToString(array: times!["sunday"] ?? [])
                    
                    
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
