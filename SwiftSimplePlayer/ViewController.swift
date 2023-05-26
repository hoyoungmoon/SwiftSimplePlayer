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
        view.addSubview(Video(frame: CGRect(x: 0, y: 400, width: 300, height: 150)))
        view.addSubview(Video(frame: CGRect(x: 0, y: 200, width: 300, height: 150)))
        
        NotificationCenter.default.addObserver(self, selector: #selector(handleEnterBackground), name: UIApplication.didEnterBackgroundNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(handleEnterForeground), name: UIApplication.willEnterForegroundNotification, object: nil)
    }
    
    @objc private func handleEnterBackground() {}
    @objc private func handleEnterForeground() {}
}

