//
//  LoginVC.swift
//  FirebaseAuthentication
//
//  Created by Neha Penkalkar on 02/05/21.
//

import UIKit
import FirebaseAuth
import Firebase
import Lottie

class LoginVC: UIViewController {
    @IBOutlet weak var enterEmailTextF: UITextField!
    @IBOutlet weak var enterPassTextF: UITextField!
    
    @IBOutlet weak var animationView: AnimationView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        animationView.loopMode = .loop
        animationView.play()
        ifUserIsLoggedCheck()
    }
    
    func ifUserIsLoggedCheck(){
        if Auth.auth().currentUser?.uid == nil{
            logout()
        }else{
            let vc = storyboard?.instantiateViewController(withIdentifier: "ShowUserVC") as! ShowUserVC
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
    
    func logout(){
        do{
            try Auth.auth().signOut()
        }catch let err{
            print(err)
        }
    }
    
    
    @IBAction func loginPressed(_ sender: UIButton) {
        
        //validate fields
        let error = validateFields()
        if error != nil{
            showErr(msg: error!)
        }
        else{
            
            let email = enterEmailTextF.text!.trimmingCharacters(in: .whitespacesAndNewlines)
            let password = enterPassTextF.text!.trimmingCharacters(in: .whitespacesAndNewlines)
            
            //SignIn user
            Auth.auth().signIn(withEmail: email, password: password) { (result , error) in
                if error != nil{
                    
                    self.showErr(msg: "\(error?.localizedDescription ?? "Wrong Password or Email")")
                }
                
                else{
                    
                    let vc = self.storyboard?.instantiateViewController(withIdentifier: "ShowUserVC") as! ShowUserVC
                    self.navigationController?.pushViewController(vc, animated: true)
                }
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
    
    
    //MARK:- Validation of fields
    func validateFields() -> String? {
        
        if enterEmailTextF.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" ||
            enterPassTextF.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" {
            
            return "Please fill in all fields."
        }
        
        //Check if the email is correct
        let cleanEmail = enterEmailTextF.text!.trimmingCharacters(in: .whitespacesAndNewlines)
        if isValidEmail(cleanEmail) == false{

            return "Something is wrong!! Make sure you've enter correct Email address."
        }
        
        //Check if the password is secure
        let cleanPass = enterPassTextF.text!.trimmingCharacters(in: .whitespacesAndNewlines)
        if isPasswordValid(cleanPass) == false{
            
            return "Something is wrong!! Make sure you've enter correct password."
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
