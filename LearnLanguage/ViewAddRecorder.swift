//
//  ViewAddRecorder.swift
//  Language
//
//  Created by PIRATE on 11/16/16.
//  Copyright © 2016 PIRATE. All rights reserved.
//

import UIKit
import AVFoundation

class ViewAddRecorder: UIViewController {
    
    @IBOutlet weak var recordBtn: UIButton!
    @IBOutlet weak var playBtn: UIButton!
    @IBOutlet weak var titleRecorder: UITextField!
    @IBOutlet weak var timeRecorder: UILabel!
    @IBOutlet weak var btnDoneRecorder: UIButton!
    @IBOutlet weak var img_Left: UIImageView!
    @IBOutlet weak var img_Right: UIImageView!
    
    
    
    var timer = Timer()
    var startTime = TimeInterval()
    
    var soundRecorder : AVAudioRecorder!
    var soundPlayer : AVAudioPlayer!
    var session : AVAudioSession!
    let database = DataBase.sharedInstance
    var languageID: Int!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setBtn()
        checkTitleForRecord()
        //setupRecorder()
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
       
    }
    
    func currentTime() -> String {
        let date = NSDate()
//        let calendar = NSCalendar.current
//        let hour = calendar.component(.hour, from: date as Date)
//        let minutes = calendar.component(.minute, from: date as Date)
//        let seconds = calendar.component(.second, from: date as Date)
        
        return "\(date)"
    }
    
    func setBtn(){
        btnDoneRecorder.layer.cornerRadius = 30
        recordBtn.backgroundColor = UIColor.clear
        playBtn.backgroundColor = UIColor.clear
        img_Left.image = UIImage(named: "record")
        img_Right.image = UIImage(named: "play")
    }
    
    func getCacheDirectory() -> URL {
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        let documentsDirectory = paths[0]
        return documentsDirectory
    }
    func getPathSound() -> URL {
        let currentTime = self.currentTime()
        let path = getCacheDirectory().appendingPathComponent("\(titleRecorder.text!)-\(currentTime).m4a")
        return path
    }
    func checkTitleForRecord(){
        if titleRecorder.text == "" {
            recordBtn.isEnabled = false
            playBtn.isEnabled = false
            img_Left.alpha = 0.5
            img_Right.alpha = 0.5
        }
    }
    
    func setupRecorder() {
        //Request permission
        session = AVAudioSession.sharedInstance()
        
        do {
            try session.setCategory(AVAudioSessionCategoryPlayAndRecord, with: .defaultToSpeaker)
            try session.setActive(true)
            
            session.requestRecordPermission(){
                [unowned self] allowed in
                DispatchQueue.main.async {
                    if allowed {
                        // Microphone allowed, do what you like!
                        print("Mic OK")
                    } else {
                        // User denied microphone. Tell them off!
                        print("not mic")
                    }
                }
            }
            
            let recordSettings = [AVFormatIDKey: Int(kAudioFormatMPEG4AAC),
                                  AVSampleRateKey: 44100,
                                  AVNumberOfChannelsKey: 2,
                                  AVEncoderAudioQualityKey: AVAudioQuality.high.rawValue] as [String : Any]
            
            soundRecorder = try AVAudioRecorder(url: getPathSound(), settings: recordSettings)
            soundRecorder?.delegate = self
            soundRecorder?.record()
        } catch let error as NSError {
            print(error.localizedDescription)
        }
    }
    
    func start(){
        if (!timer.isValid) {
            timer = Timer.scheduledTimer(timeInterval: 0.1, target: self, selector: #selector(updateTime), userInfo: nil, repeats: true)
            startTime = Date.timeIntervalSinceReferenceDate
        }
    }
    func stop(){
        timer.invalidate()
    }
    
    func updateTime()
    {
        
        let currentTime = Date.timeIntervalSinceReferenceDate
        var elapsedTime: TimeInterval = currentTime - startTime
        
        let minutes = UInt8(elapsedTime/60.0)
        elapsedTime = elapsedTime - TimeInterval(minutes) * 60
        
        let seconds = UInt8(elapsedTime)
        elapsedTime = elapsedTime - TimeInterval(seconds)
        
        let strMinutes = String(format: "%02d", minutes)
        let strSeconds = String(format: "%02d", seconds)
        
        timeRecorder.text = "\(strMinutes):\(strSeconds)"

    }
 
    
    @IBAction func startRecorder(_ sender: UIButton) {
        setupRecorder()

        if sender.titleLabel?.text == "Record" {
            
            soundRecorder.record()
            sender.setTitle("Stop", for: .normal)
            img_Left.image = UIImage(named: "stop")
            playBtn.isEnabled = false
            start()
        } else {
            
            soundRecorder.stop()
            sender.setTitle("Record", for: .normal)
            img_Left.image = UIImage(named: "record")
            playBtn.isEnabled = true
            stop()
        }
    }
    
    @IBAction func playSound(_ sender: UIButton) {
        soundPlayer = try! AVAudioPlayer(contentsOf: getPathSound())
        if sender.titleLabel?.text == "Play" {
            
            sender.setTitle("Stop", for: .normal)
            recordBtn.isEnabled = false
            img_Right.image = UIImage(named: "stop")
            soundPlayer.delegate = self
            soundPlayer.volume = 1.0
            soundPlayer.play()
        } else {
            soundPlayer.stop()
            sender.setTitle("Play", for: .normal)
            img_Right.image = UIImage(named: "play")
            recordBtn.isEnabled = true
        }
    }

    func saveToDatabase(){
        let currentTime = self.currentTime()
   //     print(currentTime)
        database.insertDataBase("Record", dict: ["RecordName" : "\(titleRecorder.text!)-\(currentTime)", "LanguageID":"\(languageID!)"])
    }
    
    @IBAction func actDoneRecorder(_ sender: Any) {
        saveToDatabase()
        
        _ = self.navigationController?.popViewController(animated: true)
    }
    
   
}






    extension ViewAddRecorder : AVAudioRecorderDelegate {
        
        func audioRecorderDidFinishRecording(_ recorder: AVAudioRecorder,
                                             successfully flag: Bool) {
            
            playBtn.isEnabled = true
            if !flag {
                soundRecorder.stop()
            }
        }
            
        func audioRecorderEncodeErrorDidOccur(_ recorder: AVAudioRecorder,
                                              error: Error?) {
            
            if let e = error {
                print("\(e.localizedDescription)")
            }
        }
        
    }
    
    // MARK: AVAudioPlayerDelegate
    extension ViewAddRecorder : AVAudioPlayerDelegate {
        func audioPlayerDidFinishPlaying(_ player: AVAudioPlayer, successfully flag: Bool) {

            recordBtn.isEnabled = true
            playBtn.setTitle("Play", for: .normal)
        }
        
        func audioPlayerDecodeErrorDidOccur(_ player: AVAudioPlayer, error: Error?) {
            if let e = error {
                print("\(e.localizedDescription)")
            }
        }
        
    }

    //MARK: UITextFieldDelegate
extension ViewAddRecorder: UITextFieldDelegate {
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        recordBtn.isEnabled = true
        playBtn.isEnabled = true
        img_Left.alpha = 1
        img_Right.alpha = 1
        
        return true
    }

}



