//
//  RecordViewController.swift
//  PitchPerfect
//
//  Created by Vasanth Kodeboyina on 5/14/16.
//  Copyright © 2016 Anish Kodeboyina. All rights reserved.
//

import UIKit
import AVFoundation

class RecordSoundsViewController: UIViewController, AVAudioRecorderDelegate {

    @IBOutlet weak var recordingLabel: UILabel!
    @IBOutlet weak var stopRecordingButton: UIButton!
    @IBOutlet weak var recordButton: UIButton!
    
    var audioRecorder: AVAudioRecorder!
    let audioSession = AVAudioSession.sharedInstance()
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        stopRecordingButton.isEnabled = false
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    // MARK: - Record and Audio Buttons Pressed

    @IBAction func RecordAudioButtonPressed(_ sender: AnyObject)
    {
        print("Record Button is pressed.")
        recordingLabel.text = "Recording in progress"
        stopRecordingButton.isEnabled = true
        recordButton.isEnabled = false
        
        let dirPath = NSSearchPathForDirectoriesInDomains(.documentDirectory,.userDomainMask, true)[0] as String
        let recordingName = "recordedVoice.wav"
        let pathArray = [dirPath, recordingName]
        let filePath = URL.fileURL(withPathComponents: pathArray)
        
        try! audioSession.setCategory(AVAudioSessionCategoryPlayAndRecord)
        try! audioRecorder = AVAudioRecorder(url: filePath!, settings: [:])
        audioRecorder.delegate = self
        audioRecorder.isMeteringEnabled = true
        audioRecorder.prepareToRecord()
        audioRecorder.record()
    }

    @IBAction func stopRecordingButtonPressed(_ sender: AnyObject)
    {
        print("Recording has been stopped.")
        recordingLabel.text = "Tap to Record"
        recordButton.isEnabled = true
        stopRecordingButton.isEnabled = false
        audioRecorder.stop()
        print(audioRecorder.currentTime)
        try! audioSession.setActive(false)
    }
    
    
    // MARK: - Perform Segue
    
    func audioRecorderDidFinishRecording(_ recorder: AVAudioRecorder, successfully flag: Bool)
    {
        print("AVAudioRecorder Finished Recording ")
        if (flag) {
            self.performSegue(withIdentifier: "stopRecording", sender: audioRecorder.url)
        }else{
            print("Recorded audio saving is failed")
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?)
    {
        if (segue.identifier == "stopRecording")
        {
            let playsoundsVC = segue.destination as! playSoundViewController
            let recordedAudioURL = sender as! URL
            playsoundsVC.recordedAudioURL = recordedAudioURL
        }
    }
}

