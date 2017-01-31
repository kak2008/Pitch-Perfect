//
//  playSoundViewController.swift
//  PitchPerfect
//
//  Created by Vasanth Kodeboyina on 5/16/16.
//  Copyright © 2016 Anish Kodeboyina. All rights reserved.
//

import UIKit
import AVFoundation

class playSoundViewController: UIViewController {
    
    @IBOutlet weak var chipmunkButton: UIButton!
    @IBOutlet weak var vanderButton: UIButton!
    @IBOutlet weak var echoButton: UIButton!
    @IBOutlet weak var rabitButton: UIButton!
    @IBOutlet weak var reverbButton: UIButton!
    @IBOutlet weak var snailButton: UIButton!
    @IBOutlet weak var stopButton: UIButton!
    
    @IBOutlet weak var chipmunkSlider: UISlider!
    @IBOutlet weak var darthvanderSlider: UISlider!
    @IBOutlet weak var echoSlider: UISlider!
    @IBOutlet weak var rabitSlider: UISlider!
    @IBOutlet weak var reverbSlider: UISlider!
    @IBOutlet weak var snailSlider: UISlider!
    
    @IBOutlet weak var darthvanderRateLabel: UILabel!
    @IBOutlet weak var chipmunkRateLabel: UILabel!
    @IBOutlet weak var echoRateLabel: UILabel!
    @IBOutlet weak var rabitRateLabel: UILabel!
    @IBOutlet weak var reverbRatelabel: UILabel!
    @IBOutlet weak var snailRateLabel: UILabel!
    @IBOutlet weak var recordedAudioDuration: UILabel!
        
    // MARK: Slider Actions
        
    @IBAction func playAudioRateForSlider(_ sender: UISlider)
    {
        switch (SliderType(rawValue: sender.tag)!) {
        case .chipmunkSlider:
            let chipmunkSliderCurrentValue = lroundf(sender.value)
            chipmunkRateLabel.text = "Rate: \(chipmunkSliderCurrentValue)/5 "
        case .vaderSlider:
            let darthvanderSliderCurrentValue = lroundf(sender.value)
            darthvanderRateLabel.text = "Rate: \(darthvanderSliderCurrentValue)/5"
        case .echoSlider:
            let echoSliderCurrentValue = lroundf(sender.value)
            echoRateLabel.text = "Rate: \(echoSliderCurrentValue)/5"
        case .rabitSlider:
            let rabitSliderCurrentValue = lroundf(sender.value)
            rabitRateLabel.text = "Rate: \(rabitSliderCurrentValue)/5"
        case .reverbSlider:
            let reverbSliderCurrentValue = lroundf(sender.value)
            reverbRatelabel.text = "Rate: \(reverbSliderCurrentValue)/5"
        case .snailSlider:
            let snailSliderCurrentValue = lroundf(sender.value)
            snailRateLabel.text = "Rate: \(snailSliderCurrentValue)/5"
        }
    }
    
    
    // MARK: Play Sound Button Actions

    @IBAction func playSoundForButton(_ sender: UIButton){
        print("Play sound button pressed.")
        switch (ButtonType(rawValue: sender.tag)!) {
        case .chipmunk:
            playSound(rate: chipmunkSlider.value, pitch: 1000, echo: false, reverb: false)
        case .vader:
            playSound(rate: darthvanderSlider.value, pitch: -1000, echo: false, reverb: false)
        case .echo:
            playSound(rate: echoSlider.value, pitch: 0, echo: true, reverb: false)
        case .rabit:
            playSound(rate: rabitSlider.value, pitch: 0, echo: false, reverb: false)
        case .reverb:
            playSound(rate: reverbSlider.value, pitch: 0, echo: false, reverb: true)
        case .snail:
            playSound(rate: snailSlider.value, pitch: 0, echo: false, reverb: false)
        }
        configureUI(.playing)
    }
    
    @IBAction func stopButtonPressed(_ sender: UIButton)
    {
        print("stop button pressed.")
        stopAudio()
    }
    
    var recordedAudioURL: URL!
    
    var audioFile: AVAudioFile!
    var audioEngine: AVAudioEngine!
    var audioPlayerNode: AVAudioPlayerNode!
    var stopTimer: Timer!
    
    var duration: TimeInterval!
    
    enum ButtonType: Int {case chipmunk = 0, vader,echo,rabit,reverb,snail}
    
    enum SliderType: Int {case chipmunkSlider = 6, vaderSlider, echoSlider, rabitSlider, reverbSlider, snailSlider}
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        setupAudio()
        rateAudioLabelsUpdate()
    }
 
    override func viewWillAppear(_ animated: Bool) {
        configureUI(.notPlaying)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        stopAudio()
    }
    
    
    // MARK: Audio Duration and Rate update
    
    func rateAudioLabelsUpdate()
    {
        
        do
        {
            let avAudioPlayer = try AVAudioPlayer (contentsOf:recordedAudioURL)
            duration = avAudioPlayer.duration
            let ms  = Int((duration.truncatingRemainder(dividingBy: 1))*1000)
            let sec = Int(duration.truncatingRemainder(dividingBy: 60))
            let minutes = Int(duration / 60) % 60
            let hours = Int(duration / 3600)
            recordedAudioDuration.text = (NSString(format: "Dur: %0.2d:%0.2d:%0.2d.%0.3d",hours,minutes,sec,ms)) as String
        }
        catch{
            print(error)
        }
        
        chipmunkRateLabel.text = "Rate: \(lroundf(chipmunkSlider.value))/5"
        darthvanderRateLabel.text = "Rate: \(lroundf(darthvanderSlider.value))/5"
        echoRateLabel.text = "Rate: \(lroundf(echoSlider.value))/5"
        rabitRateLabel.text = "Rate: \(lroundf(rabitSlider.value))/5"
        snailRateLabel.text = "Rate: \(lroundf(snailSlider.value))/5"
        reverbRatelabel.text = "Rate: \(lroundf(reverbSlider.value))/5"
        
    }

}
