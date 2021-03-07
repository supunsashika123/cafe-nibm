//
//  SignUpViewController.swift
//  cafe-nibm
//
//  Created by Supun Sashika on 2021-03-06.
//

import UIKit
import FirebaseAuth
import Firebase
import FirebaseFirestore

class SignUpViewController: UIViewController {
    
    
    @IBOutlet weak var firstNameTextField: UITextField!
    @IBOutlet weak var lastNameTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var mobileTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var signUpButton: UIButton!
    @IBOutlet weak var errorLabel: UILabel!
    
    let userDefaults = UserDefaults()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setUpElements()
        // Do any additional setup after loading the view.
    }
    
    func setUpElements() {
        errorLabel.alpha = 0
    }
    
    func validateForm() -> String? {
        if firstNameTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" || lastNameTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" || passwordTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" || mobileTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" || emailTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" {
            return "Please fill all fields!"
        }
        return nil
    }
    
    @IBAction func signUpTapped(_ sender: Any) {
        let error = validateForm()
        
        if error != nil {
            showError(error!)
        } else {
            
            let email = emailTextField.text!
            let firstName = firstNameTextField.text!
            let lastName = lastNameTextField.text!
            let mobile = mobileTextField.text!
            let password = passwordTextField.text!
            
            signUpButton.setTitle("Please wait...",for: .normal)
            
            Auth.auth().createUser(withEmail: email, password: password) { (result, err) in
                
                if err != nil {
                    print(err!)
                    self.signUpButton.setTitle("Sign Up",for: .normal)
                    self.showError(err!.localizedDescription)
                }
                else {
                    let db = Firestore.firestore()
                    
                    db.collection("users").addDocument(data: ["firstname":firstName, "lastname":lastName,"email":email,"mobile":mobile, "uid":result!.user.uid]) { (err) in
                        
                        if err != nil {
                            self.showError("Error saving user!")
                        }
                    }
                    
                    self.userDefaults.setValue(result!.user.uid,forKey: "USER_ID")
                    
                    self.navigateHome()
                }
            }
            
        }
    }
    
    func navigateHome() {
        let tabViewController = storyboard?.instantiateViewController(identifier: Constants.Storyboard.tabBarController)
        
        view.window?.rootViewController = tabViewController
        view.window?.makeKeyAndVisible()
    }
    
    func showError(_ message:String) {
        errorLabel.text = message
        errorLabel.alpha = 1
    }
    
}
