//
//  ViewController.swift
//  SwiftSimplePlayer
//
//  Created by Fanding Corp on 2023/05/22.
//
import Foundation
import UIKit
import AVKit
import AVFoundation
import MediaPlayer

class ViewController: UIViewController {
    var player: AVPlayer?
    var audioPlayer: AVAudioPlayer!
    var playerViewController: AVPlayerViewController?
    var playerLayer: AVPlayerLayer?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupVideo()
        
    }
    
    private func setupVideo() {
        //        let url = NSURL(string: "https://www.soundhelix.com/examples/mp3/SoundHelix-Song-1.mp3")!
        let Video1 = Video(frame: CGRect(x: 0, y: 200, width: 300, height: 150))
        let Video2 = Video(frame: CGRect(x: 0, y: 400, width: 300, height: 150))
        Video1.setupVideo(url: "https://commondatastorage.googleapis.com/gtv-videos-bucket/sample/BigBuckBunny.mp4", source:VideoSource(["title":"TESTA"]))
        Video2.setupVideo(url: "http://commondatastorage.googleapis.com/gtv-videos-bucket/sample/ElephantsDream.mp4", source:VideoSource(["title":"TESTB"]))
        view.addSubview(Video1)
        view.addSubview(Video2)
        
        NotificationCenter.default.addObserver(self, selector: #selector(handleEnterBackground), name: UIApplication.didEnterBackgroundNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(handleEnterForeground), name: UIApplication.willEnterForegroundNotification, object: nil)
    }
    
    @objc private func handleEnterBackground() {}
    @objc private func handleEnterForeground() {}
}

