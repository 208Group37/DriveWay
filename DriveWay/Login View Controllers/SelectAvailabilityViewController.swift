//
//  SelectAvailabilityViewController.swift
//  DriveWay
//
//  Created by Morgan Eckersley on 30/03/2021.
//

import UIKit

class SelectAvailabilityViewController: UIViewController {
    
    // MARK: - Outlets
    @IBOutlet weak var mondayMorningButton: UIButton!
    @IBOutlet weak var mondayAfternoonButton: UIButton!
    @IBOutlet weak var mondayEveningButton: UIButton!
    @IBOutlet weak var tuesdayMorningButton: UIButton!
    @IBOutlet weak var tuesdayAfternoonButton: UIButton!
    @IBOutlet weak var tuesdayEveningButton: UIButton!
    @IBOutlet weak var wednesdayMorningButton: UIButton!
    @IBOutlet weak var wednesdayAfternoonButton: UIButton!
    @IBOutlet weak var wednesdayEveningButton: UIButton!
    @IBOutlet weak var thursdayMorningButton: UIButton!
    @IBOutlet weak var thursdayAfternoonButton: UIButton!
    @IBOutlet weak var thursdayEveningButton: UIButton!
    @IBOutlet weak var fridayMorningButton: UIButton!
    @IBOutlet weak var fridayAfternoonButton: UIButton!
    @IBOutlet weak var fridayEveningButton: UIButton!
    @IBOutlet weak var saturdayMorningButton: UIButton!
    @IBOutlet weak var saturdayAfternoonButton: UIButton!
    @IBOutlet weak var saturdayEveningButton: UIButton!
    @IBOutlet weak var sundayMorningButton: UIButton!
    @IBOutlet weak var sundayAfternoonButton: UIButton!
    @IBOutlet weak var sundayEveningButton: UIButton!
    @IBOutlet weak var nextButton: UIButton!
    
    // MARK: - Variables
    // Variables passed from last segue
    var carOrMotorcycle = String()
    var address = [String]()
    
    // Variables from this view controller
    var availabilityChoices = [[Bool]]()
    var availabilityTimeChoices = [[String]]()
    
