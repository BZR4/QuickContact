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
            
          performSegueWithIdentifier ("segueConnectionToProfile", sender: nil)
            
            
            
            
//            if segue.identifier == "segueLoginToConnection" && firstRun == true {
//                let destination = segue.destinationViewController as! UINavigationController
//                
//                let targetDestination = destination.topViewController as! ConnectionViewController
//                
//                // envia para o view controller seguinte a informação de que é a 1a execução
//                targetDestination.firstRun = true
//            }

            
            
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
