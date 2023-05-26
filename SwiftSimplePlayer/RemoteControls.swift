//
//  RemoteControls.swift
//  SwiftSimplePlayer
//
//  Created by Fanding Corp on 2023/05/25.
//

import Foundation
import AVFoundation
import MediaPlayer
class RemoteControls {
    static let shared = RemoteControls()
    
    private var video: Video?
    private var player: AVPlayer?
    // todo: Commands 타입별로 처리 필요
    private var playCommand: MPRemoteCommand?
    private var pauseCommand: MPRemoteCommand?
    
    private init() {}
    
    func setupNowPlaying(video: Video) {
        self.video = video
        self.player = video.player
        guard let playerItem:AVPlayerItem = player?.currentItem else {
            return
        }
        var nowPlayingInfo = [String : Any]()
        nowPlayingInfo[MPMediaItemPropertyTitle] = video._source?.title
        nowPlayingInfo[MPNowPlayingInfoPropertyElapsedPlaybackTime] = playerItem.currentTime().seconds
        nowPlayingInfo[MPMediaItemPropertyPlaybackDuration] = playerItem.asset.duration.seconds
        nowPlayingInfo[MPNowPlayingInfoPropertyPlaybackRate] = self.player?.rate
        MPNowPlayingInfoCenter.default().nowPlayingInfo = nowPlayingInfo
        
        setupRemoteCommands()
    }
    
    func setupRemoteCommands() {
        let commandCenter = MPRemoteCommandCenter.shared()
        commandCenter.playCommand.removeTarget(playCommand)
        commandCenter.pauseCommand.removeTarget(pauseCommand)
        
        
        playCommand = commandCenter.playCommand.addTarget { [unowned self] event in
            if self.player?.rate == 0.0 {
                self.video?.setPaused(pause: false)
                return .success
            }
            return .commandFailed
        } as? MPRemoteCommand
        
        pauseCommand = commandCenter.pauseCommand.addTarget { [unowned self] event in
            if self.player?.rate == 1.0 {
                self.video?.setPaused(pause: true)
                return .success
            }
            return .commandFailed
        } as? MPRemoteCommand
    }
}
