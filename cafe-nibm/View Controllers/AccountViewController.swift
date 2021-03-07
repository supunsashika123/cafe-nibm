//
//  AccountViewController.swift
//  cafe-nibm
//
//  Created by Supun Sashika on 2021-03-07.
//

import UIKit
import FirebaseFirestore

class AccountViewController: UIViewController {

    @IBOutlet weak var lblUserName: UILabel!
    @IBOutlet weak var lblEmail: UILabel!
    
    let userDefaults = UserDefaults()
    var userData = {}

    override func viewDidLoad() {
        super.viewDidLoad()

        // Fetch user
        fetchUser()
        
    }
    
    
    func fetchUser() {
        let db = Firestore.firestore()
        let userId = userDefaults.value(forKey: "USER_ID") as? String
        
        
        let userData = db.collection("users")
            .whereField("uid", isEqualTo: userId!).getDocuments() {
                (querySnapshot, err) in
                    if let err = err {
                        print("Error getting documents: \(err)")
                    } else {
                        print(querySnapshot!.documents[0].data())
                        
                        let userData = querySnapshot!.documents[0].data()
                        self.lblUserName.text = userData["firstname"] as? String
                        
                        self.lblEmail.text = userData["email"] as? String
                    }
            }
    }
}
