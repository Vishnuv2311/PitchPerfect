//
//  RecordsSoundsViewController.swift
//  PitchPerfect
//
//  Created by Vishnu V on 03/06/22.
//

import UIKit
import AVFoundation

class RecordsSoundsViewController: UIViewController , AVAudioRecorderDelegate{

    var audioRecorder: AVAudioRecorder!
    
    @IBOutlet weak var recordingLable: UILabel!
    
    @IBOutlet weak var recordButton: UIButton!
    
    @IBOutlet weak var stopRecordButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        print("viewDidLoad")
        stopRecordButton.isEnabled = false
        recordingLable.text = "Tap to record"
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        print("viewWillAppear")
    }

    @IBAction func recordAudio(_ sender: UIButton) {
        stopRecordButton.isEnabled = true
        recordButton.isEnabled = false
        recordingLable.text = "Recording in Progress"
        
        let dirPath = NSSearchPathForDirectoriesInDomains(.documentDirectory,.userDomainMask, true)[0] as String
            let pathArray = [dirPath, "recordedVoice.wav"]
            let filePath = URL(string: pathArray.joined(separator: "/"))
        

            let session = AVAudioSession.sharedInstance()
            try! session.setCategory(AVAudioSession.Category.playAndRecord, mode: AVAudioSession.Mode.default, options: AVAudioSession.CategoryOptions.defaultToSpeaker)

            try! audioRecorder = AVAudioRecorder(url: filePath!, settings: [:])
        audioRecorder.delegate = self
            audioRecorder.isMeteringEnabled = true
            audioRecorder.prepareToRecord()
            audioRecorder.record()
    }
    
    @IBAction func stopRecording(_ sender: UIButton) {
        stopRecordButton.isEnabled = false
        recordButton.isEnabled = true
        recordingLable.text = "Tap to record"
        
        audioRecorder.stop()
        let audioSession = AVAudioSession.sharedInstance()
        try! audioSession.setActive(false)
    
    }
    
    //MARK: - Audio Recorder Delegate
    
    func audioRecorderDidFinishRecording(_ recorder: AVAudioRecorder, successfully flag: Bool) {
        if flag {
            performSegue(withIdentifier: "stopRecording", sender: audioRecorder.url)
        }else{
            print("recording was not sucessful")
        }
    }
    
    override func prepare(
        for segue: UIStoryboardSegue,
        sender: Any?
    ){
        if segue.identifier == "stopRecording" {
            let recordSoundVC = segue.destination as! PlaySoundsViewController
            let recordedAudiouURL = sender as! URL
            recordSoundVC.recordedAudioURL = recordedAudiouURL
        }
    }
}

