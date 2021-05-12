//
//  ForgetPassVC.swift
//  FirebaseAuthentication
//
//  Created by Neha Penkalkar on 04/05/21.
//

import UIKit
import Firebase

class ForgetPassVC: UIViewController {
    @IBOutlet weak var emailTF: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
    }
    
    @IBAction func forgotBackPress(_ sender: Any) {
        let vc = storyboard?.instantiateViewController(withIdentifier: "LoginVC") as! LoginVC
        navigationController?.pushViewController(vc, animated: true)
    }
    
    @IBAction func sendPress(_ sender: UIButton) {
        let auth = Auth.auth()
        auth.sendPasswordReset(withEmail: emailTF.text!) { (error) in
            if let error = error {
                self.showErr(msg: "\(error.localizedDescription)")
                return
            }
            let alert = UIAlertController(title: "", message: "", preferredStyle: .actionSheet)
            
            let titleAttributes = [NSAttributedString.Key.font: UIFont(name: "HelveticaNeue-Bold", size: 18)!, NSAttributedString.Key.foregroundColor: UIColor.black]
            let msgAttributes = [NSAttributedString.Key.font: UIFont(name: "HelveticaNeue", size: 16)!, NSAttributedString.Key.foregroundColor: UIColor.black]
            
            let titleString = NSAttributedString(string: "Email Sent", attributes: titleAttributes)
            let msgString = NSAttributedString(string: "Change your password and try to login again", attributes: msgAttributes)
            
            alert.setValue(titleString, forKey: "attributedTitle")
            alert.setValue(msgString, forKey: "attributedMessage")
            
            let okAction = UIAlertAction(title: "OK", style: .default) { alert in
                let vc = self.storyboard?.instantiateViewController(withIdentifier: "LoginVC") as! LoginVC
                self.navigationController?.pushViewController(vc, animated: true)
            }
            
            alert.addAction(okAction)
            self.present(alert, animated: true, completion: nil)
        }
    }
    
    
    func showErr(msg: String){
        
        let alert = UIAlertController(title: "", message: "", preferredStyle: .actionSheet)
        
        let titleAttributes = [NSAttributedString.Key.font: UIFont(name: "HelveticaNeue-Bold", size: 18)!, NSAttributedString.Key.foregroundColor: UIColor.black]
        let titleString = NSAttributedString(string: "\(msg)", attributes: titleAttributes)
        alert.setValue(titleString, forKey: "attributedTitle")
        
        let ok = UIAlertAction(title: "OK", style: .cancel)
        alert.addAction(ok)
        self.present(alert, animated: true, completion: nil)
    }
}
