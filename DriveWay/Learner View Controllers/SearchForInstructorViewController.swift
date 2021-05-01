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

class SearchForInstructorViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    // MARK: - Outlets and Variables
    
    @IBOutlet weak var searchBar: UISearchBar!
    
    @IBOutlet weak var sortButton: UIButton!
    @IBOutlet weak var filterButton: UIButton!
    
    @IBOutlet weak var resultsTable: UITableView!
    
    let userAccInfo = Auth.auth().currentUser
    
    // MARK: - Struct For Instructor Search Result
    struct instructorResult {
        var name: String
        var gender: String
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
        getInstructorInformation()
    }    
    
    // MARK: Table View Functions
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "resultsCell", for: indexPath) as! searchResultTableViewCell
        
        let instructor = instructorResults[indexPath.row]
        print(instructor)
        cell.instructorNameGenderLabel.text = instructor.name + ", " + instructor.gender
        cell.transmissionLabel.text = instructor.transmission
        cell.priceLabel.text = String(instructor.price)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return instructorResults.count
    }
    
    func refreshTable() {
        resultsTable.reloadData()
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
                                                            
                                                            
                                                            
                                                            let instructor = instructorResult(name: fullName, gender: gender, transmission: transmission, price: price , distanceAway: distance, operatingRange: operatingRange)
                                                            
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
