//
//  FlightInterfaceController.swift
//  AirAber
//
//  Created by Keith Wedinger on 11/4/15.
//  Copyright © 2015 Mic Pringle. All rights reserved.
//

import WatchKit
import Foundation


class FlightInterfaceController: WKInterfaceController {
    // Label outlets
    @IBOutlet var flightLabel: WKInterfaceLabel!
    @IBOutlet var routeLabel: WKInterfaceLabel!
    @IBOutlet var boardingLabel: WKInterfaceLabel!
    @IBOutlet var boardTimeLabel: WKInterfaceLabel!
    @IBOutlet var statusLabel: WKInterfaceLabel!
    @IBOutlet var gateLabel: WKInterfaceLabel!
    @IBOutlet var seatLabel: WKInterfaceLabel!
    
    // Flight property which is optional
    var flight: Flight? {
        // didSet observer that sets the label text
        didSet {
            // Set the label text only if flight is not nil
            if let flight = flight {
                flightLabel.setText("Flight \(flight.shortNumber)")
                routeLabel.setText(flight.route)
                boardingLabel.setText("\(flight.number) Boards")
                boardTimeLabel.setText(flight.boardsAt)
                if flight.onSchedule {
                    statusLabel.setText("On Time")
                } else {
                    statusLabel.setText("Delayed")
                    statusLabel.setTextColor(UIColor.redColor())
                }
                gateLabel.setText("Gate \(flight.gate)")
                seatLabel.setText("Seat \(flight.seat)")
            }
        }
    }
    
    // Initialize this interface control with data contained in the specified context
    override func awakeWithContext(context: AnyObject?) {
        super.awakeWithContext(context)
        // Tapped flight is passed in from ScheduleInterfaceController via context
        if let flight = context as? Flight {
            self.flight = flight
        }
    }
}