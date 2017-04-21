//
//  LoginViewController.swift
//  IoTApp
//
//  Created by Viraj Padte on 4/20/17.
//  Copyright © 2017 VirajPadte. All rights reserved.
//

import UIKit
import LocalAuthentication

class LoginViewController: UIViewController {
    
    @IBOutlet weak var passwordTextInput: UITextField!
    @IBOutlet weak var userTextInput: UITextField!

    override func viewDidLoad() {
        super.viewDidLoad()
        //authenticateUser()

        // Do any additional setup after loading the view.
        
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.isNavigationBarHidden = true
    }
    
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.view.endEditing(true)
        return true
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }

    
    
    
    func displayErrorMessage(error:LAError) {
        var message = ""
        switch error.code {
        case LAError.authenticationFailed:
            message = "Authentication was not successful because the user failed to provide valid credentials."
            break
        case LAError.userCancel:
            //message = "Authentication was canceled by the user"
            message = ""
            userTextInput.becomeFirstResponder()
            break
        case LAError.userFallback:
            //message = "Authentication was canceled because the user tapped the fallback button"
            message = ""
            userTextInput.becomeFirstResponder()
            break
        case LAError.touchIDNotEnrolled:
            message = "Authentication could not start because Touch ID has no enrolled fingers."
        case LAError.passcodeNotSet:
            message = "Passcode is not set on the device."
            break
        case LAError.systemCancel:
            message = "Authentication was canceled by system"
            break
        default:
            message = error.localizedDescription
        }
        
        self.showAlertWith(title: "Authentication Failed", message: message)
    }
    
    
    func showAlertWith(title:String, message:String) {
        if (message != ""){
            let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
            let actionButton = UIAlertAction(title: "OK", style: .default, handler: nil)
            alertController.addAction(actionButton)
            self.present(alertController, animated: true, completion: nil)
        }
    }
    
    @IBAction func attemptedLogin(_ sender: Any) {
        print("attempted login")
        if (userTextInput.text == "virajrp" && passwordTextInput.text == "virajrp"){
            performSegue(withIdentifier: "toRegions", sender: nil)
        }
        else{
            print("sorry cant login.. invalid credentials")
        }
        
    }
    
    
    func authenticateUser(){
        //overlay the subview gray + the alert
        let context = LAContext()
        
        // Declare a NSError variable.
        var errorPointer: NSError?
        
        // Set the reason string that will appear on the authentication alert.
        let reasonString = "Only awesome people are allowed"
        
        if context.canEvaluatePolicy(LAPolicy.deviceOwnerAuthenticationWithBiometrics, error: &errorPointer) {
            context.evaluatePolicy(LAPolicy.deviceOwnerAuthenticationWithBiometrics, localizedReason: reasonString, reply: { (success, evalPolicyError) in
                if success{
                    DispatchQueue.main.async {
                        print("Authentication was successful")
                        self.performSegue(withIdentifier: "toRegions", sender: nil)
                    }
                }
                else{
                    //remove the view and just let the use authenticate via the text login method
                    DispatchQueue.main.async {
                        print("Authentication was not sucessfull")
                        self.displayErrorMessage(error: evalPolicyError as! LAError)
                        
                    }
                }
            })
            
        }
        else{
            //cant authenticate on this device using touch ID
            self.showAlertWith(title: "Error", message: (errorPointer?.localizedDescription)!)
            
        }
    }
    
    
    
}
