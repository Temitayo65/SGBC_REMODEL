//
//  SermonAudioPlayerViewController.swift
//  SGBC_REMODEL
//
//  Created by ADMIN on 14/09/2022.
//

import UIKit
import SwiftAudioPlayer
import AVFAudio
import AVFoundation
import AVKit


public var globalPlayerState: SAPlayingStatus = .ended
public var gloabalAudioURL = ""

class SermonAudioPlayerViewController: UIViewController {
    var sermonImageURL: String?
    var sermonTitle: String!
    var preacherTitle: String!
    var sermonAudioURL: String!

    
    @IBOutlet var sermonImageView: UIImageView!
    @IBOutlet var sermonTitleLabel: UILabel!
    @IBOutlet var preacherTitleLabel: UILabel!
    @IBOutlet var sermonProgressView: UIProgressView!
    @IBOutlet var sermonPlayButton: UIButton!
    @IBOutlet var playerSlider: UISlider!
    @IBOutlet var sermonFastForwardButton: UIButton!
    @IBOutlet var sermonRewindButton: UIButton!
    
    @IBOutlet var currentTimeStampLabel: UILabel!
    @IBOutlet var durationLabel: UILabel!
    @IBOutlet var sermonOptionButtonLabel: UIButton!
    // From the example file
    var isDownloading: Bool = false
    var isStreaming: Bool = false
    var beingSeeked: Bool = false
    var loopEnabled = false
    
    var downloadId: UInt?
    var durationId: UInt?
    var bufferId: UInt?
    var playingStatusId: UInt?
    var queueId: UInt?
    var elapsedId: UInt?

    var duration: Double = 0.0
    var playbackStatus: SAPlayingStatus = .paused
    
    var lastPlayedAudioIndex: Int?
    
    var isPlayable: Bool = false {
        didSet {
            if isPlayable {
                sermonPlayButton.isEnabled = true
                sermonRewindButton.isEnabled = true
                sermonFastForwardButton.isEnabled = true
            } else {
                sermonPlayButton.isEnabled = false
                sermonRewindButton.isEnabled = false
                sermonFastForwardButton.isEnabled = false
            }
        }
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.navigationBar.topItem?.backButtonTitle = ""
        sermonTitleLabel.text = sermonTitle
        preacherTitleLabel.text = preacherTitle
        if let sermonImageURL = sermonImageURL {
            sermonImageView.load(url: URL(string: sermonImageURL) ?? URL(string: "https://sgbc.ams3.digitaloceanspaces.com/Images/March-2021/The-Disobedience-of-the-First-Adam.jpg?AWSAccessKeyId=C663TNSAPB6NR24LMYTF&Expires=1663194626&Signature=Lsq7scPvzVMUx%2FuIZlKNCKSKZ64%3D")!) // Tell Dara that he missed the link for one of these
            
            sermonImageView.layer.borderWidth = 0.5
            sermonImageView.layer.masksToBounds = true
            sermonImageView.layer.borderColor = CGColor(red: 0.5, green: 0.5, blue: 0.5, alpha: 1.0)
            sermonImageView.layer.cornerRadius = 20
            view.reloadInputViews()
        }else{
            sermonImageView.layer.borderWidth = 0.5
            sermonImageView.layer.masksToBounds = true
            sermonImageView.image = UIImage(named: "placeholder")
            sermonImageView.layer.borderColor = CGColor(red: 0.5, green: 0.5, blue: 0.5, alpha: 0.8)
            sermonImageView.layer.cornerRadius = 20
            view.reloadInputViews()
        }
            subscribeToChanges()

    }
    
    
    
    @IBAction func sermonRewindButtonPressed(_ sender: UIButton) {
    }
    
    @IBAction func sermonForwardButtonPressed(_ sender: UIButton) {
    }
    
