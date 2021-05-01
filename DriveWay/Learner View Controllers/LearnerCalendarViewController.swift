//
//  LearnerHomeScreenViewController.swift
//  DriveWay
//
//  Created by Jacob Darby on 30/04/2021.
//
//  This file is responsible for the tab on the learner page that displays the calendar

import UIKit
import FirebaseAuth
import FirebaseFirestore

class LearnerCalendarViewController: UIViewController {

    // MARK: - Variables
    @IBOutlet weak var calendarContainerView: UIView!
    @IBOutlet weak var noInstructorCalendarContainerView: UIView!
    let userInfo = Auth.auth().currentUser
    
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
        let query = collectionReference.whereField("userID", isEqualTo: userInfo!.uid)
        
        query.getDocuments { (snapshot, err) in
            if err != nil {
                print(err.debugDescription)
            } else {
                for document in snapshot!.documents {
                    // All the information stored in the document about the user
                    let userDocData = document.data()
                    if userDocData["hasInstructor"] as! Bool {
                        self.noInstructorCalendarContainerView.isHidden = true
                    } else {
                        self.calendarContainerView.isHidden = true
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
