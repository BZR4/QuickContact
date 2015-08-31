//
//  CentralViewController.swift
//  Quick Contacts
//
//  Created by Esdras Bezerra da Silva on 24/08/15.
//  Copyright (c) 2015 Esdras Bezerra da Silva. All rights reserved.
//

import UIKit
import CoreBluetooth

class CentralViewController: UIViewController, CBCentralManagerDelegate, CBPeripheralDelegate {
    
    // Mark: - Properties and Outlets
    var centralManager = CBCentralManager?()
    var discoveredPeripheral:CBPeripheral!
    var data: NSMutableData!
    @IBOutlet weak var textView: UITextView!
    
    @IBOutlet weak var saidaLabel: UILabel!
    @IBOutlet weak var nomeLabel: UILabel!
    @IBOutlet weak var sobrenomeLabel: UILabel!
    @IBOutlet weak var telefoneLabel: UILabel!
    @IBOutlet weak var emailLabel: UILabel!
    @IBOutlet weak var facebookLabel: UILabel!
    
    var arrayFromContacts: [String] = []
    
    @IBOutlet weak var receivedCard: UIView!
    
    var contacts: Contacts = Contacts()
    
    var dataFromContact = String()
    
    let TRANSFER_SERVICE_UUID = "E20A39F4-73F5-4BC4-A12F-17D1AD07A961"
    let TRANSFER_CHARACTERISTIC_UUID = "08590F7E-DB05-467E-8757-72F6FAEB13D4"
    
    //  Mark:  - Life Cicle Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //  Iniciar o cantral manager
        centralManager = CBCentralManager(delegate: self, queue: nil)
        //  Adicionar um valor inicial para o data
        data = NSMutableData()
        
        applyPlainShadow (receivedCard)
                
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        self.clearLabels()
        self.scan()
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        centralManager?.stopScan()
        println("Parou o Scan")
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func applyPlainShadow(view: UIView) {
        var layer = view.layer
        
        layer.shadowColor = UIColor.blackColor().CGColor
        layer.shadowOffset = CGSize(width: 0, height: 10)
        layer.shadowOpacity = 0.4
        layer.shadowRadius = 5
    }
    
    //  Mark: - Central Methods
    /// Checar o estado do BTLE device
    func centralManagerDidUpdateState(central: CBCentralManager!) {
        if (central.state != CBCentralManagerState.PoweredOn){
            //  functions implementeds
            return
        }
        
        //  Iniciar o Scan
        self.scan()
        
    }
    
    /// Scan de perifericos
    func scan(){
        self.centralManager?.scanForPeripheralsWithServices([CBUUID(string: TRANSFER_SERVICE_UUID)], options:
            [CBCentralManagerScanOptionAllowDuplicatesKey:true])
        println("Scan iniciado")
    }
    
    /** This callback comes whenever a peripheral that is advertising the TRANSFER_SERVICE_UUID is discovered.
    *  We check the RSSI, to make sure it's close enough that we're interested in it, and if it is,
    *  we start the connection process
    */
    
    func centralManager(central: CBCentralManager!, didDiscoverPeripheral peripheral: CBPeripheral!, advertisementData: [NSObject : AnyObject]!, RSSI: NSNumber!) {
        //  rejeitar qualquer valor acima do ressonancia
        if(RSSI.integerValue > -15){
            return
        }
        
        //  Rejeitar se a forca do sinal for baixa o bastenate para ser considerado PERTO (PERTO é -22dB)
        if(RSSI.integerValue < -35){
            return
        }
        
        println("Descoberto \(peripheral.name) em \(RSSI)")
        
        // Nao esta no range - pode ser visualizado?
        if(self.discoveredPeripheral != peripheral){
            
            //  Salva uma copia do periferico, entao o CoreBluetooth  não de livra dele
            self.discoveredPeripheral = peripheral
            
            // E conecta com ele
            println("Conectando-se ao periferico: \(peripheral)")
            self.centralManager?.connectPeripheral(peripheral, options: nil)
        }
        
    }
    
    /// Se a conexao falha, por alguma razao, precisamos corrigir
    func centralManager(central: CBCentralManager!, didFailToConnectPeripheral peripheral: CBPeripheral!, error: NSError!) {
        println("Falha em conexao com \(peripheral). Erro: \(error.localizedDescription)")
        
        /// Descomentar em breve
        self.cleanup()
    }
    
