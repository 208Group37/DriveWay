//
//  SearchForInstructorViewController.swift
//  DriveWay
//
//  Created by Morgan Eckersley on 01/05/2021.
//

import UIKit
import FirebaseFirestore
import FirebaseAuth
import CoreLocation

class SearchForInstructorViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UIPickerViewDelegate, UIPickerViewDataSource, UITextFieldDelegate {

    // MARK: - Outlets and Variables
    
    @IBOutlet weak var searchBar: UITextField!
    @IBOutlet weak var sortButton: UIButton!
    @IBOutlet weak var filterButton: UIButton!
    
    @IBOutlet weak var resultsTable: UITableView!
    
    let userAccInfo = Auth.auth().currentUser
    
    var sortPicker = UIPickerView()
    var toolBar = UIToolbar()
    let sortOptions = ["Price ASC", "Price DEC", "Age ASC", "Age DEC", "Distance Away ASC", "Distance Away DEC"]
    var selectedSort: String = "Price ASC"
    
    // MARK: - Struct For Instructor Search Result
    struct instructorResult {
        var name: String
        var gender: String
        var age: Int
        var transmission: String
        var price: String
        var distanceAway: String
        var operatingRange: Int
    }
    
    var instructorResults = [instructorResult]()
    
    // MARK: - UI Setup
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        setUpObjects()
    }
    
    func setUpObjects() {
        getInstructorInformation()
        self.searchBar.delegate = self
    }
    
    // MARK: Table View Functions
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "resultsCell", for: indexPath) as! searchResultTableViewCell
        
        let instructor = instructorResults[indexPath.row]
        print(instructor)
        cell.instructorNameGenderLabel.text = instructor.name + ", " + instructor.gender + ", " + String(instructor.age)
        cell.transmissionLabel.text = instructor.transmission
        cell.priceLabel.text = "£" + String(instructor.price) + "/hr, " + instructor.distanceAway + " Miles Away"
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return instructorResults.count
    }
    
    func refreshTable() {
        resultsTable.reloadData()
    }
    
    // MARK: - Button Functions
    
    
    @IBAction func sortButtonPressed(_ sender: Any) {
        sortPicker = UIPickerView.init()
        sortPicker.delegate = self
        sortPicker.dataSource = self
        sortPicker.backgroundColor = UIColor.white
        sortPicker.setValue(UIColor.black, forKey: "textColor")
        sortPicker.autoresizingMask = .flexibleWidth
        sortPicker.contentMode = .center
        sortPicker.frame = CGRect.init(x: 0.0, y: UIScreen.main.bounds.size.height - 300, width: UIScreen.main.bounds.size.width, height: 300)
        self.view.addSubview(sortPicker)
                
        toolBar = UIToolbar.init(frame: CGRect.init(x: 0.0, y: UIScreen.main.bounds.size.height - 300, width: UIScreen.main.bounds.size.width, height: 50))
        toolBar.items = [UIBarButtonItem.init(title: "Done", style: .done, target: self, action: #selector(sortSelected))]
        self.view.addSubview(toolBar)
    }
    
    // MARK: Filter and Sort Funstions
    
    // Compulsary functions for the picker view
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return sortOptions.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return sortOptions[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        selectedSort = sortOptions[row]
    }

    // When done is pressed set the text field to be what the user chose
    @objc func sortSelected() {
        print(selectedSort)
        if selectedSort == "Price ASC" {
            instructorResults = sortPriceASC(listOfInstructors: instructorResults)
            refreshTable()
        }
        if selectedSort == "Price DEC" {
            instructorResults = sortPriceASC(listOfInstructors: instructorResults)
            instructorResults.reverse()
            refreshTable()
        }
        if selectedSort == "Age ASC" {
            instructorResults = sortAgeASC(listOfInstructors: instructorResults)
            refreshTable()
        }
        if selectedSort == "Age DEC" {
            instructorResults = sortAgeASC(listOfInstructors: instructorResults)
            instructorResults.reverse()
            refreshTable()
        }
        if selectedSort == "Distance Away ASC" {
            instructorResults = sortDistanceAwayASC(listOfInstructors: instructorResults)
            refreshTable()
        }
        if selectedSort == "Distance Away DEC" {
            instructorResults = sortDistanceAwayASC(listOfInstructors: instructorResults)
            instructorResults.reverse()
            refreshTable()
        }
        sortPicker.removeFromSuperview()
        toolBar.removeFromSuperview()
    }
    
    // MARK: - Sorting Functions
    func sortPriceASC(listOfInstructors: [instructorResult]) -> [instructorResult] {
        let sortedArray = listOfInstructors.sorted { (lhs: instructorResult, rhs: instructorResult) -> Bool in
            // you can have additional code here
            return lhs.price < rhs.price
        }
        return sortedArray
    }
    
    func sortAgeASC(listOfInstructors: [instructorResult]) -> [instructorResult] {
        let sortedArray = listOfInstructors.sorted { (lhs: instructorResult, rhs: instructorResult) -> Bool in
            // you can have additional code here
            return lhs.age < rhs.age
        }
        return sortedArray
    }
    
    func sortDistanceAwayASC(listOfInstructors: [instructorResult]) -> [instructorResult] {
        let sortedArray = listOfInstructors.sorted { (lhs: instructorResult, rhs: instructorResult) -> Bool in
            // you can have additional code here
            return lhs.distanceAway < rhs.distanceAway
        }
        return sortedArray
    }
    
    // MARK: - Search Functions
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        searchBar.resignFirstResponder()
        searchForInstructor(name: searchBar.text ?? "")
        return true
    }
    
    func searchForInstructor(name: String) {
        var searchResults = [instructorResult]()
        for instructor in instructorResults {
            if name.lowercased() == instructor.name.lowercased() {
                searchResults.append(instructor)
            }
        }
        instructorResults = searchResults
        refreshTable()
    }
    
    
    // MARK: - Data Retrieval
    func getInstructorInformation() {
        print("Getting insructor info car")
        let database = Firestore.firestore()
        let query = database.collection("Instructors")
        
        query.getDocuments { (snapshot, err) in
            if err != nil {
                print(err.debugDescription)
            } else {
                for document in snapshot!.documents {
                    let instructorDocData = document.data()
                    
                    if instructorDocData["vehicle"] as! String == "car" {
                        let names = instructorDocData["name"] as! [String : Any]
                        let firstName = names["first"]! as! String
                        let lastName = names["last"]! as! String
                        let fullName = firstName + " " + lastName
                        
                        let publicInfo = instructorDocData["publicInfo"] as! [String : String]
                        let gender = publicInfo["sex"]!
                        
                        let birthday = publicInfo["birthDate"]!
                        
                        let age = Utilities.calculateAge(birthday: birthday)
                        
                        let carInfo = instructorDocData["car"] as! [String : String]
                        let transmission = carInfo["transmission"]!
                        
                        let lessonInfo = instructorDocData["lesson"] as! [String : Any]
                        let price = lessonInfo["price"]! as! String
                        
                        let operatingRange = lessonInfo["operatingRadius"] as! Int
                        
                        // Getting the instructors postcode from the database
                        let privateInfo = instructorDocData["privateInfo"] as! [String : Any]
                        let addresses = privateInfo["addresses"] as! [String : Any]
                        let homeAddress = addresses["homeAddress"] as! [String : String]
                        
                        let instructorAddress = "\(homeAddress["line1"]!), \(homeAddress["line2"]!), \(homeAddress["city"]!)"
                        
                        
                        let collectionReference = database.collection("Students")
                        let query = collectionReference.whereField("userID", isEqualTo: self.userAccInfo!.uid)
                        
                        query.getDocuments { (snapshot, err) in
                            if err != nil {
                                print(err.debugDescription)
                            } else {
                                for document in snapshot!.documents {
                                    // All the information stored in the document about the user
                                    let userDocData = document.data()
                                    
                                    let privateInfo = userDocData["privateInfo"] as! [String : Any]
                                    let addresses = privateInfo["addresses"] as! [String : Any]
                                    let homeAddress = addresses["homeAddress"] as! [String : String]
                                    
                                    let userAddress = "\(homeAddress["line1"]!), \(homeAddress["line2"]!), \(homeAddress["city"]!)"
                                    
                                    let geocoder1 = CLGeocoder()
                                    let geocoder2 = CLGeocoder()
                                    
                                    var userLocation = CLLocation()
                                    var instructorLocation = CLLocation()
                                    
                                    geocoder1.geocodeAddressString(userAddress) { placemark, err in
                                        if err != nil {
                                            print("There was an error, \(err.debugDescription)")
                                        } else {
                                            for place in placemark! {
                                                userLocation = place.location!
                                                geocoder2.geocodeAddressString(instructorAddress) { placemark, err in
                                                    if err != nil {
                                                        print("There was an error, \(err.debugDescription)")
                                                    } else {
                                                        for place in placemark! {
                                                            instructorLocation = place.location!
                                                            let CLdistance = userLocation.distance(from: instructorLocation)
                                                            
                                                            
                                                            let distance = String(Float(CLdistance/1600).rounded(.up))
                                                            
                                                            
                                                            let instructor = instructorResult(name: fullName, gender: gender, age: age, transmission: transmission, price: price , distanceAway: distance, operatingRange: operatingRange)
                                                        
                                                            self.instructorResults.append(instructor)
                                                            
                                                            self.refreshTable()
                                                        }
                                                    }
                                                }
                                            }
                                        }
                                    }
                                }
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

class searchResultTableViewCell: UITableViewCell {
    @IBOutlet weak var instructorNameGenderLabel: UILabel!
    @IBOutlet weak var transmissionLabel: UILabel!
    @IBOutlet weak var priceLabel: UILabel!
}