    // MARK: - UI Setup
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        setUpObjects()
    }
    
    func setUpObjects() {
        Utilities.styleButtonNeutral(nextButton)
    }
    
    
    // MARK: - Button Functions
    
    @IBAction func nextButtonPressed(_ sender: Any) {
        getAvailabilityInfo()
        availabilityTimeChoices = getTimeSlotFromBoolean()
    }
    
    
    //MARK: - Monday
    @IBAction func mondayMorningSelected(_ sender: Any) {
        Utilities.toggleButton(mondayMorningButton)
    }
    
    @IBAction func mondayAfternoonSelected(_ sender: Any) {
        Utilities.toggleButton(mondayAfternoonButton)
    }
    
    @IBAction func mondayEveningSelected(_ sender: Any) {
        Utilities.toggleButton(mondayEveningButton)
    }
    
    // MARK: - Tuesday
    @IBAction func tuesdayMondaySelected(_ sender: Any) {
        Utilities.toggleButton(tuesdayMorningButton)
    }
    
    @IBAction func tuesdayAfternoonSelected(_ sender: Any) {
        Utilities.toggleButton(tuesdayAfternoonButton)
    }
    
    @IBAction func tuesdayEveningSelected(_ sender: Any) {
        Utilities.toggleButton(tuesdayEveningButton)
    }
    
    // MARK: - Wednesday
    @IBAction func wednesdayMorningSelected(_ sender: Any) {
        Utilities.toggleButton(wednesdayMorningButton)
    }
    
    @IBAction func wednesdayAfternoonSelected(_ sender: Any) {
        Utilities.toggleButton(wednesdayAfternoonButton)
    }
    
    @IBAction func wednesdayEveningSelected(_ sender: Any) {
        Utilities.toggleButton(wednesdayEveningButton)
    }
    
    // MARK: - Thursday
    @IBAction func thursdayMorningSelected(_ sender: Any) {
        Utilities.toggleButton(thursdayMorningButton)
    }
    
    @IBAction func thursdayAfternoonSelected(_ sender: Any) {
        Utilities.toggleButton(thursdayAfternoonButton)
    }
    
    @IBAction func thursdayEveningSelected(_ sender: Any) {
        Utilities.toggleButton(thursdayEveningButton)
    }
    
    // MARK: - Friday
    @IBAction func fridayMorningSelected(_ sender: Any) {
        Utilities.toggleButton(fridayMorningButton)
    }
    
    @IBAction func fridayAfternoonSelected(_ sender: Any) {
        Utilities.toggleButton(fridayAfternoonButton)
    }
    
    @IBAction func fridayEveningSelected(_ sender: Any) {
        Utilities.toggleButton(fridayEveningButton)
    }
    
    // MARK: - Saturday
    @IBAction func saturdayMorningSelected(_ sender: Any) {
        Utilities.toggleButton(saturdayMorningButton)
    }
    
    @IBAction func saturdayAfternoonSelected(_ sender: Any) {
        Utilities.toggleButton(saturdayAfternoonButton)
    }
    
    @IBAction func saturdayEveningSelected(_ sender: Any) {
        Utilities.toggleButton(saturdayEveningButton)
    }
    
    // MARK: - Sunday
    @IBAction func sundayMorningSelected(_ sender: Any) {
        Utilities.toggleButton(sundayMorningButton)
    }
    
    @IBAction func sundayAfternoonSelected(_ sender: Any) {
        Utilities.toggleButton(sundayAfternoonButton)
    }
    
    @IBAction func sundayEveningSelected(_ sender: Any) {
        Utilities.toggleButton(sundayEveningButton)
    }
    
    // MARK: - Validation
    func getAvailabilityInfo() {
        let monday: [Bool] = [mondayMorningButton.isSelected, mondayAfternoonButton.isSelected, mondayEveningButton.isSelected]
        let tuesday: [Bool] = [tuesdayMorningButton.isSelected, tuesdayAfternoonButton.isSelected, tuesdayEveningButton.isSelected]
        let wednesday: [Bool] = [wednesdayMorningButton.isSelected, wednesdayAfternoonButton.isSelected, wednesdayEveningButton.isSelected]
        let thursday: [Bool] = [thursdayMorningButton.isSelected, thursdayAfternoonButton.isSelected, thursdayEveningButton.isSelected]
        let friday: [Bool] = [fridayMorningButton.isSelected, fridayAfternoonButton.isSelected, fridayEveningButton.isSelected]
        let saturday: [Bool] = [saturdayMorningButton.isSelected, saturdayAfternoonButton.isSelected, saturdayEveningButton.isSelected]
        let sunday: [Bool] = [sundayMorningButton.isSelected, sundayAfternoonButton.isSelected, sundayEveningButton.isSelected]
        availabilityChoices.append(monday)
        availabilityChoices.append(tuesday)
        availabilityChoices.append(wednesday)
        availabilityChoices.append(thursday)
        availabilityChoices.append(friday)
        availabilityChoices.append(saturday)
        availabilityChoices.append(sunday)        
    }
    
    // MARK: - Time Selection
    func getTimeSlotFromBoolean() -> [[String]] {
        var timeSlotsSelected = Array(repeating: Array(repeating: String(), count: 3), count: 7)
        let morning = "07:00-12:00", afternoon = "12:00-17:00", evening = "17:00-22:00"
        for i in 0...6 {
            if availabilityChoices[i][0] == true{
                timeSlotsSelected[i][0] = morning
            }
            if availabilityChoices[i][1] == true {
                timeSlotsSelected[i][1] = afternoon
            }
            if availabilityChoices[i][2] {
                timeSlotsSelected[i][2] = evening
            }
        }
        return timeSlotsSelected
    }
    
    
    
    
    // MARK: - Navigation

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let segueName = segue.identifier
        
        if segueName == "toAboutMe" {
            let destination = segue.destination as! AboutMeEntryViewController
            destination.carOrMotorcycle = self.carOrMotorcycle
            destination.address = self.address
            destination.availabilityChoices = availabilityTimeChoices
        }
    }
}
