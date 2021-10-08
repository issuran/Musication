//
//  HomeViewController.swift
//  Musication
//
//  Created by Tiago Oliveira on 06/10/21.
//

import UIKit
import AVFoundation
import AVKit

public var audioPlayer = AVPlayer()

enum PlayingState { case playing, notPlaying }

class HomeViewController: UIViewController {
    
    // MARK: - Properties
    
    @IBOutlet private weak var playerState: UILabel!
    @IBOutlet private weak var trackInfo: UILabel!
    @IBOutlet private weak var playerImageView: UIImageView!
    
    var trackState: Bool = true
    var state: String = "Paused" {
        willSet {
            playerState.text = newValue
        }
    }
    
    // MARK: - Lifecycle Methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
    }
    
    // MARK: - Action Methods

    @IBAction func didTapOnPlayPauseButton(_ sender: Any) {
        trackState = !trackState
        
        if trackState {
            playerImageView.image = #imageLiteral(resourceName: "play_icon")
            state = "Paused"
            audioPlayer.pause()
        } else {
            playerImageView.image = #imageLiteral(resourceName: "pause_icon")
            state = "Playing"
            let trackUrl = "https://65381g.ha.azioncdn.net/e/c/b/3/vaqueirosmoficial-hoje-tem-feat-rai-saia-rodada-785260ab.mp3"
            let url = NSURL(string: trackUrl)!
            audioPlayer = AVPlayer(url: url as URL)
            audioPlayer.play()
        }
    }
    
    @IBAction func didTapOnBackTrackButton(_ sender: Any) {
        print("BACK")
    }
    
    @IBAction func didTapOnNextTrackButton(_ sender: Any) {
        print("NEXT")
    }
    
    // MARK: - Private Methods
    
    private func setupView() {
        playerState.text = state
    }
    
    // MARK: - Public Methods
    
    // MARK: - Deinit Methods
    
    deinit {
        NSLog("Deinit HomeViewController")
    }
}
