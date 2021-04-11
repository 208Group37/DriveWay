//
//  InstructorOrLearnerViewController.swift
//  DriveWay
//
//  Created by Morgan Eckersley on 28/03/2021.
//

import UIKit

class InstructorOrLearnerViewController: UIViewController {

    // MARK: - Outlets and Variables
    @IBOutlet weak var instructorButton: UIButton!
    @IBOutlet weak var learnerButton: UIButton!
    
    // Variable for the account type to pass to the next view
    var accountType = String()
    
    // MARK: - UISetup
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        setUpObjects()
    }
    
    // Function to stylize all objects in the view
    func setUpObjects() {
        Utilities.styleButtonNeutral(instructorButton)
        Utilities.styleButtonNeutral(learnerButton)
    }
    
    // MARK: - Navigation

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Getting the name of the segue
        let segueName = segue.identifier
        // As both segues have the same destination this need not be in an if statement
        let destination = segue.destination as! PersonalDataEntryViewController

        // If the segue is the instructors segue the account type is instructor
        if segueName == "toPersonalDataInstructor" {
            destination.accountType = "Instructors"
        }
        // If the segue is the learners segue the account type is learner
        if segueName == "toPersonalDataLearner" {
            destination.accountType = "Students"
        }
    }
}
