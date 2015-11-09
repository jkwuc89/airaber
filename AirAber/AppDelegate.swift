//
//  AppDelegate.swift
//  AirAber
//
//  Created by Mic Pringle on 05/08/2015.
//  Copyright © 2015 Mic Pringle. All rights reserved.
//

import UIKit
import WatchConnectivity

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    var window: UIWindow?
    
    // WCSession property for communicating with the companion Watch app
    var session: WCSession? {
        didSet {
            if let session = session {
                session.delegate = self
                session.activateSession()
            }
        }
    }
    
    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        // If Watch connectivity is supported, set the WCSession to the
        // singleton default session provided by the Watch connectivity framework
        if WCSession.isSupported() {
            session = WCSession.defaultSession()
        }
        return true
    }
    
}

// WCSession delegate implementation
extension AppDelegate: WCSessionDelegate {
    func session(session: WCSession, didReceiveMessage message: [String : AnyObject],
        replyHandler: ([String : AnyObject]) -> Void) {
            // Get the Flight reference and create a boarding pass for it
            if let reference = message["reference"] as? String, boardingPass = QRCode(reference) {
                let viewController:ViewController = window!.rootViewController as! ViewController
                // Update the UI on the main thread
                dispatch_async(dispatch_get_main_queue()) {
                    viewController.flightReference = reference
                }
                // Send the boarding pass back via the session's reply handler
                replyHandler(["boardingPassData": boardingPass.PNGData])
            }
        }
}
