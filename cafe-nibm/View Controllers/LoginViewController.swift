//
//  LoginViewController.swift
//  cafe-nibm
//
//  Created by Supun Sashika on 2021-03-06.
//

import UIKit
import FirebaseAuth

class LoginViewController: UIViewController {

    @IBOutlet weak var usernameTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var errorLabel: UILabel!
    @IBOutlet weak var spinner: UIActivityIndicatorView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        navigationController?.interactivePopGestureRecognizer?.delegate = nil
        loginButton.layer.cornerRadius = 10
        
        setUpElements()
    }
    
    func setUpElements() {
        errorLabel.alpha = 0
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
    
    func navigateHome() {
        let homeViewController = storyboard?.instantiateViewController(identifier: Constants.Storyboard.homeViewController) as? HomeViewController
        
        view.window?.rootViewController = homeViewController
        view.window?.makeKeyAndVisible()
    }

    @IBAction func loginTapped(_ sender: Any) {
        let error = validateForm()
        
        if error != nil {
            showError(error!)
        } else {
            
            let email = usernameTextField.text!
            let password = passwordTextField.text!
            
            spinner.startAnimating()
            
            Auth.auth().signIn(withEmail: email, password: password) { (result, err) in
                
                self.spinner.stopAnimating()
                
                if err != nil {
                    self.showError(err!.localizedDescription)
                }
                else {
                    self.navigateHome()
                }
            }
        }
    }
}