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
        updateRecordStatus(false)
    }
    
    @IBAction func recordAudio(_ sender: UIButton) {
        
        updateRecordStatus(true)
        
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
        updateRecordStatus(false)
        audioRecorder.stop()
        let audioSession = AVAudioSession.sharedInstance()
        try! audioSession.setActive(false)
        
    }
    
    //MARK: - Update Record status
    func updateRecordStatus(_ recordStatus:Bool){
        stopRecordButton.isEnabled = recordStatus
        recordButton.isEnabled = !recordStatus
        recordingLable.text = recordStatus ? "Recording in Progress" :"Tap to record"
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

