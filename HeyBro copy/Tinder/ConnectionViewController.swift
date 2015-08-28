//
//  MainViewController.swift
//  Tinder
//
//  Created by Marco on 8/24/15.
//  Copyright (c) 2015 Marco. All rights reserved.
//

import UIKit

class ConnectionViewController: UIViewController {
    
    // variável para controlar a 1a execução do programa
    var firstRun = false
    
    override func viewWillAppear (animated: Bool) {
        super.viewWillAppear (animated)
        
        if firstRun == true {
            
            // seta para falso para que ao entrar nessa view novamente, não vá direto
            // para a view connection novamente
            firstRun = false
            
            self.performSegueWithIdentifier ("segueConnectionToProfile", sender: nil)
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
