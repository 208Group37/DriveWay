//
//  InstructorAvailabilityViewController.swift
//  DriveWay
//
//  Created by Morgan Eckersley on 07/04/2021.
//

import UIKit
import FirebaseFirestore
import FirebaseAuth

class InstructorAvailabilityViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource {

    // MARK: - Outlets
    @IBOutlet weak var priceTextField: UITextField!
    @IBOutlet weak var dayTextField: UITextField!
    @IBOutlet weak var startTimeTextField: UITextField!
    @IBOutlet weak var endTimeTextField: UITextField!
    
    @IBOutlet weak var addButton: UIButton!
    
    @IBOutlet weak var addedTimesTextView: UITextView!
    
    @IBOutlet weak var confirmationButton: UIButton!
    
    @IBOutlet weak var errorLabel: UILabel!
    
    @IBOutlet weak var finishButton: UIButton!
    
    
    // MARK: - Variables
    // Passed from last view controller
    var vehicleInfo = [String : Any]()
    var crashCourse = Bool()
    var personalData = [String : Any]()
    var distanceForALesson = Float()
    
    // For this view controller
    let dayPicker = UIPickerView()
    let dayOptions = ["Monday", "Tuesday", "Wednesday", "Thursday", "Friday", "Saturday", "Sunday"]
    
    let startTimePicker = UIDatePicker()
    let endTimePicker = UIDatePicker()
    
