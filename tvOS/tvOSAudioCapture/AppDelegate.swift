//
//  AppDelegate.swift
//  tvOSAudioCapture
//
//  Created by Jacopo Mangiavacchi on 9/17/17.
//  Copyright © 2017 JacopoMangia. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    var server: ReceiverServer!
    var serverService: NetService!
    let serverPort = 6543
    let serverDomain = "local"
    let serverType = "_tvOSReceiverServer._tcp."
    let serverName = "ReceiverServer"
    

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        // Start the server
        server = ReceiverServer(port: serverPort) { data in print("received \(data.count) bytes") }
        server.run()
        
        // Advertise the Netservice
        serverService = NetService(domain: serverDomain, type: serverType, name: serverName, port: Int32(serverPort))
        serverService.delegate = self
        serverService.publish()
        
        return true
    }

    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }


}

extension AppDelegate: NetServiceDelegate {
    func netServiceWillPublish(_ sender: NetService) {
        //print("netServiceWillPublish:\(sender)");
    }
    
    func netService(_ sender: NetService, didNotPublish errorDict: [String : NSNumber]) {
        print("didNotPublish:\(sender)");
    }
    
    func netServiceDidPublish(_ sender: NetService) {
        print("netServiceDidPublish:\(sender)");
    }
    
    func netServiceWillResolve(_ sender: NetService) {
        print("netServiceWillResolve:\(sender)");
    }
    
    func netService(_ sender: NetService, didNotResolve errorDict: [String : NSNumber]) {
        print("netServiceDidNotResolve:\(sender)");
    }
    
    func netServiceDidResolveAddress(_ sender: NetService) {
        print("netServiceDidResolve:\(sender)");
    }
    
    func netService(_ sender: NetService, didUpdateTXTRecord data: Data) {
        print("netServiceDidUpdateTXTRecordData:\(sender)");
    }
    
    func netServiceDidStop(_ sender: NetService) {
        print("netServiceDidStopService:\(sender)");
    }
    
    func netService(_ sender: NetService,
                    didAcceptConnectionWith inputStream: InputStream,
                    outputStream stream: OutputStream) {
        print("netServiceDidAcceptConnection:\(sender)");
    }
}

