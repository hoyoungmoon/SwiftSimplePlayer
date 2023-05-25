//
//  Video.swift
//  SwiftSimplePlayer
//
//  Created by Fanding Corp on 2023/05/24.
//

import Foundation
import UIKit
import AVKit
import AVFoundation
import MediaPlayer

class Video: UIView {
    var player: AVPlayer?
    var playerLayer: AVPlayerLayer?
    var playerViewController: AVPlayerViewController?
    var button: UIButton?
    var paused: Bool = false
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = .blue
        
        // video
        setupVideo()
        setupAVAudioSession()
        setupRemoteTransportControls()
        
        // controls
        button = UIButton(type: .system)
        button?.frame = CGRect(origin: CGPoint(x: self.bounds.midX - 30, y: self.bounds.midY - 30), size:CGSize(width: 60, height: 60))
        button?.setImage(UIImage(systemName: "play.fill"), for: .normal)
        button?.addTarget(self, action: #selector(buttonTapped), for: .touchUpInside)
        addSubview(button!)
    }
    
    @objc private func buttonTapped() {
        self.paused = !self.paused
        button?.setImage(self.paused ? UIImage(systemName: "play.fill") : UIImage(systemName: "pause.fill"), for: .normal)
        if(!self.paused){
            player?.play()
            setupNowPlaying()
        }else{
            player?.pause()
        }
      
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupVideo() {
        let url = NSURL(string: "https://commondatastorage.googleapis.com/gtv-videos-bucket/sample/BigBuckBunny.mp4")!
        player = AVPlayer(url: url as URL)
        playerLayer = AVPlayerLayer(player: player)
        playerLayer?.frame = self.bounds
        self.layer.addSublayer(playerLayer!)
    }
    
    func setupNowPlaying() {
        guard let playerItem:AVPlayerItem = player?.currentItem else {
            return
        }
        var nowPlayingInfo = [String : Any]()
        nowPlayingInfo[MPMediaItemPropertyTitle] = "My Test Movie"
        
        nowPlayingInfo[MPNowPlayingInfoPropertyElapsedPlaybackTime] = playerItem.currentTime().seconds
        nowPlayingInfo[MPMediaItemPropertyPlaybackDuration] = playerItem.asset.duration.seconds
        nowPlayingInfo[MPNowPlayingInfoPropertyPlaybackRate] = player?.rate

        // Set the metadata
        MPNowPlayingInfoCenter.default().nowPlayingInfo = nowPlayingInfo
    }
    
    private func setupAVAudioSession() {
        do {
            try AVAudioSession.sharedInstance().setCategory(.playback)
            try AVAudioSession.sharedInstance().setActive(true)
        } catch {
            print("AVAudioSession configuration failed: \(error)")
        }
    }
    
    private func setupRemoteTransportControls() {
        // Get the shared MPRemoteCommandCenter
        let commandCenter = MPRemoteCommandCenter.shared()
        
        // Add handler for Play Command
        commandCenter.playCommand.addTarget { [unowned self] event in
            if self.player?.rate == 0.0 {
                self.player?.play()
                return .success
            }
            return .commandFailed
        }

        // Add handler for Pause Command
        commandCenter.pauseCommand.addTarget { [unowned self] event in
            if self.player?.rate == 1.0 {
                self.player?.pause()
                return .success
            }
            return .commandFailed
        }
    }
    
    @objc private func playVideoFullScreen() {
        var viewController:UIViewController!
        
        // 일단 rootViewController에서 테스트
        let keyWindow:UIWindow! = UIApplication.shared.keyWindow
        viewController = keyWindow.rootViewController
        if viewController.children.count > 0
        {
            viewController = viewController.children.last
        }
        
        let playerViewController = AVPlayerViewController()
        playerViewController.player = player
        self.playerViewController = playerViewController
        
        viewController.present(playerViewController, animated: true) {
            playerViewController.player?.play()
        }
    }
}
