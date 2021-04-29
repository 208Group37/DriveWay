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
    @IBOutlet weak var priceLabel: UITextField!
    @IBOutlet weak var lessonLengthLabel: UILabel!
    @IBOutlet weak var crashCourseLabel: UILabel!
    @IBOutlet weak var distanceLabel: UILabel!
    @IBOutlet weak var lessonCountLabel: UILabel!
    
    
    let userInfo = Auth.auth().currentUser
    var userDocInfo = [QueryDocumentSnapshot]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        documentRetrieve()
        
        

        // Do any additional setup after loading the view.
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
