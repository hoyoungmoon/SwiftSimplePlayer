//
//  ViewController.swift
//  SwiftSimplePlayer
//
//  Created by Fanding Corp on 2023/05/22.
//

import UIKit
import AVKit
import AVFoundation

class ViewController: UIViewController {
    var player: AVPlayer?
    var audioPlayer: AVAudioPlayer!
    var playerViewController: AVPlayerViewController?
    var playerLayer: AVPlayerLayer?

    @IBAction func btnPlayFullScreen(_ sender: UIButton) {
        playVideoFullScreen()
    }
    @IBAction func btnPlay(_ sender: UIButton) {
        player?.play()
    }
    @IBAction func btnPause(_ sender: UIButton) {
        player?.pause()
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        setupAVAudioSession()
        setupVideo()
        
    }
    
    private func setupVideo() {
//        let url = NSURL(string: "https://www.soundhelix.com/examples/mp3/SoundHelix-Song-1.mp3")!
        let url = NSURL(string: "https://commondatastorage.googleapis.com/gtv-videos-bucket/sample/BigBuckBunny.mp4")!
        player = AVPlayer(url: url as URL)
        playerLayer = AVPlayerLayer(player: player)
        playerLayer?.frame = view.bounds
        view.layer.addSublayer(playerLayer!)
        
        NotificationCenter.default.addObserver(self, selector: #selector(handleEnterBackground), name: UIApplication.didEnterBackgroundNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(handleEnterForeground), name: UIApplication.willEnterForegroundNotification, object: nil)
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(playVideoFullScreen))
        view.addGestureRecognizer(tapGesture)
    }
    
    private func setupAVAudioSession() {
        do {
            try AVAudioSession.sharedInstance().setCategory(.playback)
            try AVAudioSession.sharedInstance().setActive(true)
        } catch {
            print("AVAudioSession configuration failed: \(error)")
        }
    }
    
    @objc private func playVideoFullScreen() {
        let playerViewController = AVPlayerViewController()
        playerViewController.player = player
        self.playerViewController = playerViewController
        
        present(playerViewController, animated: true) {
            playerViewController.player?.play()
        }
    }
    
    @objc private func handleEnterBackground() {
        playerViewController?.player = nil
        playerLayer?.player = nil
    }
    @objc private func handleEnterForeground() {
        playerViewController?.player = player
        playerLayer?.player = player
    }
}

