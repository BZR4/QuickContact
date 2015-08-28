//
//  PeripheralViewController.swift
//  Quick Contacts
//
//  Created by Esdras Bezerra da Silva on 25/08/15.
//  Copyright (c) 2015 Esdras Bezerra da Silva. All rights reserved.
//

import UIKit
import CoreBluetooth

class PeripheralViewController: UIViewController, CBPeripheralManagerDelegate, UITextViewDelegate {
    
    let TRANSFER_SERVICE_UUID = "E20A39F4-73F5-4BC4-A12F-17D1AD07A961"
    let TRANSFER_CHARACTERISTIC_UUID = "08590F7E-DB05-467E-8757-72F6FAEB13D4"
    
    var profile = ProfileModel.singleton
    
    //  Mark: - Properties and Outlets
    @IBOutlet weak var textView: UITextView!
    @IBOutlet weak var advertisingSwitch: UISwitch!
    var peripheralManager: CBPeripheralManager!
    var transferCharacteristic: CBMutableCharacteristic!
    var dataToSend: NSData!
    var sendDataIndex: NSInteger!
    
    let NOTIFY_MTU = 20
    
    
    var swipeRecognizer: UISwipeGestureRecognizer!
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        swipeRecognizer = UISwipeGestureRecognizer(target: self, action: Selector("handleSwipes:"))
    }
    
    
    // MARK: - Life Cicle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Iniciar o peripheralManager
        self.peripheralManager = CBPeripheralManager(delegate: self, queue: nil)
        self.advertisingSwitch.setOn(false, animated: true)
        
        
        self.swipeRecognizer.numberOfTouchesRequired = 1
        
        self.swipeRecognizer.direction = .Up
        
        view.addGestureRecognizer(swipeRecognizer)
        
        
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        // Don't keep it going while we're not showing.
        self.peripheralManager?.stopAdvertising()
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //  Mark: - Swipe Methods
    func handleSwipes(sender: UISwipeGestureRecognizer){
        if sender.direction == .Down {
            println("Swipe Down")
        }
        if sender.direction == .Left {
            println("Swipe Left")
        }
        if sender.direction == .Up {
            println("Swipe Up")
            
            

        }
        if sender.direction == .Right {
            println("Swipe Right")
        }
        
        self.peripheralManager.startAdvertising(
            [ CBAdvertisementDataServiceUUIDsKey : [CBUUID(string:TRANSFER_SERVICE_UUID)] ])
    }
    
    
    //  Mark: - Peripheral Methods
    /** Required protocol method.  A full app should take care of all the possible states,
    *  but we're just waiting for  to know when the CBPeripheralManager is ready
    */
    
    func peripheralManagerDidUpdateState(peripheral: CBPeripheralManager!) {
        
        if (peripheral.state != CBPeripheralManagerState.PoweredOn){
            return
        }
        
        // We're in CBPeripheralManagerStatePoweredOn state...
        println("self.peripheralManager powered on.")
        
        // Start with the CBMutableCharacteristic
        self.transferCharacteristic = CBMutableCharacteristic(type: CBUUID(string: TRANSFER_CHARACTERISTIC_UUID), properties: CBCharacteristicProperties.Notify, value: nil, permissions: CBAttributePermissions.Readable)
        
        //Then the service
        var tranferService = CBMutableService(type: CBUUID(string: TRANSFER_SERVICE_UUID), primary: true)
        
        // Add the characteristic to the service
        tranferService.characteristics = [self.transferCharacteristic]
        
        // And add it to the peripheral manager
        self.peripheralManager!.addService(tranferService)
    }
    
    /** Catch when someone subscribes to our characteristic, then start sending them data
    */
    
    func peripheralManager(peripheral: CBPeripheralManager!, central: CBCentral!, didSubscribeToCharacteristic characteristic: CBCharacteristic!) {
        println("Central subscribed to characteristic")
        
        //Get the data
        
        
        
        //  Verificar com Gustavo
        
        //  Dados oriundos do TextView
        //        self.dataToSend = (self.textView.text)!.dataUsingEncoding(NSUTF8StringEncoding)
        
        
        //Teste com nova String
        self.dataToSend = ("Esdras\nBezerra da Silva\nbzr4@icloud.com\nhttp://www.facebook.com/esdrasilva").dataUsingEncoding(NSUTF8StringEncoding, allowLossyConversion: true)
        
        // Reset the index
        self.sendDataIndex = 0;
        
        // Start sending
        self.sendData()
        
    }
    
    /** Recognise when the central unsubscribes
    */
    
    func peripheralManager(peripheral: CBPeripheralManager!, central: CBCentral!, didUnsubscribeFromCharacteristic characteristic: CBCharacteristic!) {
        println("Central unsubscribed from characteristic")
    }
    
    
    /** Sends the next amount of data to the connected central
    */
    
    var sendingEOM = false
    
    func sendData(){
        
        // First up, check if we're meant to be sending an EOM
        
        if (sendingEOM) {
            
            //  Send It
            
            //  Verificar Urgente
            //var didSend = self.peripheralManager.updateValue(NSString(data: "EOM", encoding: NSUTF8StringEncoding), forCharacteristic: self.transferCharacteristic, onSubscribedCentrals: nil)
            
            
            let didSend: Bool = self.peripheralManager.updateValue("EOM".dataUsingEncoding(NSUTF8StringEncoding, allowLossyConversion: true), forCharacteristic: self.transferCharacteristic, onSubscribedCentrals: nil)
            
            //  Did Send?
            if(didSend){
                
                // It did, so mark it as sent
                sendingEOM = false
                
                println("Sent: EOM")
            }
            
            // It didn't send, so we'll exit and wait for peripheralManagerIsReadyToUpdateSubscribers to call sendData again
            return
        }
        
        
        
        // We're not sending an EOM, so we're sending data
        // Is there any left to send?
        
        if (self.sendDataIndex >= self.dataToSend.length) {
            
            // No data left.  Do nothing
            return
        }
        
        // There's data left, so send until the callback fails, or we're done.
        
        var didSend: Bool = true
        
        while(didSend){
            
            // Make the next chunk
            
            // Work out how big it should be
            var amountToSend: NSInteger = self.dataToSend.length - self.sendDataIndex
            
            // Can't be longer than 20 bytes
            if (amountToSend > NOTIFY_MTU){
                amountToSend = NOTIFY_MTU
            }
            
            // Copy out the data we want
            var chunk: NSData = NSData(bytes: self.dataToSend.bytes + self.sendDataIndex, length: amountToSend)
            
            
            //  Send It
            didSend = self.peripheralManager.updateValue(chunk, forCharacteristic: self.transferCharacteristic, onSubscribedCentrals: nil)
            
            // If it didn't work, drop out and wait for the callback
            if (!didSend){
                return
            }
            
            var stringFromData = NSString(data: chunk, encoding: NSUTF8StringEncoding)
            println("Sent: \(stringFromData)")
            
            //  It did send, so update our index
            var temp: NSInteger = self.sendDataIndex + amountToSend
            self.sendDataIndex = temp
            
            // It did send, so update our index
            if(self.sendDataIndex >= self.dataToSend.length){
                
                // It was - send an EOM
                
                // Set this so if the send fails, we'll send it next time
                sendingEOM = true
                
                //  Send It
                var eomSent = self.peripheralManager.updateValue("".dataUsingEncoding(NSUTF8StringEncoding, allowLossyConversion: true), forCharacteristic: self.transferCharacteristic, onSubscribedCentrals: nil)
                
                if(eomSent){
                    // It sent, we're all done
                    sendingEOM = false
                    println("Sent: EOM")
                }
                return
                
            }
        }
    }
    
    
    /** This callback comes in when the PeripheralManager is ready to send the next chunk of data.
    *  This is to ensure that packets will arrive in the order they are sent
    */
    
    func peripheralManagerIsReadyToUpdateSubscribers(peripheral: CBPeripheralManager!) {
        self.sendData()
    }
    
    
    //  Mark: - TextView Methods
    func textViewDidChange(textView: UITextView) {
        if(self.advertisingSwitch.on){
            self.advertisingSwitch.setOn(false, animated: true)
            self.peripheralManager.stopAdvertising()
        }
    }
    
    
    /** Adds the 'Done' button to the title bar
    */
    
    func textViewShouldBeginEditing(textView: UITextView) -> Bool {
        // We need to add this manually so we have a way to dismiss the keyboard
        var rightButton: UIBarButtonItem = UIBarButtonItem(title: "Done", style: UIBarButtonItemStyle.Done, target: self, action: Selector("dismissKeyboard"))
        
        return true
    }
    
    /** Finishes the editing */
    func dismisskeyboard(){
        self.textView.resignFirstResponder()
        self.navigationItem.rightBarButtonItem = nil
    }
    
    
    // Mark: - Switch Methods
    
    /** Start advertising
    */
    
    @IBAction func switchChanged(sender: AnyObject) {
        if(self.advertisingSwitch.on){
            // All we advertise is our service's UUID
            self.peripheralManager.startAdvertising(
                [ CBAdvertisementDataServiceUUIDsKey : [CBUUID(string:TRANSFER_SERVICE_UUID)] ])
            println("Action")
        }else{
            self.peripheralManager.stopAdvertising()
        }
    }
    
    
    
    /*
    // MARK: - Navigation
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
    // Get the new view controller using segue.destinationViewController.
    // Pass the selected object to the new view controller.
    }
    */
    
}
