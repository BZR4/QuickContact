//
//  ProfileTableTableViewController.swift
//  Tinder
//
//  Created by Marco on 8/26/15.
//  Copyright (c) 2015 Marco. All rights reserved.
//

import UIKit

class ProfileTableViewController: UITableViewController, UITextFieldDelegate {
    
    @IBOutlet weak var switchPhone: UISwitch!
    
    @IBOutlet weak var switchFacebook: UISwitch!
    
    @IBOutlet weak var switchEmail: UISwitch!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

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

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
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

    // ocorre quando a pessoa clica na tela
    // serve para tirar o teclado e não atrapalhar a UX
    // NÃO FUNCIONA!!!! ???????????????? Talvez tenha que extender a classe
    override func touchesBegan (touches: Set <NSObject>, withEvent event: UIEvent) {
        
        // pára de editar, o que significa que o teclado desaparece
        self.view.endEditing (true)
    }
    
    // called when 'return' key pressed. return NO to ignore.
    // é chamado quando o user aperta o botão <enter> do teclado do app
    func textFieldShouldReturn (textField: UITextField) -> Bool {
        
//        // muda o foco da caixa de texto de acordo com a que está selecionado
//        if textUser.isFirstResponder () == true {
//            textPassword.becomeFirstResponder ()
//        } else if textPassword.isFirstResponder () == true {
//            self.view.endEditing (true)
//        }
        
        self.view.endEditing (true)
        
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

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using [segue destinationViewController].
        // Pass the selected object to the new view controller.
    }
    */

}
