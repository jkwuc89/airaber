//
//  ScheduleInterfaceController.swift
//  AirAber
//
//  Created by Keith Wedinger on 11/6/15.
//  Copyright © 2015 Mic Pringle. All rights reserved.
//

import WatchKit
import Foundation

class ScheduleInterfaceController: WKInterfaceController {
    @IBOutlet var flightsTable: WKInterfaceTable!
    var flights = Flight.allFlights()
    var selectedIndex = 0
    
    override func awakeWithContext(context: AnyObject?) {
        super.awakeWithContext(context)
        // Set number of rows in table using number of flights
        flightsTable.setNumberOfRows(flights.count, withRowType: "FlightRow")
        
        // Iterate over each row in the flights table and set
        // the controller for each to FlightRowController
        for index in 0..<flightsTable.numberOfRows {
            if let controller = flightsTable.rowControllerAtIndex(index) as? FlightRowController {
                // This triggers didSet inside the FlightRowController
                // which causes each row to be populated
                controller.flight = flights[index]
            }
        }
    }
    
    // Schedule interface is now visible
    override func didAppear() {
        super.didAppear()
        // If the selected flight is checked in, attempt to cast controller to a FlightRowController
        if flights[selectedIndex].checkedIn,
            let controller = flightsTable.rowControllerAtIndex(selectedIndex) as? FlightRowController {
            // Execute the given closure to update the row with animation
            animateWithDuration(0.35, animations: { () -> Void in
                // 3
                controller.updateForCheckIn()
            })
        }
    }
    
    // Handle taps on flight rows
    override func table(table: WKInterfaceTable, didSelectRowAtIndex rowIndex: Int) {
        let flight = flights[rowIndex]
        selectedIndex = rowIndex
        // Present controllers for the flight. User can swipe between
        // them on the watch face...pretty cool!
        let controllers = flight.checkedIn ? ["Flight", "BoardingPass"] : ["Flight", "CheckIn"]
        presentControllerWithNames(controllers, contexts:[flight, flight])
    }
}