    @IBAction func sermonPlayButtonPressed(_ sender: UIButton) {
        
        let url = URL(string: sermonAudioURL)!
        if globalPlayerState == .ended && gloabalAudioURL == "" {
               gloabalAudioURL = sermonAudioURL
               SAPlayer.shared.startRemoteAudio(withRemoteUrl: url)
               print("Starting out initially")
               SAPlayer.shared.play()
               globalPlayerState = .playing
           }
        else if globalPlayerState == .ended && gloabalAudioURL != sermonAudioURL {
            SAPlayer.shared.startRemoteAudio(withRemoteUrl: url)
            print("Starting out initially")
            SAPlayer.shared.play()
            globalPlayerState = .playing
        }
        else if globalPlayerState == .playing && gloabalAudioURL == sermonAudioURL {
            print("Pausing after having been played")
            SAPlayer.shared.pause()
            globalPlayerState = .paused
        }
        else if globalPlayerState == .playing && gloabalAudioURL != sermonAudioURL {
            gloabalAudioURL = sermonAudioURL
            SAPlayer.shared.stopStreamingRemoteAudio()
            SAPlayer.shared.startRemoteAudio(withRemoteUrl: url)
            print("Starting out initially again")
            SAPlayer.shared.play()
            globalPlayerState = .playing
        }
        else if globalPlayerState == .paused && gloabalAudioURL != sermonAudioURL {
            gloabalAudioURL = sermonAudioURL
            SAPlayer.shared.stopStreamingRemoteAudio()
            SAPlayer.shared.startRemoteAudio(withRemoteUrl: url)
            print("Starting out initially again")
            SAPlayer.shared.play()
            globalPlayerState = .playing
        }
        else if globalPlayerState == .paused && gloabalAudioURL == sermonAudioURL {
            print("Playing after having been paused")
            SAPlayer.shared.play()
            globalPlayerState = .playing
        }
        else if globalPlayerState == .ended && gloabalAudioURL != sermonAudioURL {
            SAPlayer.shared.startRemoteAudio(withRemoteUrl: url)
            print("Playing after having been paused")
            SAPlayer.shared.play()
            globalPlayerState = .playing
        }
        subscribeToChanges()
    }
    
    @IBAction func sermonRateButtonPressed(_ sender: UIButton) {
        
    }
    
    @IBAction func sermonOptionButtonPressed(_ sender: UIButton) { // this should be the download button
        
    }
    
    
    func subscribeToChanges() {
        durationId = SAPlayer.Updates.Duration.subscribe { [weak self] (duration) in
            guard let self = self else { return }
            
            if gloabalAudioURL == self.sermonAudioURL{
                self.durationLabel.text = SAPlayer.prettifyTimestamp(duration)
                self.duration = duration
            }
        }
        
        elapsedId = SAPlayer.Updates.ElapsedTime.subscribe { [weak self] (position) in
            guard let self = self else { return }
            if gloabalAudioURL == self.sermonAudioURL{
                self.currentTimeStampLabel.text = SAPlayer.prettifyTimestamp(position)
                guard self.duration != 0 else { return }
                self.playerSlider.value = Float(position/self.duration)
            }
        }
        
        downloadId = SAPlayer.Updates.AudioDownloading.subscribe { [weak self] (url, progress) in
            guard let self = self else { return }
            guard url == URL(string: self.sermonAudioURL) else { return }
            
            if self.isDownloading {
                DispatchQueue.main.async {
                    UIView.performWithoutAnimation {
                        self.sermonOptionButtonLabel.setTitle("Cancel \(String(format: "%.2f", (progress * 100)))%", for: .normal)
                    }
                }
            }
        }
        
        bufferId = SAPlayer.Updates.StreamingBuffer.subscribe{ [weak self] (buffer) in
            guard let self = self else { return }
            if gloabalAudioURL == self.sermonAudioURL{
                self.sermonProgressView.progress = Float(buffer.bufferingProgress)
                self.isPlayable = buffer.isReadyForPlaying
            }
        }
        
        playingStatusId = SAPlayer.Updates.PlayingStatus.subscribe { [weak self] (playing) in
            if gloabalAudioURL == self?.sermonAudioURL{
                guard let self = self else { return }
                self.playbackStatus = .playing
                
                switch playing {
                case .playing:
                    self.isPlayable = true
                    self.sermonPlayButton.setImage(UIImage(systemName: "pause.circle.fill"), for: .normal)
                    return
                case .paused:
                    self.isPlayable = true
                    self.sermonPlayButton.setImage(UIImage(systemName: "play.circle.fill"), for: .normal)
                    return
                case .buffering:
                    self.isPlayable = false
                    self.sermonPlayButton.setImage(UIImage(systemName: "pause.circle.fill"), for: .normal)
                    return
                case .ended:
                    if !self.loopEnabled {
                        self.isPlayable = false
                        self.sermonPlayButton.setImage(UIImage(systemName: "play.circle.fill"), for: .normal)
                    }
                    return
                }
            }
        }
        
        // Not Needed For Now
//        queueId = SAPlayer.Updates.AudioQueue.subscribe { [weak self] forthcomingPlaybackUrl in
//            guard let self = self else { return }
//            /// we update the selected audio. this is a little contrived, but allows us to update outlets
//            if let indexFound = self.selectedAudio.getIndex(forURL: forthcomingPlaybackUrl) {
//                self.selectAudio(atIndex: indexFound)
//            }
//            self.currentUrlLocationLabel.text = "\(forthcomingPlaybackUrl.absoluteString)"
//        }
        
    }
    

}
