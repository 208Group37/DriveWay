//
//  LearnerAboutMeEntryViewController.swift
//  DriveWay
//
//  Created by Morgan Eckersley on 01/04/2021.
//

import UIKit
import FirebaseFirestore
import FirebaseAuth

class LearnerAboutMeEntryViewController: UIViewController {

    
    // MARK: - Variables
    // Variables passed from last segue
    var carOrMotorcycle = String()
    var address = [String]()
    var availabilityChoices = [[String]]()
    
    @IBOutlet weak var aboutMeTextView: UITextView!
    @IBOutlet weak var confirmationButton: UIButton!
    @IBOutlet weak var errorLabel: UILabel!
    @IBOutlet weak var finishButton: UIButton!
    
    // MARK: - UI Setup
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        setUpObjects()
    }
    
    // Styling the objects on the view
    func setUpObjects() {
        Utilities.styleTextView(aboutMeTextView)
        Utilities.styleButtonGreen(finishButton)
    }
    
    // Function that removes the keyboard when the user taps outside of it
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
    }
    
    // MARK: - Button Functions
    // Toggling the confirmation button
    @IBAction func confirmationButtonPressed(_ sender: Any) {
        Utilities.toggleButton(confirmationButton)
    }
    
    // When the finish button is pressed
    @IBAction func finishButtonPressed(_ sender: Any) {
        
        // Validate fields
        let isThereAnError = validateFields()
        
        // If there is an error
        if isThereAnError == true {
            Utilities.showError("Please check the box", errorLabel: errorLabel)
        } else {
            
            // Create a variable for the data to be added to the database
            let dataToAdd: [String : Any] = [
                "vehicle" : carOrMotorcycle,
                "lessonCount" : 0,
                "hasInstructor" : false,
                "instructorID" : "",
                "privateInfo" : [
                    "addresses" : [
                        "homeAddress" : [
                            "line1" : address[0],
                            "line2" : address[1],
                            "city" : address[2],
                            "postcode" : address[3]
                        ]
                    ]
                ],
                "aboutMe" : aboutMeTextView.text!,
                "availability" : [
                    "monday" : [availabilityChoices[0][0], availabilityChoices[0][1], availabilityChoices[0][2]],
                    "tuesday" : [availabilityChoices[1][0], availabilityChoices[1][1], availabilityChoices[1][2]],
                    "wednesday" : [availabilityChoices[2][0], availabilityChoices[2][1], availabilityChoices[2][2]],
                    "thursday" : [availabilityChoices[3][0], availabilityChoices[3][1], availabilityChoices[3][2]],
                    "friday" : [availabilityChoices[4][0], availabilityChoices[4][1], availabilityChoices[4][2]],
                    "saturday" : [availabilityChoices[5][0], availabilityChoices[5][1], availabilityChoices[5][2]],
                    "sunday" : [availabilityChoices[6][0], availabilityChoices[6][1], availabilityChoices[6][2]]
                ]
            ]
            
            // Adding the data to the database
            let user = Auth.auth().currentUser!
            
            Utilities.addDataToUserDocument(user, collection: "Students", dataToAdd: dataToAdd)
            
            performSegue(withIdentifier: "toLearnerHomeScreen", sender: nil)
        }
    }
    
    // MARK: - Validation
    func validateFields() -> Bool {
        // If the confirmation button has not been pressed
        if confirmationButton.isSelected == false {
            // Then there is an error
            return true
        }
        // Otherwise no error
        return false
    }
}
