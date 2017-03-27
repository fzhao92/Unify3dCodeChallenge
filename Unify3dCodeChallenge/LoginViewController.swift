//
//  LoginViewController.swift
//  Unify3dCodeChallenge
//
//  Created by Forrest Zhao on 3/26/17.
//  Copyright © 2017 Forrest Zhao. All rights reserved.
//

import UIKit
import KeychainSwift

class LoginViewController: UIViewController {

    @IBOutlet weak var usernameTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func login(_ sender: Any) {
        if (usernameTextField.text?.characters.count)! > 0 && (passwordTextField.text?.characters.count)! > 0 {
            let keychain = KeychainSwift()
            let password = keychain.set(passwordTextField.text!, forKey: usernameTextField.text!)
            
        }
    }
    
    func setupView() {
        passwordTextField.isSecureTextEntry = true
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
