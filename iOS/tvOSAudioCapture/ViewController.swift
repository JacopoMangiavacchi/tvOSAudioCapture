//
//  ViewController.swift
//  tvOSAudioCapture
//
//  Created by Jacopo Mangiavacchi on 9/18/17.
//  Copyright © 2017 JacopoMangia. All rights reserved.
//

import UIKit
import AVFoundation
import Socket


class ViewController: UIViewController, AVAudioRecorderDelegate, AVAudioPlayerDelegate {
    
    @IBOutlet weak var recordingButton: UIButton!
    var recordingSession: AVAudioSession!
    var audioRecorder: AVAudioRecorder!
    var audioPlayer: AVAudioPlayer!
    
    enum RecPlayStatus {
        case Recording
        case SendToAppleTV
    }
    
    var status = RecPlayStatus.Recording
    
    var nsb: NetServiceBrowser!
    let serverType = "_tvOSReceiverServer._tcp."
    let serverDomain = "local"
    
    var services = [NetService]()

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        /// Net service browser.
        nsb = NetServiceBrowser()
        nsb.delegate = self
        nsb.searchForServices(ofType: serverType, inDomain: serverDomain)
        
        
        recordingSession = AVAudioSession.sharedInstance()
        
        do {
            try recordingSession.setCategory(AVAudioSessionCategoryPlayAndRecord, with: [.allowBluetooth])
            try recordingSession.setActive(true)
            
//            let availableInputs = recordingSession.availableInputs
//            for input in availableInputs! {
//                print(input)
//            }
//            let input = availableInputs!.count > 0 ? availableInputs![1] : availableInputs![0]
//            try recordingSession.setPreferredInput(input)
            
            recordingSession.requestRecordPermission() { [unowned self] allowed in
                DispatchQueue.main.async {
                    if allowed {
                        self.recordingButton.isEnabled = true
                    } else {
                        // failed to record!
                    }
                }
            }
        } catch let error {
            print(error)
        }
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    @IBAction func onRecording(_ sender: Any) {
        switch status {
        case .Recording:
            if audioRecorder == nil {
                startRecording()
            } else {
                finishRecording(success: true)
            }
        case .SendToAppleTV:
            sendToAppleTV()
        }
    }
    
    
    func getDocumentsDirectory() -> URL {
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        let documentsDirectory = paths[0]
        return documentsDirectory
    }
    
    
    func startRecording() {
        let audioFilename = getDocumentsDirectory().appendingPathComponent("recording.m4a")
        
        let settings = [
            AVFormatIDKey: Int(kAudioFormatMPEG4AAC),
            AVSampleRateKey: 12000,
            AVNumberOfChannelsKey: 1,
            AVEncoderAudioQualityKey: AVAudioQuality.high.rawValue
        ]
        
        do {
            try recordingSession.overrideOutputAudioPort(AVAudioSessionPortOverride.none)
            
            audioRecorder = try AVAudioRecorder(url: audioFilename, settings: settings)
            audioRecorder.delegate = self
            audioRecorder.record()
            
            recordingButton.setTitle("Stop Recording", for: .normal)
            recordingButton.setTitleColor(.orange, for: .normal)
        } catch {
            finishRecording(success: false)
        }
    }
    
    
    func finishRecording(success: Bool) {
        audioRecorder.stop()
        audioRecorder = nil
        
        if success {
            status = RecPlayStatus.SendToAppleTV
            recordingButton.setTitle("Send to AppleTV", for: .normal)
            recordingButton.setTitleColor(.blue, for: .normal)
        } else {
            status = RecPlayStatus.Recording
            recordingButton.setTitle("(KO) Start New Recording", for: .normal)
            recordingButton.setTitleColor(.red, for: .normal)
            // recording failed :(
        }
    }
    
    
    func sendToAppleTV() {
        let audioFilename = getDocumentsDirectory().appendingPathComponent("recording.m4a")
        
        do {
            var socket = try Socket.create(family: .inet6)
            //socket.connect(to: <#T##String#>, port: <#T##Int32#>)
            
            
            
            
            

            
            
            //try recordingSession.overrideOutputAudioPort(AVAudioSessionPortOverride.speaker)
            
            try audioPlayer = AVAudioPlayer(contentsOf: audioFilename)
            audioPlayer.delegate = self
            audioPlayer.prepareToPlay()
            audioPlayer.play()
        } catch let error {
            print(error)
        }
    }
    
    
    func audioPlayerDidFinishPlaying(_ player: AVAudioPlayer, successfully flag: Bool) {
        status = RecPlayStatus.Recording
        recordingButton.setTitle("Start New Recording", for: .normal)
        recordingButton.setTitleColor(.red, for: .normal)
    }
    
    
    func audioPlayerDecodeErrorDidOccur(_ player: AVAudioPlayer, error: Error?) {
        if let e = error {
            print(e)
        }
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
        print("adding a service")
        self.services.append(netService)
        if !moreServicesComing {
            updateServiceInfo()
        }
    }
    
    func updateServiceInfo() {
        for service in self.services {
            if service.port == -1 {
                print("service \(service.name) of type \(service.type) not yet resolved")
                service.delegate = self
                service.resolve(withTimeout:10)
            } else {
                print("service \(service.name) of type \(service.type), port \(service.port), addresses \(String(describing: service.addresses))")
            }
        }
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



extension ViewController: NetServiceDelegate {
    func netServiceDidResolveAddress(_ netService: NetService) {
        print("resolved service \(netService.name) of type \(netService.type), port \(netService.port), addresses \(String(describing: netService.addresses))")
    }
}
