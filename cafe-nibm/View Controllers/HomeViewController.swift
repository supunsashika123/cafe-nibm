//
//  HomeViewController.swift
//  cafe-nibm
//
//  Created by Supun Sashika on 2021-03-06.
//

import UIKit

class HomeViewController: UIViewController {
    @IBOutlet weak var homeLabel: UILabel!
    @IBOutlet weak var btnSignOut: UIButton!
    
    let userDefaults = UserDefaults()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        let user = userDefaults.value(forKey: "USER_ID")
        print(user!)
//        homeLabel.text = user.name
    }
    
    
    @IBAction func onSignOutButtonClick(_ sender: Any) {
        userDefaults.removeObject(forKey: "USER_ID")
        
        let loginVC = storyboard?.instantiateViewController(identifier: Constants.Storyboard.loginViewController) as? LoginViewController
        
        view.window?.rootViewController = loginVC
        view.window?.makeKeyAndVisible()
        
    }
}
