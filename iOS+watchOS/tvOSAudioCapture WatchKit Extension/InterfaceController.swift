//
//  InterfaceController.swift
//  tvOSAudioCapture WatchKit Extension
//
//  Created by Jacopo Mangiavacchi on 9/18/17.
//  Copyright © 2017 JacopoMangia. All rights reserved.
//

import WatchKit
import Foundation

class InterfaceController: WKInterfaceController {

    let serverType = "_tvOSReceiverServer._tcp."
    let serverDomain = "local."  //"local"

    override func awake(withContext context: Any?) {
        super.awake(withContext: context)
        
        // Configure interface objects here.
    }
    
    override func willActivate() {
        // This method is called when watch view controller is about to be visible to user
        super.willActivate()
        
        let browser = NetServiceBrowser()
        browser.delegate = self
        browser.searchForServices(ofType: serverType, inDomain: serverDomain)
    }
    
    override func didDeactivate() {
        // This method is called when watch view controller is no longer visible
        super.didDeactivate()
    }

}

extension InterfaceController: NetServiceBrowserDelegate {
    
    func netServiceBrowser(_ browser: NetServiceBrowser, didFind service: NetService, moreComing: Bool) {
        print("didFind")
    }

    func netServiceBrowser(_ browser: NetServiceBrowser, didRemove service: NetService, moreComing: Bool) {
        print("didRemove")
    }

    func netServiceBrowserWillSearch(_ browser: NetServiceBrowser) {
        print("WillSearch")
    }

    func netServiceBrowser(_ browser: NetServiceBrowser, didNotSearch error: Error) {
        print("didNotSearch")
    }

    func netServiceBrowserDidStopSearch(_ browser: NetServiceBrowser) {
        print("DidStopSearch")
    }

}
