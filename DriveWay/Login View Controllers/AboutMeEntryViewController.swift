//
//  AboutMeEntryViewController.swift
//  DriveWay
//
//  Created by Morgan Eckersley on 01/04/2021.
//

import UIKit

class AboutMeEntryViewController: UIViewController {

    
    // MARK: - Variables
    // Variables passed from last segue
    var carOrMotorcycle = String()
    var address = [String]()
    var availabilityChoices = [[Bool]]()
    
    @IBOutlet weak var aboutMeTextView: UITextView!
    @IBOutlet weak var confirmationButton: UIButton!
    @IBOutlet weak var finishButton: UIButton!
    
    // MARK: - UI Setup
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        setUpObjects()
    }
    
    func setUpObjects() {
        Utilities.styleTextView(aboutMeTextView)
        Utilities.styleButtonGreen(finishButton)
    }
    
    // Function that removes the keyboard when the user taps outside of it
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
    }
    
    // MARK: - Button Functions
    @IBAction func confirmationButtonPressed(_ sender: Any) {
        Utilities.toggleButton(confirmationButton)
    }
    
    @IBAction func finishButtonPressed(_ sender: Any) {
        // Adds information to the database
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
