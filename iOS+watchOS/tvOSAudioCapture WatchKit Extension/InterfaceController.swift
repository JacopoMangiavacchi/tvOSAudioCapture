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

    @IBOutlet var foundLabel: WKInterfaceLabel!
    
    let serverType = "_tvOSReceiverServer._tcp."
    let serverDomain = "local."  //"local"
    
    var browser: NetServiceBrowser!


    override func awake(withContext context: Any?) {
        super.awake(withContext: context)
        
        // Configure interface objects here.
    }
    
    override func willActivate() {
        // This method is called when watch view controller is about to be visible to user
        super.willActivate()
    }
    
    override func didDeactivate() {
        // This method is called when watch view controller is no longer visible
        super.didDeactivate()
    }

    @IBAction func go() {
        foundLabel.setText("Waiting")
        
        browser = NetServiceBrowser()
        browser.delegate = self
        browser.searchForServices(ofType: serverType, inDomain: serverDomain)
    }
}

extension InterfaceController: NetServiceBrowserDelegate {
    
    func netServiceBrowser(_ browser: NetServiceBrowser, didFind service: NetService, moreComing: Bool) {
        print("didFind")
        
        DispatchQueue.main.async {
            self.foundLabel.setText("FOUND!!!")
        }
    }

    func netServiceBrowser(_ browser: NetServiceBrowser, didRemove service: NetService, moreComing: Bool) {
        print("didRemove")
    }

    func netServiceBrowserWillSearch(_ browser: NetServiceBrowser) {
        print("WillSearch")

        DispatchQueue.main.async {
            self.foundLabel.setText("Waiting ...")
        }
    }

    func netServiceBrowser(_ browser: NetServiceBrowser, didNotSearch error: Error) {
        print("didNotSearch")

        DispatchQueue.main.async {
            self.foundLabel.setText("Not Search")
        }
    }

    func netServiceBrowserDidStopSearch(_ browser: NetServiceBrowser) {
        print("DidStopSearch")

        DispatchQueue.main.async {
            self.foundLabel.setText("Stop Search")
        }
    }

}
