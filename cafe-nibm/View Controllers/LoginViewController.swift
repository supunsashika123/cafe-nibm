//
//  LoginViewController.swift
//  cafe-nibm
//
//  Created by Supun Sashika on 2021-03-06.
//

import UIKit
import FirebaseAuth

class LoginViewController: UIViewController, UITextFieldDelegate {

    @IBOutlet weak var usernameTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var errorLabel: UILabel!
    @IBOutlet weak var spinner: UIActivityIndicatorView!
    
    let userDefaults = UserDefaults()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        navigationController?.interactivePopGestureRecognizer?.delegate = nil
        loginButton.layer.cornerRadius = 10
        
        setUpElements()
    }
    
    func setUpElements() {
        errorLabel.alpha = 0
        self.passwordTextField.delegate = self
    }

    func validateForm() -> String? {
        if usernameTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" || passwordTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) == ""  {
            return "Please fill the form!"
        }
        return nil
    }
    
    func showError(_ message:String) {
        errorLabel.text = message
        errorLabel.alpha = 1
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.view.endEditing(true)
        return false
    }
    
    func navigateHome() {
        let tabViewController = storyboard?.instantiateViewController(identifier: Constants.Storyboard.tabBarController)
        
        view.window?.rootViewController = tabViewController
        view.window?.makeKeyAndVisible()
    }

    @IBAction func loginTapped(_ sender: Any) {
        let error = validateForm()
        
        if error != nil {
            showError(error!)
        } else {
            
            let email = usernameTextField.text!
            let password = passwordTextField.text!
            
            self.view.endEditing(true)
            spinner.startAnimating()
            
            Auth.auth().signIn(withEmail: email, password: password) { (result, err) in
                
                self.spinner.stopAnimating()
                
                if err != nil {
                    self.showError(err!.localizedDescription)
                }
                else {
                    self.userDefaults.setValue(result!.user.uid,forKey: "USER_ID")
                    
                    self.navigateHome()
                }
            }
        }
    }
}
