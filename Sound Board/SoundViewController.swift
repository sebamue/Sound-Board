//
//  SoundViewController.swift
//  Sound Board
//
//  Created by Sebastian Muehl on 1/30/17.
//  Copyright © 2017 Sebastian. All rights reserved.
//

import UIKit
import AVFoundation

class SoundViewController: UIViewController {
    
    @IBOutlet weak var recordButton: UIButton!
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var playButton: UIButton!
    
    @IBOutlet weak var addButton: UIButton!
    
    var audioRecorder: AVAudioRecorder? = nil
    var audioPlayer: AVAudioPlayer? = nil
    var audioURL: URL?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        setupRecorder()
        playButton.isEnabled = false
        addButton.isEnabled = false
        
        //Add logo to Nav Bar
        
        let image = UIImage(named: "soundz_logo.png")
        let imageView = UIImageView(image: image)
        
        imageView.frame = CGRect(x: 0, y: 0, width: 80, height: 30)
        imageView.contentMode = .scaleAspectFit
        
        navigationItem.titleView = imageView
        
    
    }
    
    override func viewDidAppear(_ animated: Bool) {
        
        
    }
    
    //Setup for the audio recorder in this function
    func setupRecorder() {
        
        do {
            //Create an audio session
            let session = AVAudioSession.sharedInstance()
            
            //Select a session (here we use Play and Record)
            try session.setCategory(AVAudioSessionCategoryPlayAndRecord)
            
            //Sound goes through devices speakers, not the earpiece
            try session.overrideOutputAudioPort(.speaker)
            try session.setActive(true)
            
            //Create URL for the audio file
            
            //Get to the documents directory first
            let basePath:String = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).first!
            
            let pathComponents = [basePath, "audio.m4a"]
            audioURL = NSURL.fileURL(withPathComponents: pathComponents)!
            
            //This is to see the URL on the computer, in Terminal type: "open URL"
            print("**************")
            print(audioURL!)
            print("**************")
            //Create Settings for the AudioRecorder
            
            var settings : [String:AnyObject] = [:]
            settings[AVFormatIDKey] = Int(kAudioFormatMPEG4AAC) as AnyObject
            settings[AVSampleRateKey] = 44100.0 as AnyObject
            settings[AVNumberOfChannelsKey] = 2 as AnyObject
            
            //Create AudioRecorder object
            audioRecorder = try AVAudioRecorder(url: audioURL!,  settings: settings)
            audioRecorder!.prepareToRecord()
        }   //Catch the error as NSError, depends on what Error the function throws
        catch let error as NSError {
            print(error)
        }
    }
    
    @IBAction func recordTapped(_ sender: Any) {
        if audioRecorder!.isRecording {
            //Stop the recording
            audioRecorder?.stop()
            //Change button title to Record
            //recordButton.setTitle("Record", for: .normal)
            
            let image = UIImage(named: "Record.png")
            
            recordButton.setImage(image, for: .normal)
            
            playButton.isEnabled = true
            addButton.isEnabled = true
        } else {
            //Start recording
            audioRecorder?.record()
            //Change button title to stop
            let imageStop = UIImage(named: "Stop.png")
            
            //recordButton.setTitle("Stop", for: .normal)
            recordButton.setImage(imageStop, for: .normal)
        }
        
    }
    
    @IBAction func playTapped(_ sender: Any) {
        do {
            try audioPlayer = AVAudioPlayer(contentsOf: audioURL!)
            audioPlayer!.play()
        } catch {
            print("Something is wrong with the audioURL")
        }
        
    }
    
    
    @IBAction func addTapped(_ sender: Any) {
        
        let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        let sound = Sound(context:context)
        
        sound.name = nameTextField.text
        //Take what is in URL file and put it in Core Data
        sound.audio = NSData(contentsOf: audioURL!)
        
        (UIApplication.shared.delegate as! AppDelegate).saveContext()
        
        navigationController!.popViewController(animated: true)
        
    }
    
    
}
