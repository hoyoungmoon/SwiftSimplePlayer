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
    var controls: UIButton = UIButton(type:.system)
    var paused: Bool = true
    var _source: VideoSource?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = .blue
        
        // background 재생
        setupAVAudioSession()
        
        // Notification
        NotificationCenter.default.addObserver(self, selector: #selector(handleEnterBackground), name: UIApplication.didEnterBackgroundNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(handleEnterForeground), name: UIApplication.willEnterForegroundNotification, object: nil)
    }
    
    @objc func buttonTapped() {
        setPaused(pause: !self.paused)
    }
    
    func setPaused(pause: Bool){
        self.paused = pause
        controls.setImage(self.paused ? UIImage(systemName: "play.fill") : UIImage(systemName: "pause.fill"), for: .normal)
        if !self.paused {
            player?.play()
            RemoteControls.shared.setupNowPlaying(video: self)
        } else {
            player?.pause()
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupVideo(url: String, source: VideoSource?) {
        self._source = source
        guard let url = NSURL(string: url) else{
            return
        }
        player = AVPlayer(url: url as URL)
        playerLayer = AVPlayerLayer(player: player)
        playerLayer?.frame = self.bounds
        self.layer.addSublayer(playerLayer!)
        
        // test controls
        controls = UIButton(type: .system)
        controls.frame = CGRect(origin: CGPoint(x: self.bounds.midX - 30, y: self.bounds.midY - 30), size:CGSize(width: 60, height: 60))
        controls.setImage(UIImage(systemName: "play.fill"), for: .normal)
        controls.addTarget(self, action: #selector(buttonTapped), for: .touchUpInside)
        addSubview(controls)
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
    
    @objc private func handleEnterBackground() {
        playerLayer?.player = nil
    }
    @objc private func handleEnterForeground() {
        if let player = player, let playerLayer = playerLayer {
            playerLayer.player = player
        }
    }
}
