//
//  InstructorSearchDetailViewController.swift
//  DriveWay
//
//  Created by Morgan Eckersley on 02/05/2021.
//

import UIKit

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
    
    var instructorID = String()
    
    // MARK: - UI Setup
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        print(instructorID)
        setUpObjects()
    }
    
    func setUpObjects() {
        Utilities.styleTextViewNonInteractive(aboutMeTextView)
        Utilities.styleTextViewNonInteractive(reviewBodyTextView)
        Utilities.styleButtonGreen(requestEnrolmentButton)
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
