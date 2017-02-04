//
//  ViewController.swift
//  Sound Board
//
//  Created by Sebastian Muehl on 1/30/17.
//  Copyright © 2017 Sebastian. All rights reserved.
//

import UIKit
import AVFoundation


class ViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet weak var soundTableView: UITableView!
    
    var sounds : [Sound] = []
    var audioPlayer: AVAudioPlayer? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        soundTableView.dataSource = self
        soundTableView.delegate = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        
        do {
            try sounds = context.fetch(Sound.fetchRequest())
            soundTableView.reloadData()
        } catch{}
    
    }
    
    //Need this to customize the nav bar title
    override func viewDidAppear(_ animated: Bool) {
        
        //Add logo to Nav Bar
        
        let image = UIImage(named: "soundz_logo.png")
        let imageView = UIImageView(image: image)
        
        imageView.frame = CGRect(x: 0, y: 0, width: 80, height: 30)
        imageView.contentMode = .scaleAspectFit
        
        navigationItem.titleView = imageView
        
        
            }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell()
        let sound = sounds[indexPath.row]
        
        cell.textLabel?.text = sound.name
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return sounds.count
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let sound = sounds[indexPath.row]
        do {
            audioPlayer = try AVAudioPlayer(data: sound.audio! as Data)
        } catch {}
        
        audioPlayer!.play()
        tableView.deselectRow(at: indexPath, animated: true)
        
    }
    
    //Swipe to delete
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            //Grab sound
            let sound = sounds[indexPath.row]
            //Grab context
            let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
            
            context.delete(sound)
            (UIApplication.shared.delegate as! AppDelegate).saveContext()
            
            //Reload the table
            do {
                try sounds = context.fetch(Sound.fetchRequest())
                soundTableView.reloadData()
            } catch{}
        }
    }
    
}
