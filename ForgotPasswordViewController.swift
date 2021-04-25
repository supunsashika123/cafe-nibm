//
//  ForgotPasswordViewController.swift
//  
//
//  Created by Supun Sashika on 2021-04-25.
//

import UIKit
import FirebaseAuth
import Firebase
import FirebaseFirestore

class ForgotPasswordViewController: UIViewController {
    
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var errorLabel: UILabel!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        errorLabel.alpha = 0
    }
    
    
    func showError(_ message:String) {
        errorLabel.text = message
        errorLabel.alpha = 1
    }
    
    
    @IBAction func resetPasswordTapped(_ sender: Any) {
        let email = emailTextField.text!
        
        Auth.auth().sendPasswordReset(withEmail: email, completion: { err in
            if err != nil {
                self.showError(err!.localizedDescription)
            }
            else {
                
                let alert = UIAlertController(title: "Password Reset Success!", message: "Please check your emails for next step.", preferredStyle: UIAlertController.Style.alert)
                
                alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: { (action: UIAlertAction!) in
                    let vc = self.storyboard?.instantiateViewController(withIdentifier: "LoginVC") as! LoginViewController
                    self.navigationController?.pushViewController(vc, animated: true)
                }))
                
                self.present(alert, animated: true, completion: nil)
            }
        })
        
    }
    
}