    /// O device esta conectado e precisamos descobri caracteristicas e servicos para transferir
    func centralManager(central: CBCentralManager!, didConnectPeripheral peripheral: CBPeripheral!) {
        println("Periferico Conectado!")
        
        //  Para Scan
        self.centralManager!.stopScan()
        println("Scan Parado!")
        
        //  limpara dados que serao necessarios
        self.data?.length = 0
        
        // Ter certeza que teremos os discoverys callbacks
        peripheral.delegate = self
        
        // Procurar apenas por servicos que correspondam com seu UUID
        peripheral.discoverServices([CBUUID(string: TRANSFER_SERVICE_UUID)])
    }
    
    /// O Servico de Tranferencia foi descoberto
    func peripheral(peripheral: CBPeripheral!, didDiscoverServices error: NSError!) {
        if((error) != nil){
            println("Erro descobrindo Servicos: \(error.localizedDescription)")
            self.cleanup()
            return
        }
        
        // Discover the characteristic we want...
        
        // Loop through the newly filled peripheral.services array, just in case there's more than one.
        
        for service in peripheral.services as! [CBService] {
            peripheral.discoverCharacteristics([CBUUID(string: TRANSFER_CHARACTERISTIC_UUID)], forService: service)
        }
    }
    
    /// Descobrir as caracteristicas qu queremos
    func peripheral(peripheral: CBPeripheral!, didDiscoverCharacteristicsForService service: CBService!, error: NSError!) {
        // Erros ao descobrir servicos
        if(error != nil){
            println("Erro ao descobrir caracteristicas \(error.localizedDescription)")
            self.cleanup()
            return
        }
        
        // Again, we loop through the array, just in case.
        for characteristic in service.characteristics as! [CBCharacteristic]!
        {
            // And check if it's the right one
            if(characteristic.UUID.isEqual(CBUUID(string: TRANSFER_CHARACTERISTIC_UUID)))
            {
                // If it is, subscribe to it
                peripheral.setNotifyValue(true, forCharacteristic: characteristic)
            }
        }
        
        // Once this is complete, we just need to wait for the data to come in.
    }
    
    
    
    /** This callback lets us know more data has arrived via notification on the characteristic
    */
    
    func peripheral(peripheral: CBPeripheral!, didUpdateValueForCharacteristic characteristic: CBCharacteristic!, error: NSError!) {
        
        if let error = error {
            println("Error discovering services: \(error.localizedDescription)")
            return
        }
        
        // Have we got everything we need?
        if let stringFromData = NSString(data: characteristic.value, encoding: NSUTF8StringEncoding) {
            if stringFromData.isEqualToString("EOM") {
                // We have, so show the data,
                //                textView.text = NSString(data: (data.copy() as! NSData) as NSData, encoding: NSUTF8StringEncoding) as! String
                
                self.dataFromContact = NSString(data: (data.copy() as! NSData) as NSData, encoding: NSUTF8StringEncoding) as! String
                
                var contact = self.dataFromContact
                
                var arrayContact: [String] = contact.componentsSeparatedByString("|") as [String]
                
                self.arrayFromContacts = arrayContact
                
                //essa linha comentada no código do esdras
                //self.setLabels(arrayFromContacts[0], lastName: arrayFromContacts[1], email: "", phone: arrayFromContacts[2], face: arrayFromContacts[3])
                
//                self.nomeLabel.text = arrayContact[0]
//                self.sobrenomeLabel.text = arrayContact[1]
//                self.telefoneLabel.text = arrayContact[2]
//                self.facebookLabel.text = arrayContact[3]
                
                
                // Cancel our subscription to the characteristic
                peripheral.setNotifyValue(false, forCharacteristic: characteristic)
                
                // and disconnect from the peripehral
                centralManager?.cancelPeripheralConnection(peripheral)
            }
            
            // Otherwise, just add the data on to what we already have
            data.appendData(characteristic.value)
            
            if (arrayFromContacts.count > 0) {
                self.setLabels(arrayFromContacts[0], lastName: arrayFromContacts[1], email: arrayFromContacts[3], phone: arrayFromContacts[2], face: arrayFromContacts[4])
                
                //                self.nomeLabel.text = arrayContact[0]
                //                self.sobrenomeLabel.text = arrayContact[1]
                //                self.telefoneLabel.text = arrayContact[2]
                //                self.facebookLabel.text = arrayContact[3]

            }
            
            
            // Log it
            println("Received: \(stringFromData)")
            self.dataFromContact = stringFromData as! String
        } else {
            println("Invalid data")
        }
    }
    
    
    /** The peripheral letting us know whether our subscribe/unsubscribe happened or not
    */
    
