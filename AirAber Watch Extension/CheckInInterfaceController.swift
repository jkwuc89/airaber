//
//  CheckInInterfaceController.swift
//  AirAber
//
//  Created by Keith Wedinger on 11/6/15.
//  Copyright © 2015 Mic Pringle. All rights reserved.
//

import WatchKit
import Foundation

class CheckInInterfaceController: WKInterfaceController {
    @IBOutlet var backgroundGroup: WKInterfaceGroup!
    @IBOutlet var originLabel: WKInterfaceLabel!
    @IBOutlet var destinationLabel: WKInterfaceLabel!
    
    var flight: Flight? {
        didSet {
            if let flight = flight {
                originLabel.setText(flight.origin)
                destinationLabel.setText(flight.destination)
            }
        }
    }
    
    override func awakeWithContext(context: AnyObject?) {
        super.awakeWithContext(context)
        if let flight = context as? Flight {
            self.flight = flight
        }
    }
    
    @IBAction func checkInButtonTapped() {
        // Animation duraion
        let duration = 0.35
        // Delay, after which this controller will be dismissed
        let delay = dispatch_time(DISPATCH_TIME_NOW,
            Int64((duration + 0.15) * Double(NSEC_PER_SEC)))
        // Load the image sequence for the animation
        backgroundGroup.setBackgroundImageNamed("Progress")
        // Playback the image sequence
        backgroundGroup.startAnimatingWithImagesInRange(NSRange(location: 0, length: 10), duration: duration, repeatCount: 1)
        // Use Grand Central Dispatch to execute the the closure below after the delay
        dispatch_after(delay, dispatch_get_main_queue()) { () -> Void in
            // Mark the flight as checked in and dismiss this controller
            self.flight?.checkedIn = true
            self.dismissController()
        }
    }
}
