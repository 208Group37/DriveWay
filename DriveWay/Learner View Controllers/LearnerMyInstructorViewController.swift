//
//  LearnerMyInstructorViewController.swift
//  DriveWay
//
//  Created by Morgan Eckersley on 29/04/2021.
//

import UIKit
import FirebaseFirestore
import FirebaseAuth

class LearnerMyInstructorViewController: UIViewController {

    // MARK: - Outlets and Variables
    @IBOutlet weak var noInstructorContainerView: UIView!
    @IBOutlet weak var carInstructorContainerView: UIView!
    @IBOutlet weak var motorcycleInstructorContainerView: UIView!
    
    let userAccInfo = Auth.auth().currentUser
    
    // MARK: - UI Setup
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        setUpObjects()
    }
    
    func setUpObjects() {
        doesUserHaveInstructor()
    }
    
    
    func doesUserHaveInstructor() {
        let database = Firestore.firestore()
        let collectionReference = database.collection("Students")
        let query = collectionReference.whereField("userID", isEqualTo: userAccInfo!.uid)
        
        query.getDocuments { (snapshot, err) in
            if err != nil {
                print(err.debugDescription)
            } else {
                for document in snapshot!.documents {
                    // All the information stored in the document about the user
                    let userDocData = document.data()
                    
                    if userDocData["hasInstructor"] as! Bool {
                        if userDocData["vehicle"] as! String == "car"{
                            self.carInstructorContainerView.isHidden = false
                        } else {
                            self.motorcycleInstructorContainerView.isHidden = false
                        }
                    } else {
                        self.noInstructorContainerView.isHidden = false
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
