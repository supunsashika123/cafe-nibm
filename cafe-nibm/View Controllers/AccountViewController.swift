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
    @IBOutlet weak var lblMobile: UILabel!
    @IBOutlet weak var btnSignOut: UIButton!
    
    let userDefaults = UserDefaults()
    var userData = {}

    override func viewDidLoad() {
        super.viewDidLoad()

        // Fetch user
        fetchUser()
        
    }
    
    
    func fetchUser() {
        lblEmail.text = ""
        lblMobile.text = ""
        lblUserName.text = "Loading profile..."
        
        let db = Firestore.firestore()
        let userId = userDefaults.value(forKey: "USER_ID") as? String
        
        
        db.collection("users")
            .whereField("uid", isEqualTo: userId!).getDocuments() {
                (querySnapshot, err) in
                    if let err = err {
                        print("Error getting documents: \(err)")
                    } else {
                        print(querySnapshot!.documents[0].data())
                        
                        let userData = querySnapshot!.documents[0].data()
                        self.lblUserName.text = "Hello - \(userData["firstname"] as? String ?? "-") \(userData["lastname"] as? String ?? "-")"
                        
                        self.lblEmail.text = "Email - \(userData["email"] as? String ?? "-")"
                        
                        self.lblMobile.text = "Mobile - \(userData["mobile"] as? String ?? "-")"
                    }
            }
    }
    
    
    @IBAction func onSignOutBtnClick(_ sender: Any) {
        userDefaults.removeObject(forKey: "USER_ID")
        
        let loginVC = storyboard?.instantiateViewController(identifier: Constants.Storyboard.loginViewController) as? LoginViewController
        
        view.window?.rootViewController = loginVC
        view.window?.makeKeyAndVisible()
    }
}
