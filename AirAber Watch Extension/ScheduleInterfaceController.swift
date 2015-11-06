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
    
    // Handle taps on flight rows
    override func table(table: WKInterfaceTable, didSelectRowAtIndex rowIndex: Int) {
        let flight = flights[rowIndex]
        presentControllerWithName("Flight", context: flight)
    }
}
