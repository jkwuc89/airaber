//
//  ViewController.swift
//  AirAber
//
//  Created by Mic Pringle on 05/08/2015.
//  Copyright © 2015 Mic Pringle. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    @IBOutlet weak var flightReferenceLabel: UILabel!
    
    var flightReference : String? {
        didSet {
            // When flight reference is set, update the label 
            // to display it
            if let flightReference = flightReference {
                flightReferenceLabel.text = flightReference
            }
        }
    }
}

