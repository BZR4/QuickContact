//
//  ProfileViewController.swift
//  Tinder
//
//  Created by Marco on 8/24/15.
//  Copyright (c) 2015 Marco. All rights reserved.
//

import UIKit

class ProfileViewController: UIViewController, ProfileTableViewControllerDelegate {

    var parseModel   = ParseModel.singleton
    var profile      = ProfileModel.singleton
    
    
    var tableViewHasChanges = false
    
    // função que pertence ao protocolo ProfileTableViewControllerDelegate e deve
    // ser implementada
    func didUpdate (isUpdated : Bool, data: ProfileModel) {
        self.tableViewHasChanges = isUpdated
        
        self.profile = data
        println("Profile is \(profile.name)")
    }
    
    override func touchesBegan (touches: Set <NSObject>, withEvent event: UIEvent) {
        
        // pára de editar, o que significa que o teclado desaparece
        self.view.endEditing (true)
        
        // pára de editar, o que significa que o teclado desaparece
        //self.view.endEditing (true)
        
        super.touchesBegan(touches, withEvent: event)
    }

    @IBAction func buttonBack (sender: AnyObject) {
        
        self.view.endEditing(true)

        println ("atualizando = \(tableViewHasChanges)")
        
        println (profile.name)
        println("Profile back is \(profile.name)")
        
        // antes de voltar, salva de forma assíncrona os dados no Parse
        
        if tableViewHasChanges == true {
            // salva no Parse as alterações
            
            parseModel.saveProfileWeb (profile) {
    
                (result : Bool, error: NSError?) -> Void in
                
                println ("resultado = \(result)")
                
            }
        }
        
        dismissViewControllerAnimated (false, completion: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "segueCreateContainer" {
            let destination = segue.destinationViewController as! ProfileTableViewController
            
            destination.delegate = self
            
            destination.profile = self.profile
        }
    }

    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
