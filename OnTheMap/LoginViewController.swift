//
//  LoginViewController.swift
//  OnTheMap
//
//  Created by Boris Alexis Gonzalez Macias on 7/8/15.
//  Copyright (c) 2015 PropiedadFacil. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController, UITextFieldDelegate {
    
    var session: NSURLSession!
    @IBOutlet weak var usernameField: UITextField!
    @IBOutlet weak var passwordField: UITextField!
    @IBOutlet weak var errorLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        session = NSURLSession.sharedSession()
        self.usernameField.delegate = self
        self.passwordField.delegate = self
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func sendButton(sender: UIButton) {
        UIApplication.sharedApplication().networkActivityIndicatorVisible = true
        UdacityClient.login(usernameField.text!,password: passwordField.text!){ (success, jsonData) in
            if(success){
                self.finishLogin(jsonData)
            }else {
                UIApplication.sharedApplication().networkActivityIndicatorVisible = false
                let errorText = jsonData["error"] as! String
                Shared.showError(self, errorString: errorText)
            }
        }
    }
    
    @IBAction func signUp(sender: UIButton) {
        UdacityClient.showSignUp()
    }
    
// Storing the SessionID
    func finishLogin(data : [String:AnyObject?]){
        dispatch_async(dispatch_get_main_queue(), {
            var appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
            let account = data["account"] as! [String:AnyObject]
            let accountKey = account["key"] as! String
            appDelegate.accountKey = accountKey
            UdacityClient.getPublicData(accountKey, completionHandler: {(success,data) in
                UIApplication.sharedApplication().networkActivityIndicatorVisible = false
                if(success){
                    let user = data["user"] as! [String:AnyObject]
                    appDelegate.firstName = user["first_name"] as! String
                    appDelegate.lastName = user["last_name"] as! String
                    self.dismissViewControllerAnimated(true, completion: nil)
                }
                else{
                    Shared.showError(self, errorString: data["ErrorString"] as! String)
                }
            })
        })
    }
    
    // Getting rid of keyboard after hitting return
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        self.view.endEditing(true)
        return false
    }
    
    // Getting rid of keyboard after touching outside inputs
    override func touchesBegan(touches: Set<NSObject>, withEvent event: UIEvent?){
        view.endEditing(true)
        super.touchesBegan(touches, withEvent: event!)
    }
    
}