    func peripheral(peripheral: CBPeripheral!, didUpdateNotificationStateForCharacteristic characteristic: CBCharacteristic!, error: NSError!) {
        if(error != nil){
            println("Erro mudando o estado de notificação: \(error.localizedDescription)")
        }
        
        // Exit if it's not the transfer characteristic
        if(!characteristic.UUID.isEqual(CBUUID(string: TRANSFER_CHARACTERISTIC_UUID))){
            return
        }
        
        //Notificacao nao inicializada
        if(characteristic.isNotifying){
            println("Notificacao iniciou em \(characteristic)")
        }else{//Notificacao parou
            println("Notoficacao parada em \(characteristic). Desconectando")
            self.centralManager?.cancelPeripheralConnection(peripheral)
        }
    }
    
    
    
    /** Once the disconnection happens, we need to clean up our local copy of the peripheral
    */
    
    func centralManager(central: CBCentralManager!, didDisconnectPeripheral peripheral: CBPeripheral!, error: NSError!) {
        println("Periferico desconectado")
        self.discoveredPeripheral = nil
        
        // We're disconnected, so start scanning again
        
        self.scan()
    }
    
    /** Call this when things either go wrong, or you're done with the connection.
    *  This cancels any subscriptions if there are any, or straight disconnects if not.
    *  (didUpdateNotificationStateForCharacteristic will cancel the connection if a subscription is involved)
    */
    
    func cleanup(){
        // Don't do anything if we're not connected
        if(self.discoveredPeripheral.state == CBPeripheralState.Connected){
            return
        }
        // See if we are subscribed to a characteristic on the peripheral
        if self.discoveredPeripheral.services != nil {
            
            for service in self.discoveredPeripheral.services as! [CBService]!
            {
                
                if service.characteristics != nil  {
                    
                    for characteristic in service.characteristics as! [CBCharacteristic]!
                    {
                        if(characteristic.UUID.isEqual(CBUUID(string: TRANSFER_CHARACTERISTIC_UUID)))
                        {
                            if characteristic.isNotifying
                            {
                                // It is notifying, so unsubscribe
                                self.discoveredPeripheral.setNotifyValue(false, forCharacteristic: characteristic)
                            }
                            
                        }
                    }
                }
            }
        }
        
    }
    
    func setLabels(name: String, lastName: String, email: String, phone: String, face: String){
        self.nomeLabel.text = name;
        self.sobrenomeLabel.text = lastName;
        self.emailLabel.text = email;
        self.telefoneLabel.text = phone;
        self.facebookLabel.text = face;
    }
    
    func clearLabels(){
        self.nomeLabel.text = "";
        self.sobrenomeLabel.text = "";
        self.emailLabel.text = "";
        self.telefoneLabel.text = "";
        self.facebookLabel.text = "";
    }
    
    
    
    @IBAction func create(sender: AnyObject) {
        
        if(self.contacts.showUnknownPersonViewController(self.nomeLabel.text, name: self.sobrenomeLabel.text, phone: self.telefoneLabel.text, emailString: self.emailLabel.text, faceURL: self.facebookLabel.text)){
            self.clearLabels()
            
            self.saidaLabel.text = "ADDED"
        }
        
        
    }
    
    //Mark: - ABUnknownPersonViewControllerDelegate methods
    // Dismisses the picker when users are done creating a contact or adding the displayed person properties to an existing contact.
    func unknownPersonViewController(unknownCardViewController: ABUnknownPersonViewController,
        didResolveToPerson person: ABRecord?){
            
            self.navigationController?.popViewControllerAnimated(true)
            
    }
    
    func unknownPersonViewController(personViewController: ABUnknownPersonViewController,
        shouldPerformDefaultActionForPerson person: ABRecord,
        property: ABPropertyID,
        identifier: ABMultiValueIdentifier) -> Bool{
            
            return true
    }
    
    
    
    //Mark: - ABNewPersonViewControllerDelegate methods
    // Dismisses the new-person view controller.
    func newPersonViewController(newPersonView: ABNewPersonViewController!, didCompleteWithNewPerson person: ABRecord!) {
        
        newPersonView.navigationController?.dismissViewControllerAnimated(true, completion: nil);
        
    }
    
    
}
