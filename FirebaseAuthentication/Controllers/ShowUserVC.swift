//
//  ShowUserVC.swift
//  FirebaseAuthentication
//
//  Created by Neha Penkalkar on 03/05/21.
//

import UIKit
import FirebaseDatabase
import Firebase

class ShowUserVC: UIViewController{
    
    @IBOutlet weak var userTV: UITableView!
    var ref: DatabaseReference?
    var userData = [userValue]()
    
    @IBOutlet weak var showNameLbl: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        userTV.delegate = self
        userTV.dataSource = self
        
        fireRef()
        ifUserIsLoggedCheck()
    }
    
    func fireRef(){
        
        //Set firebase reference
        ref = Database.database().reference().child("users")
        ref?.observe(.childAdded, with: { [weak self] (snapshot) in
            let key = snapshot.key
            guard let value = snapshot.value as? [String : Any] else { return }
            if let Fname = value["firstName"] as? String, let Lname = value["lastname"] as? String{
                let myUser = userValue(id: key, firstName: Fname, lastname: Lname)
                self?.userData.append(myUser)
                self?.userTV.reloadData()
            }
        })
    }
    
    func ifUserIsLoggedCheck(){
        if Auth.auth().currentUser?.uid == nil{
            logout()
        }else{
            let uid = Auth.auth().currentUser?.uid
            Database.database().reference().child("users").child(uid!).observe(.value) { [weak self] (snapshot) in
                if let value = snapshot.value as? [String : Any]{
                    self?.showNameLbl.text = "Hello \(value["firstName"]  as? String ?? "") \(value["lastName"]  as? String ?? "")"
                }
            }
        }
    }
    
    func logout(){
        do{
            try Auth.auth().signOut()
        }catch let err{
            print(err)
        }
    }
    
    @IBAction func logoutPress(_ sender: CustomButton) {
        logout()
        let vc = storyboard?.instantiateViewController(withIdentifier: "LoginVC") as! LoginVC
        navigationController?.pushViewController(vc, animated: true)
    }
}


//MARK:- Table View
extension ShowUserVC: UITableViewDelegate, UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        userData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "UserTVC") as! UserTVC
        let demo = userData[indexPath.row]
        cell.nameLbl.text = "\(demo.firstName) \(demo.lastname)"
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 0.1
    }
}
