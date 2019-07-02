//
//  RecordSoundsViewController.swift
//  PitchPerfect
//
//  Created by Albandry  on 24/03/2019.
//  Copyright © 2019 Udacity. All rights reserved.
//

import UIKit
import AVFoundation

class RecordSoundsViewController: UIViewController, AVAudioRecorderDelegate {

    var audioRecorder: AVAudioRecorder!

    @IBOutlet weak var stopRecordingButton: UIButton!
    @IBOutlet weak var recordButton: UIButton!
    @IBOutlet weak var recordingLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        stopRecordingButton.isEnabled=false
        // Do any additional setup after loading the view, typically from a nib.
    }
    
   // override func viewWillAppear(_ animated: Bool) {
        
   // }
    
    func EnDisEable(_ record: Bool){
        stopRecordingButton.isEnabled = record
        recordButton.isEnabled = !record
        if !record {
            recordingLabel.text = "tap to record "}
        else {recordingLabel.text = "Recording in Progress" }
      
    }


    
    @IBAction func recordAudio(_ sender: Any) {
   EnDisEable(true)
         
        let dirPath = NSSearchPathForDirectoriesInDomains(.documentDirectory,.userDomainMask, true)[0] as String
        let recordingName = "recordedVoice.wav"
        let pathArray = [dirPath, recordingName]
        let filePath = URL(string: pathArray.joined(separator: "/"))
        
        let session = AVAudioSession.sharedInstance()
        try! session.setCategory(AVAudioSession.Category.playAndRecord, mode: AVAudioSession.Mode.default, options: AVAudioSession.CategoryOptions.defaultToSpeaker)
        
        try! audioRecorder = AVAudioRecorder(url: filePath!, settings: [:])
        audioRecorder.delegate=self
        audioRecorder.isMeteringEnabled = true
        audioRecorder.prepareToRecord()
        audioRecorder.record()
        
    }
    
    @IBAction func stopRecording(_ sender: Any) {
       EnDisEable(false)
         audioRecorder.stop()
        let audioSession = AVAudioSession.sharedInstance()
        try! audioSession.setActive(false)
        
}
 
    func audioRecorderDidFinishRecording(_ recorder: AVAudioRecorder, successfully flag: Bool) {
        if flag{
            performSegue(withIdentifier: "stopRecording", sender:audioRecorder.url)}
        else{
            print("Recording was not successful")
        }
        
    }
   
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let stopRe: String = "stopRecording"
        if segue.identifier == stopRe{
            let playSoundsVC = segue.destination as! PlaySoundsViewController
            let recordedAudioURL = sender as! URL
            playSoundsVC.recordedAudioURL = recordedAudioURL
        }
    }
    
}

