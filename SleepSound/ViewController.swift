//
//  ViewController.swift
//  SleepSound
//
//  Created by Tom Seward on 3/7/15.
//  Copyright (c) 2015 Tom Seward. All rights reserved.
//

import UIKit
import AVFoundation

class ViewController: UIViewController {
    
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
        var currentTimeParts = getDateComponents(NSDate())
        var pickTimeParts = getDateComponents(pickTime)
        while (currentTimeParts["hour"] != pickTimeParts["hour"]) && (currentTimeParts["minutes"] != pickTimeParts["minutes"]){
            println("playing sound")
            audioPlayer.play()
            currentTimeParts = getDateComponents(NSDate())
        }
        println("restraints match")
        
        
        
        
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
}

