//
//  Login.swift
//  Raiz Pic
//
//  Created by Marco Linhares on 8/15/15.
//  Copyright (c) 2015 Marco. All rights reserved.
//

import UIKit

class ParseModel {
    
    // aqui está sendo usado o padrão Singleton = só permite uma instância da classe
    // instanciada na memória. Além isso, é ela mesmo que se instancia, por isso o
    // seu init é private. O que faz ter apenas uma instância é o fato da variável
    // ser static.
    static let singleton = ParseModel ()
    
    var userList : [String] = []
    
    // o método é private pois é uma classe singleton
    private init () {
    }
    
    // passa uma closure informando se o resultado deu certo ou não
    func registerNewUser (username: String, password : String, completion : (result : Bool, error: NSError?) -> Void) {
        
        var user = PFUser ()
        
        user.username = username
        user.password = password
        
        user.signUpInBackgroundWithBlock {
            (succeeded : Bool, error: NSError?) -> Void in
            
            if let error = error {
                let errorString = error.userInfo? ["error"] as? NSString
                // Show the errorString somewhere and let the user try again.
                
            } else {
                // Hooray! Let them use the app now.
                
                self.userList.append (user.username!)
            }
            
            completion (result: succeeded, error: error)
        }
    }
    
    func login (username: String, password : String, completion : (result : PFUser?, error: NSError?) -> Void) {
        
        PFUser.logInWithUsernameInBackground (username, password: password) {
            (user: PFUser?, error: NSError?) -> Void in
            
            if user != nil {
                // Do stuff after successful login.
                
            } else {
                // The login failed. Check error to see why.
                
            }
            
            completion (result: user, error: error)
        }
    }
    
    // toda vez que a pessoa cria uma conta ou se loga, seus dados ficam
    // armazenados no programa automaticamente. logo, a 1a coisa a se
    // fazer é chamar essa função pra ver se ele já tem esses dados salvos.
    // se tiver, não precisa fazer login toda vez que o usuário logar no app.
    func autoLogin () -> PFUser? {
        
        var currentUser = PFUser.currentUser ()
        
        // retorna nil quando o usuário não existe
        // os dados são armazenados anteriormente usando Core Data
        return currentUser
    }
    
    func logout () {
        PFUser.logOut ()
    }
    
    func getUsersList (completion : (result : [String]) -> Void) {
        
        // retorna a lista remotamente de forma assíncrona
        var query = PFUser.query ()
        
        query!.findObjectsInBackgroundWithBlock {
            
            (objects: [AnyObject]?, error: NSError?) -> Void in
            
            if error != nil {
                // Log details of the failure
                println("Error: \(error!) \(error!.userInfo!)")
                
            } else {
                // The find succeeded
                // Do something with the found objects
                // itera sobre cada objeto e adiciona o username em uma lista
                if let objects = objects as? [PFUser] {
                    
                    for object in objects {
                        self.userList.append (object.username!)
                    }
                    
                    // retorna a lista de usuários
                    completion (result: self.userList)
                }
            }
        }
    }
    
    // salva a imagem no parse
    func saveImageWeb (image: UIImage, textDescription : String, completion : (result : Bool, error: NSError?) -> Void) {
        var imagesClass = PFObject (className: "Images")
        
        // armazena a imagem em uma variável
        let imageData = UIImagePNGRepresentation (image)
        
        // cria um arquivo para o Parse salvar
        let imageFile = PFFile (name: "image.png", data: imageData)
        
        imagesClass ["title"]    = textDescription
        imagesClass ["image"]    = imageFile
        imagesClass ["username"] = PFUser.currentUser()?.username
        
        imagesClass.saveInBackgroundWithBlock () {
            
            (success: Bool, error: NSError?) -> Void in
            
            completion (result: success, error: error)
        }
    }
}
