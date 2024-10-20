//
//  ViewController.swift
//  TestFairDrive
//
//  Created by Sudeepa Pal on 19/10/24.
//

import UIKit
import FirebaseAuth


class ViewController: UIViewController {

    
     private let emailTextField: UITextField = {
         let textField = UITextField()
         textField.placeholder = "Email"
         textField.borderStyle = .none
         textField.autocapitalizationType = .none
         textField.keyboardType = .emailAddress
         textField.translatesAutoresizingMaskIntoConstraints = false
         textField.backgroundColor = UIColor(white: 0.95, alpha: 1)
         textField.layer.cornerRadius = 8
         textField.layer.masksToBounds = true
         textField.setLeftPaddingPoints(10)
         return textField
     }()
     
     private let passwordTextField: UITextField = {
         let textField = UITextField()
         textField.placeholder = "Password"
         textField.borderStyle = .none
         textField.isSecureTextEntry = true
         textField.translatesAutoresizingMaskIntoConstraints = false
         textField.backgroundColor = UIColor(white: 0.95, alpha: 1)
         textField.layer.cornerRadius = 8
         textField.layer.masksToBounds = true
         textField.setLeftPaddingPoints(10)
         return textField
     }()
     
     private let signUpButton: UIButton = {
         let button = UIButton(type: .system)
         button.setTitle("Sign Up", for: .normal)
         button.backgroundColor = UIColor.systemBlue
         button.setTitleColor(.white, for: .normal)
         button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 18)
         button.layer.cornerRadius = 8
         button.layer.shadowColor = UIColor.black.cgColor
         button.layer.shadowOpacity = 0.2
         button.layer.shadowOffset = CGSize(width: 0, height: 3)
         button.layer.shadowRadius = 5
         button.translatesAutoresizingMaskIntoConstraints = false
         return button
     }()
     
     private let errorLabel: UILabel = {
         let label = UILabel()
         label.text = ""
         label.textColor = .red
         label.textAlignment = .center
         label.numberOfLines = 0
         label.font = UIFont.systemFont(ofSize: 14)
         label.translatesAutoresizingMaskIntoConstraints = false
         return label
     }()
     
     private let titleLabel: UILabel = {
         let label = UILabel()
         label.text = "Create Account"
         label.font = UIFont.boldSystemFont(ofSize: 32)
         label.textAlignment = .center
         label.translatesAutoresizingMaskIntoConstraints = false
         return label
     }()
     
     override func viewDidLoad() {
         super.viewDidLoad()
         view.backgroundColor = UIColor.systemGroupedBackground
         
         
         view.addSubview(titleLabel)
         view.addSubview(emailTextField)
         view.addSubview(passwordTextField)
         view.addSubview(signUpButton)
         view.addSubview(errorLabel)
         
         
         setupConstraints()
         
        
         signUpButton.addTarget(self, action: #selector(signUpTapped), for: .touchUpInside)
     }
     
     
     func setupConstraints() {
         NSLayoutConstraint.activate([
             titleLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
             titleLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 60),
             titleLabel.widthAnchor.constraint(equalToConstant: 300),
             
             emailTextField.centerXAnchor.constraint(equalTo: view.centerXAnchor),
             emailTextField.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 40),
             emailTextField.widthAnchor.constraint(equalToConstant: 300),
             emailTextField.heightAnchor.constraint(equalToConstant: 45),
             
             passwordTextField.centerXAnchor.constraint(equalTo: view.centerXAnchor),
             passwordTextField.topAnchor.constraint(equalTo: emailTextField.bottomAnchor, constant: 20),
             passwordTextField.widthAnchor.constraint(equalToConstant: 300),
             passwordTextField.heightAnchor.constraint(equalToConstant: 45),
             
             signUpButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
             signUpButton.topAnchor.constraint(equalTo: passwordTextField.bottomAnchor, constant: 40),
             signUpButton.widthAnchor.constraint(equalToConstant: 200),
             signUpButton.heightAnchor.constraint(equalToConstant: 50),
             
             errorLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
             errorLabel.topAnchor.constraint(equalTo: signUpButton.bottomAnchor, constant: 20),
             errorLabel.widthAnchor.constraint(equalToConstant: 300)
         ])
     }
     
     
     @objc func signUpTapped() {
         guard let email = emailTextField.text, !email.isEmpty,
               let password = passwordTextField.text, !password.isEmpty else {
             errorLabel.text = "Please fill in all fields."
             return
         }
         
         
         Auth.auth().createUser(withEmail: email, password: password) { [weak self] authResult, error in
             guard let self = self else { return }
             
             if let error = error {
                 self.errorLabel.text = "Error: \(error.localizedDescription)"
             } else {
                 self.errorLabel.text = "Sign-up successful!"
                 // After successful signup, navigate to LoginViewController
                 self.navigateToLoginScreen()
                 
             }
         }
     }
    
    // Push LoginViewController after successful sign-up
        func navigateToLoginScreen() {
            let loginVC = LoginViewController() // Create instance of LoginViewController
            navigationController?.pushViewController(loginVC, animated: true)
        }
}


extension UITextField {
    func setLeftPaddingPoints(_ amount:CGFloat){
        let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: amount, height: self.frame.height))
        self.leftView = paddingView
        self.leftViewMode = .always
    }
}
