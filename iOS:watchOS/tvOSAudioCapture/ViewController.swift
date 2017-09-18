//
//  ViewController.swift
//  tvOSAudioCapture
//
//  Created by Jacopo Mangiavacchi on 9/18/17.
//  Copyright © 2017 JacopoMangia. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    var nsb: NetServiceBrowser!
    let serverType = "_tvOSReceiverServer._tcp."
    let serverDomain = "local"

    override func viewDidLoad() {
        super.viewDidLoad()

        /// Net service browser.
        nsb = NetServiceBrowser()
        nsb.delegate = self
        nsb.searchForServices(ofType: serverType, inDomain: serverDomain)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}


extension ViewController: NetServiceBrowserDelegate {
    func netServiceBrowser(_ netServiceBrowser: NetServiceBrowser,
                           didFindDomain domainName: String,
                           moreComing moreDomainsComing: Bool) {
        print("netServiceDidFindDomain")
    }
    
    func netServiceBrowser(_ netServiceBrowser: NetServiceBrowser,
                           didRemoveDomain domainName: String,
                           moreComing moreDomainsComing: Bool) {
        print("netServiceDidRemoveDomain")
    }
    
    func netServiceBrowser(_ netServiceBrowser: NetServiceBrowser,
                           didFind netService: NetService,
                           moreComing moreServicesComing: Bool) {
        print("netServiceDidFindService")
    }
    
    func netServiceBrowser(_ netServiceBrowser: NetServiceBrowser,
                           didRemove netService: NetService,
                           moreComing moreServicesComing: Bool) {
        print("netServiceDidRemoveService")
    }
    
    func netServiceBrowserWillSearch(aNetServiceBrowser: NetServiceBrowser!){
        print("netServiceBrowserWillSearch")
    }
    
    func netServiceBrowser(_ browser: NetServiceBrowser, didNotSearch errorDict: [String : NSNumber]) {
        print("netServiceDidNotSearch")
    }
    
    func netServiceBrowserDidStopSearch(_ netServiceBrowser: NetServiceBrowser) {
        print("netServiceDidStopSearch")
    }
}
