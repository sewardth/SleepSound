//
//  ViewController.swift
//  SleepSound
//
//  Created by Tom Seward on 3/7/15.
//  Copyright (c) 2015 Tom Seward. All rights reserved.
//

import UIKit
import AVFoundation

class ViewController: UIViewController, AVAudioPlayerDelegate {
    
    var audioPlayer:AVAudioPlayer!
    var pickTime = NSDate()
    
   
    @IBOutlet weak var playButton: UIButton!
    @IBOutlet weak var stopButton: UIButton!
    @IBOutlet weak var datePicker: UIDatePicker!
    

    override func viewDidLoad() {
        super.viewDidLoad()
        playButton.hidden = false
        stopButton.hidden = true
        if  var filePath = NSBundle.mainBundle().pathForResource("red_noise", ofType: "wav")
        {
            var filePathUrl = NSURL.fileURLWithPath(filePath)
            audioPlayer = AVAudioPlayer(contentsOfURL: filePathUrl, error: nil)
        }
            
        else
        {
            println("the file path is empty")
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


    @IBAction func playSound(sender: UIButton) {
        playButton.hidden = true
        stopButton.hidden = false
        let fileDuration = audioPlayer.duration
        audioPlayer.numberOfLoops = calculateLoops(Int(fileDuration))
        audioPlayer.delegate = self
        audioPlayer.play()
    }
    

    @IBAction func getDate(sender: UIDatePicker) {
        pickTime = sender.date
    }
    
    @IBAction func stopSound(sender: UIButton) {
        playButton.hidden = false
        stopButton.hidden = true
        audioPlayer.stop()
    }
    
    func getDateComponents (date:NSDate)->Dictionary<String, Int>!{
        let calendar = NSCalendar.currentCalendar()
        let components = calendar.components(.CalendarUnitHour | .CalendarUnitMinute, fromDate:  date)
        let timeParts = ["hour":components.hour, "minutes":components.minute]
        return timeParts
        
    }
    
    func calculateLoops(fileDuration :Int)->Int{
        let currentTimeParts = getDateComponents(NSDate())
        let pickTimeParts = getDateComponents(pickTime)
        var hours: Int
        var minutes: Int
        
        if pickTimeParts["hour"] < currentTimeParts["hour"]
        {
            hours = (24 - currentTimeParts["hour"]!) + pickTimeParts["hour"]!
        }
        else
        {
            hours = pickTimeParts["hour"]! - currentTimeParts["hour"]!
        }
        
        if pickTimeParts["minutes"] >= currentTimeParts["minutes"]
        {
            minutes = pickTimeParts["minutes"]! - currentTimeParts["minutes"]!
        }
        else
        {
            minutes = (60 - currentTimeParts["minutes"]!) + pickTimeParts["minutes"]!
        }
        
        let totalDuration = (hours * 60 * 60) + (minutes * 60)
        let loops: Int = totalDuration / fileDuration
        
        return loops
    }
    
    func audioPlayerDidFinishPlaying(audioPlayer: AVAudioPlayer!, successfully flag: Bool)
    {
        stopButton.hidden = true
        playButton.hidden = false
    }
    

}

