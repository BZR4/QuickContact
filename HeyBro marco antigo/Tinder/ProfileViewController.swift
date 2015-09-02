//
//  ProfileViewController.swift
//  Tinder
//
//  Created by Marco on 8/24/15.
//  Copyright (c) 2015 Marco. All rights reserved.
//

import UIKit

class ProfileViewController: UIViewController, ProfileTableViewControllerDelegate {

    var parseModel = ParseModel.singleton
    var profile    = ProfileModel.singleton
    
    var tableViewHasChanges = false
    
    // função que pertence ao protocolo ProfileTableViewControllerDelegate e deve
    // ser implementada
    func didUpdate (isUpdated : Bool, data: ProfileModel) {
        self.tableViewHasChanges = isUpdated
        
        self.profile = data
    }
    
    override func touchesBegan (touches: Set <NSObject>, withEvent event: UIEvent) {
        
        // pára de editar, o que significa que o teclado desaparece
        self.view.endEditing (true)
        
        // pára de editar, o que significa que o teclado desaparece
        //self.view.endEditing (true)
        
        super.touchesBegan(touches, withEvent: event)
    }

    override func viewWillAppear(animated: Bool) {
        
        // muda o título da tela de navigation
        navigationItem.title = "Profile"
        let titleDict: NSDictionary = [NSForegroundColorAttributeName: UIColor.whiteColor()]
        self.navigationController!.navigationBar.titleTextAttributes = titleDict as [NSObject : AnyObject]
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
    
    // código a ser executado quando é pressionado o botão Back
    override func willMoveToParentViewController (parent: UIViewController?) {
        super.willMoveToParentViewController (parent)
        
        if parent == nil {
            // não tem pai quando o botão Back for pressionado
            // é hora de salvar os dados

            self.view.endEditing (true)
            
            // antes de voltar, salva de forma assíncrona os dados no Parse
            
            if tableViewHasChanges == true {
                // salva no Parse as alterações
                
                parseModel.saveProfileWeb (profile) {
                    
                    (result : Bool, error: NSError?) -> Void in
                    
                    if result == false {
                        println ("erro ao salvar os dados na web")
                    }
                }
            }
        } else {
            // caso queira colocar algum código quando está entrando
            // na view
        }
    }
    
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
