//
//  TableViewCustom.swift
//  Tinder
//
//  Created by Marco on 8/27/15.
//  Copyright (c) 2015 Marco. All rights reserved.
//

import UIKit

class TableViewCustom: UITableView {

    /*
    // Only override drawRect: if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func drawRect(rect: CGRect) {
        // Drawing code
    }
    */
    
    override func touchesBegan (touches: Set <NSObject>, withEvent event: UIEvent) {
        
        // pára de editar, o que significa que o teclado desaparece
        endEditing (true)
        
        // pára de editar, o que significa que o teclado desaparece
        //self.view.endEditing (true)
        
        super.touchesBegan(touches, withEvent: event)
    }


}
