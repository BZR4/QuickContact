//
//  ProfileModel.swift
//  Tinder
//
//  Created by Marco on 8/27/15.
//  Copyright (c) 2015 Marco. All rights reserved.
//

import UIKit

class ProfileModel {

    // aqui está sendo usado o padrão Singleton = só permite uma instância da classe
    // instanciada na memória. Além isso, é ela mesmo que se instancia, por isso o
    // seu init é private. O que faz ter apenas uma instância é o fato da variável
    // ser static.
    static let singleton = ProfileModel ()

    var userUniqueIdentifier : String
    
    var name      : String
    var phone     : String
    var facebook  : String
    var email     : String
    var extraInfo : String
    
    var phoneShare    : Bool
    var facebookShare : Bool
    var emailShare    : Bool
    
    // o método é private pois é uma classe singleton
    private init () {

        userUniqueIdentifier = ""
        
        name = ""
        phone = ""
        facebook = ""
        email = ""
        extraInfo = ""
        
        phoneShare = false
        facebookShare = false
        emailShare = false
    }
}
