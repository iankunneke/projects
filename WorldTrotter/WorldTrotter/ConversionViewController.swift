//
//  ConversionViewController.swift
//  WorldTrotter
//
//  Created by ian kunneke on 3/11/16.
//  Copyright © 2016 zivit. All rights reserved.
//

import UIKit

class ConversionViewController: UIViewController {
    
    @IBOutlet var celsiusLabel: UILabel!
    
    @IBAction func fahrenheitFieldEditingChanged(textField: UITextField) {
        
        if let text = textField.text where !text.isEmpty {
            celsiusLabel.text = text
        }
        else {
            celsiusLabel.text = "???"
        }
    }
    
}
