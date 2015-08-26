//
//  ProfileViewController.swift
//  Tinder
//
//  Created by Marco on 8/24/15.
//  Copyright (c) 2015 Marco. All rights reserved.
//

import UIKit

class ProfileViewController: UIViewController {

    @IBAction func buttonBack (sender: AnyObject) {
        dismissViewControllerAnimated (false, completion: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        
    }

    override func touchesBegan(touches: Set<NSObject>, withEvent event: UIEvent) {
        println("Aqui!!!")
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
