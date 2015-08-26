//
//  ViewController.swift
//  Tinder
//
//  Created by Marco Linhares on 8/22/15.
//  Copyright (c) 2015 Marco. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        var push = PFPush ()
        
        push.setMessage ("This is a test")

        push.sendPushInBackgroundWithBlock () {
            (success: Bool , error: NSError?) -> Void in
            
            if success == true {
                println ("The push campaign has been created.");
            } else if error!.code == 112 {
                println ("Could not send push. Push is misconfigured: \(error!.description).");
            } else {
                println("Error sending push: \(error!.description).");
            }
            
            
            
            
            
        }
        
        
        
        // permissões que serão pedidas pro Facebook
        var permissions = ["public_profile"]
        // outras permissões simples: "email", "likes"
        
        PFFacebookUtils.logInInBackgroundWithReadPermissions(permissions) {
            (user: PFUser?, error: NSError?) -> Void in

            if let user = user {
                if user.isNew {
                    println("User signed up and logged in through Facebook!")
                } else {
                    println("User logged in through Facebook!")
                }
            } else {
                println("Uh oh. The user cancelled the Facebook login.")
            }
        }
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    
    

}