    // MARK: - UI Setup
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        setUpObjects()
    }
    
    func setUpObjects() {
        Utilities.styleTextField(priceTextField)
        Utilities.styleTextField(dayTextField)
        createDayPicker()
        Utilities.styleTextField(startTimeTextField)
        createStartTimePicker()
        Utilities.styleTextField(endTimeTextField)
        createEndTimePicker()
        
        Utilities.styleButtonNeutral(addButton)
        Utilities.styleTextView(addedTimesTextView)
        Utilities.styleButtonGreen(finishButton)
    }
    
    // MARK: - Day Picker Functions
    func createDayPicker() {
        // Creating a toolbar
        dayPicker.delegate = self
        
        let toolbar = UIToolbar()
        toolbar.sizeToFit()
        
        let doneButton = UIBarButtonItem(barButtonSystemItem: .done, target: nil, action: #selector(daySelected))
        
        toolbar.setItems([doneButton], animated: true)
        
        dayTextField.inputAccessoryView = toolbar
        dayTextField.inputView = dayPicker
    }
    
    // When done is pressed set the text field to be what the user chose
    @objc func daySelected() {
        dayTextField.text = dayOptions[dayPicker.selectedRow(inComponent: 0)]
        self.view.endEditing(true)
    }
    
    // MARK: - Time Picker Functions
    
    func createStartTimePicker() {
        // Setting up the datePickers appearance
        startTimePicker.preferredDatePickerStyle = UIDatePickerStyle.wheels
        startTimePicker.datePickerMode = .time
        startTimePicker.locale = Locale.init(identifier: "en_GB")
        // Creating the toolbar that will hold the done button
        let toolbar = UIToolbar()
        toolbar.sizeToFit()
        
        // Creating the done button for the tool bar
        let doneButton = UIBarButtonItem(barButtonSystemItem: .done, target: nil, action: #selector(startTimeSelected))
        toolbar.setItems([doneButton], animated: true)
        
        // Assigning the tool bar to the date picker
        startTimeTextField.inputAccessoryView = toolbar
        
        // Assigning the datepicker to the text field
        startTimeTextField.inputView = startTimePicker
    }
    
    @objc func startTimeSelected(){
        let dateFormatter = DateFormatter()
        dateFormatter.locale = startTimePicker.locale
        dateFormatter.dateStyle = .none
        dateFormatter.timeStyle = .short
        
        startTimeTextField.text = dateFormatter.string(from: startTimePicker.date)
        self.view.endEditing(true)
    }
    
    func createEndTimePicker() {
        // Setting up the datePickers appearance
        endTimePicker.preferredDatePickerStyle = UIDatePickerStyle.wheels
        endTimePicker.datePickerMode = .time
        endTimePicker.locale = Locale.init(identifier: "en_GB")
        // Creating the toolbar that will hold the done button
        let toolbar = UIToolbar()
        toolbar.sizeToFit()
        
        // Creating the done button for the tool bar
        let doneButton = UIBarButtonItem(barButtonSystemItem: .done, target: nil, action: #selector(endTimeSelected))
        toolbar.setItems([doneButton], animated: true)
        
        // Assigning the tool bar to the date picker
        endTimeTextField.inputAccessoryView = toolbar
        
        // Assigning the datepicker to the text field
        endTimeTextField.inputView = endTimePicker
    }
    
    @objc func endTimeSelected(){
        let dateFormatter = DateFormatter()
        dateFormatter.locale = endTimePicker.locale
        dateFormatter.dateStyle = .none
        dateFormatter.timeStyle = .short
        
        endTimeTextField.text = dateFormatter.string(from: endTimePicker.date)
        self.view.endEditing(true)
    }
    
    
    // MARK: - Picker Set Up Functions
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return dayOptions.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return dayOptions[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        dayTextField.text = dayOptions[row]
    }
    
    
    // MARK: - IBAction Functions
    // Adds the selected day and times to the text field
    @IBAction func addButtonPressed(_ sender: Any) {
        let isThereAnError = validateDateFields()
        
        if isThereAnError == false {
            addedTimesTextView.text = "\(addedTimesTextView.text!) \(dayTextField.text!) \(startTimeTextField.text!)-\(endTimeTextField.text!)\n"
        }
    }
    
    // Toggles the confirmation button
    @IBAction func confirmationSelected(_ sender: Any) {
        Utilities.toggleButton(confirmationButton)
    }
    
    // When the finish button is pressed
    @IBAction func finishButtonPressed(_ sender: Any) {
        // Check for errors in the input
        let isThereAnError = validateFields()
        
        // If there is an error
        if isThereAnError == true {
            // Tell the user
            Utilities.showError("Please fill in all sections", errorLabel: errorLabel)
        } else {
            // Otherwise
            let price = priceTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
            let availability = availabilityToList()
            var dataToAdd = [String : Any]()
            
            // Create array of all data that would be added if the instructor is a car instructor
            if vehicleInfo["type"] as! String == "car" {
                dataToAdd = [ "vehicle" : vehicleInfo["type"]!,
                              "aboutMe" : personalData["aboutMe"] ?? "",
                                  "lesson" : ["crashCourses" :  crashCourse,
                                              "operatingRadius" : distanceForALesson,
                                              "price" : price],
                                  "car" : ["make" : vehicleInfo["make"],
                                           "model" : vehicleInfo["model"],
                                           "numberPlate" : vehicleInfo["numberPlate"],
                                           "transmission" : vehicleInfo["transmission"],
                                           "fuelType" : vehicleInfo["fuelType"]],
                                  "privateInfo" : [
                                      "addresses" : [
                                          "homeAddress" : [
                                              "line1" : personalData["addressLineOne"],
                                              "line2" : personalData["addressLineTwo"],
                                              "city" : personalData["city"],
                                              "postcode" : personalData["postcode"]
                                          ]
                                      ]
                                  ],
                                  "availability" : [
                                    "monday" : availability[0],
                                    "tuesday" : availability[1],
                                    "wednesday" : availability[2],
                                    "thursday" : availability[3],
                                    "friday" : availability[4],
                                    "saturday" : availability[5],
                                    "sunday" : availability[6]]
                ]
            }
            
            // Create array of all data that will be added if the instructor is a motorcycle instructor
            if vehicleInfo["type"] as! String == "motorcycle" {
                dataToAdd = [ "vehicle" : vehicleInfo["type"]!,
                              "students" : [],
                              "aboutMe" : personalData["aboutMe"] ?? "",
                                  "lesson" : ["crashCourses" :  crashCourse,
                                              "operatingRadius" : distanceForALesson,
                                              "price" : price],
                                  "motorcycle" : ["make" : vehicleInfo["make"],
                                           "model" : vehicleInfo["model"],
                                           "numberPlate" : vehicleInfo["numberPlate"],
                                           "transmission" : vehicleInfo["transmission"],
                                           "fuelType" : vehicleInfo["fuelType"],
                                           "engine" : vehicleInfo["engine"]],
                                  "privateInfo" : [
                                      "addresses" : [
                                          "homeAddress" : [
                                              "line1" : personalData["addressLineOne"],
                                              "line2" : personalData["addressLineTwo"],
                                              "city" : personalData["city"],
                                              "postcode" : personalData["postcode"]
                                          ]
                                      ]
                                  ],
                                  "availability" : [
                                    "monday" : availability[0],
                                    "tuesday" : availability[1],
                                    "wednesday" : availability[2],
                                    "thursday" : availability[3],
                                    "friday" : availability[4],
                                    "saturday" : availability[5],
                                    "sunday" : availability[6]]
                ]
            }
            
            // Adding user to the database
            let user = Auth.auth().currentUser!
            Utilities.addDataToUserDocument(user, collection: "Instructors", dataToAdd: dataToAdd)
            
            performSegue(withIdentifier: "toInstructorHomeScreen", sender: nil)
            
        }
    }
    
    // MARK: - Validation
    // Checking if there are any empty fields when adding a day of availability
    func validateDateFields() -> Bool {
        if dayTextField.text == "" || startTimeTextField.text == "" || endTimeTextField.text == "" {
            return true
        }
        return false
    }
    
    // Check if there are any empty fields
    func validateFields() -> Bool {
        let price = priceTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines)
        let availability = addedTimesTextView.text
        let confirmed = confirmationButton.isSelected
        
        if price == "" || availability == nil || confirmed == false {
            return true
        }
        return false
    }
    
    // MARK: - Data Collection
    // Converting the times added to a 2D array
    func availabilityToList() -> [[String]] {
        let allAvailability = addedTimesTextView.text
        var dayByDay = [[String]]()
        var monday = [String](), tuesday = [String](), wednesday = [String](), thursday = [String](), friday = [String](), saturday = [String](), sunday = [String]()
        
        let lineByLineAvailability = allAvailability!.components(separatedBy: "\n")
        
        for line in lineByLineAvailability {
            let lineSegment = line.components(separatedBy: " ")
            
            if lineSegment.count != 1 {
                if lineSegment[1] == "Monday" {
                    monday.append(lineSegment[2])
                }
                if lineSegment[1] == "Tuesday" {
                    tuesday.append(lineSegment[2])
                }
                if lineSegment[1] == "Wednesday" {
                    wednesday.append(lineSegment[2])
                }
                if lineSegment[1] == "Thursday" {
                    thursday.append(lineSegment[2])
                }
                if lineSegment[1] == "Friday" {
                    friday.append(lineSegment[2])
                }
                if lineSegment[1] == "Saturday" {
                    saturday.append(lineSegment[2])
                }
                if lineSegment[1] == "Sunday" {
                    sunday.append(lineSegment[2])
                }
            }
        }
        
        dayByDay.append(monday)
        dayByDay.append(tuesday)
        dayByDay.append(wednesday)
        dayByDay.append(thursday)
        dayByDay.append(friday)
        dayByDay.append(saturday)
        dayByDay.append(sunday)
        print(dayByDay)
        
        return dayByDay
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
