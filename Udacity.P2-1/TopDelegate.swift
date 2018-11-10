//
//  TopDelegate.swift
//  Udacity.P2-1
//
//  Created by Brian Diego De Souza on 23/10/2018.
//  Copyright © 2018 Array App. All rights reserved.
//

import Foundation
import UIKit

class TopDelegate : NSObject, UITextFieldDelegate {
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
            textField.text = ""
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        let memeTextAttributes: [String: Any] = [
            NSAttributedStringKey.strokeWidth.rawValue: 1,
            NSAttributedStringKey.font.rawValue:UIFont(name: "HelveticaNeue-CondensedBlack", size: 40)!,
            NSAttributedStringKey.strokeColor.rawValue: UIColor.black,
            NSAttributedStringKey.foregroundColor.rawValue: UIColor.white
        ]
        
        textField.defaultTextAttributes = memeTextAttributes
        textField.textAlignment = NSTextAlignment.center
        textField.text = "TOP"
        
        return true
    }
    
    func te
}
