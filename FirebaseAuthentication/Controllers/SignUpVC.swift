//
//  SignUpVC.swift
//  FirebaseAuthentication
//
//  Created by Neha Penkalkar on 02/05/21.
//

import UIKit
import FirebaseAuth
import Firebase
import FirebaseDatabase

class SignUpVC: UIViewController {
    
    @IBOutlet weak var firstNameTextF: UITextField!
    @IBOutlet weak var secondNameTextF: UITextField!
    @IBOutlet weak var emailTextF: UITextField!
    @IBOutlet weak var passTextF: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
    }
    
    @IBAction func backPressed(_ sender: UIButton) {
        
        let vc = storyboard?.instantiateViewController(withIdentifier: "LoginVC") as! LoginVC
        navigationController?.pushViewController(vc, animated: true)
    }
    
    @IBAction func signUpPressed(_ sender: UIButton) {
        
        //VALIDATE FIELDS
        let error = validateFields()
        if error != nil{
            showErr(msg: error!)
            
        }else{
            
            //CREATE CLEANED VERSION OF DATA
            let firstName = firstNameTextF.text!.trimmingCharacters(in: .whitespacesAndNewlines)
            let lastName = secondNameTextF.text!.trimmingCharacters(in: .whitespacesAndNewlines)
            let email = emailTextF.text!.trimmingCharacters(in: .whitespacesAndNewlines)
            let password = passTextF.text!.trimmingCharacters(in: .whitespacesAndNewlines)
            
            //CREATE THE USER
            Auth.auth().createUser(withEmail: email, password: password) { (result , err) in
                // check for error
                if err != nil {
                    
                    self.showErr(msg: "Error Creating User")
                }
                
                //User was created, store the first name and last name
                let ref = Database.database().reference(fromURL: "https://fir-rtdb-3b4f6-default-rtdb.asia-southeast1.firebasedatabase.app/") //paste your real time database url here
                let usersReference = ref.child("users").child(result!.user.uid)
                let values = ["firstName":firstName, "lastname": lastName]
                print(values)
                usersReference.updateChildValues(values, withCompletionBlock: { (err,ref) in
                    
                    if  err != nil {
                        self.showErr(msg: "Failed to add User!!")
                    }
                    
                    let vc = self.storyboard?.instantiateViewController(withIdentifier: "LoginVC") as! LoginVC
                    self.navigationController?.pushViewController(vc, animated: true)
                })
            }
        }
    }
    
    func showErr(msg: String){
        let alert = UIAlertController(title: "", message: "", preferredStyle: .actionSheet)
        let titleAttributes = [NSAttributedString.Key.font: UIFont(name: "HelveticaNeue-Bold", size: 18)!, NSAttributedString.Key.foregroundColor: UIColor.black]
        let titleString = NSAttributedString(string: "\(msg)", attributes: titleAttributes)
        alert.setValue(titleString, forKey: "attributedTitle")
        
        let dismiss = UIAlertAction(title: "Dismiss", style: .destructive, handler: nil)
        alert.addAction(dismiss)
        self.present(alert, animated: true, completion: nil)
    }
    
    
//MARK:- Field Validation
    func validateFields() -> String? {
        
        if firstNameTextF.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" || secondNameTextF.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" ||
            emailTextF.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" ||
            passTextF.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" {
            
            return "Please fill in all fields"
            
        }
        
        //Check if the email is correct
        let cleanEmail = emailTextF.text!.trimmingCharacters(in: .whitespacesAndNewlines)
        if isValidEmail(cleanEmail) == false{
            
            return "Make sure you've entered email in correct format"
            
        }
        
        //Check if the password is secure
        let cleanPass = passTextF.text!.trimmingCharacters(in: .whitespacesAndNewlines)
        if isPasswordValid(cleanPass) == false{
            
            return "Please make sure your password is at least 8 characters, contains a special character and a number"
            
        }
        return nil
    }
    
    func isPasswordValid(_ password : String) -> Bool{
        
        let passwordTest = NSPredicate(format: "SELF MATCHES %@", "^(?=.*[a-z])(?=.*[$@$#!%*?&])[A-Za-z\\d$@$#!%*?&]{8,}")
        return passwordTest.evaluate(with: password)
    }
    
    func isValidEmail(_ email: String) -> Bool {
        
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        
        let emailPred = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailPred.evaluate(with: email)
    }
}
