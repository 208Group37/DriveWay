//
//  InstructorProfileViewController.swift
//  DriveWay
//
//  Created by Christian Carroll on 28/04/2021.
//

import UIKit
import FirebaseFirestore
import FirebaseAuth

class InstructorProfileViewController: UIViewController {
    
    
    @IBOutlet weak var CarMakeModelLabel: UILabel!
    
    let userInfo = Auth.auth().currentUser
    var userDocInfo = [QueryDocumentSnapshot]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        documentRetrieve()
        
        

        // Do any additional setup after loading the view.
    }
    
    func documentRetrieve() {
        let database = Firestore.firestore()
        let collectionReference = database.collection("Instructors")
        let query = collectionReference.whereField("userID", isEqualTo: userInfo!.uid)
        
        /*query.getDocuments { (snapshot, err) in
            if err != nil {
                print("There was an error, \(err.debugDescription)")
            } else {
                for field in snapshot!.documents {
                    return field.data()
                }
            }*/
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
