//
//  BoardingPassInterfaceController.swift
//  AirAber
//
//  Created by Keith Wedinger on 11/7/15.
//  Copyright © 2015 Mic Pringle. All rights reserved.
//

import WatchKit
import Foundation
import WatchConnectivity

class BoardingPassInterfaceController: WKInterfaceController {
    @IBOutlet var originLabel: WKInterfaceLabel!
    @IBOutlet var destinationLabel: WKInterfaceLabel!
    @IBOutlet var boardingPassImage: WKInterfaceImage!

    // Flight property with didSet observer
    var flight: Flight? {
        didSet {
            if let flight = flight {
                originLabel.setText(flight.origin)
                destinationLabel.setText(flight.destination)
                // If the flight has a boarding pass, show it
                if let _ = flight.boardingPass {
                    showBoardingPass()
                }
            }
        }
    }
    
    // WCSession property for communicating with companion iPhone app
    var session: WCSession? {
        didSet {
            if let session = session {
                session.delegate = self
                session.activateSession()
            }
        }
    }
    
    override func awakeWithContext(context: AnyObject?) {
        super.awakeWithContext(context)
        if let flight = context as? Flight {
            self.flight = flight
        }
    }
    
    // Called when the boarding pass interface is displayed
    override func didAppear() {
        super.didAppear()
        // If we have a valid flight that has no boarding pass, and Watch Connectivity is supported,
        // then we move onto sending the message. We should always check to see if Watch Connectivity
        // is supported before attempting any communication with the paired phone.
        if let flight = flight where flight.boardingPass == nil && WCSession.isSupported() {
            // Set session to the default session singleton. This in-turn triggers the property observer,
            // setting the session’s delegate before activating it.
            session = WCSession.defaultSession()
            // We fire off the message to the companion iPhone app. We include a dictionary containing
            // the flight reference that will be forwarded to the iPhone app, and provide both reply and error handlers.
            session!.sendMessage(
                // Dictionary containing key / value for the message
                ["reference": flight.reference],
                // Send message reply handler
                // The reply handler receives a dictionary, and is called by the iPhone app.
                // We first try to extract the image data of the boarding pass from the dictionary,
                // before attempting to create an instance of UIImage with it.
                replyHandler: { (response) -> Void in
                    if let boardingPassData = response["boardingPassData"] as? NSData, boardingPass = UIImage(data: boardingPassData) {
                        // We set the image as the flight’s boarding pass, and then jump over to the
                        // main queue where we call showBoardingPass() to show it to the user. The reply
                        // and error handlers are called on a background queue, so if we need to update the
                        // interface, as we are here, then always make sure to jump to the main queue before doing so.
                        flight.boardingPass = boardingPass
                        dispatch_async(dispatch_get_main_queue(), { () -> Void in
                            self.showBoardingPass()
                        })
                    }
                },
                // Send message error handler
                // If the message sending fails then we simply print the error to the console.
                errorHandler: { (error) -> Void in
                    print(error)
                }
            )
        }
    }
    
    // Helper method to show the boarding pass image
    private func showBoardingPass() {
        boardingPassImage.stopAnimating()
        boardingPassImage.setWidth(120)
        boardingPassImage.setHeight(120)
        boardingPassImage.setImage(flight?.boardingPass)
    }
}

// Required to allow this interface controller to be assigned as a WCSession delegate above
extension BoardingPassInterfaceController: WCSessionDelegate {
}
