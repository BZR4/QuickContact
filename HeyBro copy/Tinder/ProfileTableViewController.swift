//
//  ProfileTableTableViewController.swift
//  Tinder
//
//  Created by Marco on 8/26/15.
//  Copyright (c) 2015 Marco. All rights reserved.
//

import UIKit

// protocolo para a view escutar eventos que ocorrem dentro do container
// sem isso ela não pega os eventos. note que existe uma segue associada
// também ao container quando ele é criado
protocol ProfileTableViewControllerDelegate {
    func didUpdate (isUpdated : Bool, data: ProfileModel)
}

class ProfileTableViewController: UITableViewController, UITextFieldDelegate {

    var profile = ProfileModel.singleton
    
    // é optional pois pode ocorrer se ninguém quiser implementá-lo
    var delegate: ProfileTableViewControllerDelegate?
    
    @IBOutlet weak var textName:      UITextField!
    @IBOutlet weak var textPhone:     UITextField!
    @IBOutlet weak var textFacebook:  UITextField!
    @IBOutlet weak var textEmail:     UITextField!
    @IBOutlet weak var textExtraInfo: UITextField!
    
    @IBOutlet weak var switchPhone:    UISwitch!
    @IBOutlet weak var switchFacebook: UISwitch!
    @IBOutlet weak var switchEmail:    UISwitch!
    
    @IBOutlet weak var labelError: UILabel!

    // função que é chamada quando um textfield é modificado
    // tá ruim por enquanto pois detecta todo caractere. só precisaria chamar quando ele aperta enter ou
    // dá tap no celular
    func profileUpdated () {
        
        // caso exista o delegate (por isso o ?), retorna o status informando que existe uma
        // atualização
        
        profile.name      = textName.text
        profile.phone     = textPhone.text
        profile.facebook  = textFacebook.text
        profile.email     = textEmail.text
        profile.extraInfo = textExtraInfo.text
    
        profile.phoneShare    = switchPhone.on
        profile.facebookShare = switchFacebook.on
        profile.emailShare    = switchEmail.on
        
        delegate?.didUpdate (true, data: profile)
    }

    override func touchesBegan (touches: Set <NSObject>, withEvent event: UIEvent) {
        
        // pára de editar, o que significa que o teclado desaparece
        self.view.endEditing (true)
        
        // pára de editar, o que significa que o teclado desaparece
        //self.view.endEditing (true)
        
        super.touchesBegan(touches, withEvent: event)
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        textName.addTarget      (self, action: "profileUpdated", forControlEvents: UIControlEvents.EditingDidEnd)
        textPhone.addTarget     (self, action: "profileUpdated", forControlEvents: UIControlEvents.EditingDidEnd)
        textFacebook.addTarget  (self, action: "profileUpdated", forControlEvents: UIControlEvents.EditingDidEnd)
        textEmail.addTarget     (self, action: "profileUpdated", forControlEvents: UIControlEvents.EditingDidEnd)
        textExtraInfo.addTarget (self, action: "profileUpdated", forControlEvents: UIControlEvents.EditingDidEnd)
        
        switchPhone.addTarget    (self, action: "profileUpdated", forControlEvents: UIControlEvents.ValueChanged)
        switchFacebook.addTarget (self, action: "profileUpdated", forControlEvents: UIControlEvents.ValueChanged)
        switchEmail.addTarget    (self, action: "profileUpdated", forControlEvents: UIControlEvents.ValueChanged)
        
        
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Potentially incomplete method implementation.
        // Return the number of sections.
        return 5
    }

    override func tableView (tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete method implementation.
        // Return the number of rows in the section.
        
        var numberOfSections = 1
        
        switch section {
            case 0:  numberOfSections = 1
            case 1:  numberOfSections = 2
            case 2:  numberOfSections = 2
            case 3:  numberOfSections = 2
            case 4:  numberOfSections = 1
            
            default: numberOfSections = 1
        }
        
        return numberOfSections
    }

    // called when 'return' key pressed. return NO to ignore.
    // é chamado quando o user aperta o botão <enter> do teclado do app
    func textFieldShouldReturn (textField: UITextField) -> Bool {
  
        if textName.text == "" {
            textName.becomeFirstResponder ()
        } else if textPhone.text == "" {
            textPhone.becomeFirstResponder ()
        } else if textFacebook.text == "" {
            textFacebook.becomeFirstResponder ()
        } else if textEmail.text == "" {
            textEmail.becomeFirstResponder ()
        } else {
            self.view.endEditing (true)
        }
        
        return true
    }
    
    /*
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("reuseIdentifier", forIndexPath: indexPath) as! UITableViewCell

        // Configure the cell...

        return cell
    }
    */

    /*
    // Override to support conditional editing of the table view.
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return NO if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            // Delete the row from the data source
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
        } else if editingStyle == .Insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(tableView: UITableView, moveRowAtIndexPath fromIndexPath: NSIndexPath, toIndexPath: NSIndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(tableView: UITableView, canMoveRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return NO if you do not want the item to be re-orderable.
        return true
    }
    */

}
