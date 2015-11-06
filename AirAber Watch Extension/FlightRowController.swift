//
//  FlightRowController.swift
//  AirAber
//
//  Created by Keith Wedinger on 11/6/15.
//  Copyright © 2015 Mic Pringle. All rights reserved.
//

import WatchKit

class FlightRowController: NSObject {
    // Outlets for the iterface elements inside each flight row
    @IBOutlet var separator: WKInterfaceSeparator!
    @IBOutlet var originLabel: WKInterfaceLabel!
    @IBOutlet var destinationLabel: WKInterfaceLabel!
    @IBOutlet var flightNumberLabel: WKInterfaceLabel!
    @IBOutlet var statusLabel: WKInterfaceLabel!
    @IBOutlet var planeImage: WKInterfaceImage!
    
    // Optional flight property representing the flight for this table row
    var flight: Flight? {
        // Populate the row interface elements when this flight is set
        didSet {
            if let flight = flight {
                originLabel.setText(flight.origin)
                destinationLabel.setText(flight.destination)
                flightNumberLabel.setText(flight.number)
                if flight.onSchedule {
                    statusLabel.setText("On Time")
                } else {
                    statusLabel.setText("Delayed")
                    statusLabel.setTextColor(UIColor.redColor())
                }
            }
        }
    }
}
