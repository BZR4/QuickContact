//
//  MainViewController.swift
//  Tinder
//
//  Created by Marco on 8/24/15.
//  Copyright (c) 2015 Marco. All rights reserved.
//

import UIKit

class ConnectionViewController: UIViewController , ABPeoplePickerNavigationControllerDelegate, ABPersonViewControllerDelegate{
    
    // variável para controlar a 1a execução do programa
    var firstRun = false
    
    var contacts: Contacts = Contacts()
    
    override func viewWillAppear (animated: Bool) {
        super.viewWillAppear (animated)
        
        if firstRun == true {
            
            // seta para falso para que ao entrar nessa view novamente, não vá direto
            // para a view connection novamente
            firstRun = false
            
            performSegueWithIdentifier ("segueConnectionToProfile", sender: nil)
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
    
    @IBAction func goToContact(sender: AnyObject) {
        
        self.showPeoplePickerController()
    }
    
    
    func showPeoplePickerController(){
        
        var picker: ABPeoplePickerNavigationController = ABPeoplePickerNavigationController()
        
        picker.peoplePickerDelegate = self
        
        //here go into Contacts method showPeoplePickerController
        self.contacts.showPeoplePickerController(picker)
        
        self.presentViewController(picker, animated: true, completion: nil)
    }
    
    //Mark:  Display and edit a person
    // Called when users tap "Display and Edit Contact" in the application. Searches for a contact named "Appleseed" in
    // in the address book. Displays and allows editing of all information associated with that contact if
    // the search is successful. Shows an alert, otherwise.
    func showPersonViewController(person: ABRecordRef ){
        
        var picker : ABPersonViewController = ABPersonViewController()
        
        picker.personViewDelegate = self
        
        picker.displayedPerson = person;
        
        self.contacts.atributes(picker)
        
        self.navigationController?.pushViewController(picker, animated: true)
    }
    
    //Mark: ABPeoplePickerNavigationControllerDelegate methods
    // Dismisses the people picker and shows the application when users tap Cancel.
    func peoplePickerNavigationControllerDidCancel(peoplePicker: ABPeoplePickerNavigationController!){
        
        self.navigationController?.popViewControllerAnimated(true)
        
    }
    
    // Does not allow users to perform default actions such as dialing a phone number, when they select a person property.
    func peoplePickerNavigationController(peoplePicker: ABPeoplePickerNavigationController!, shouldContinueAfterSelectingPerson person: ABRecordRef!) -> Bool {
        
        self.navigationController?.popViewControllerAnimated(true)
        
        return false
    }
    
    // Displays the information of a selected person
    func peoplePickerNavigationController(peoplePicker: ABPeoplePickerNavigationController!,
        didSelectPerson person: ABRecordRef!){
            self.showPersonViewController(person)
    }
    
    
    
    //Mark:  ABPersonViewControllerDelegate methods
    // Does not allow users to perform default actions such as dialing a phone number, when they select a contact property.
    func personViewController(personViewController: ABPersonViewController!, shouldPerformDefaultActionForPerson person: ABRecord!, property: ABPropertyID, identifier: ABMultiValueIdentifier) -> Bool {
        return true
    }
    

}
