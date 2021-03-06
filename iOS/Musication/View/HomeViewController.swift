//
//  HomeViewController.swift
//  Musication
//
//  Created by Tiago Oliveira on 06/10/21.
//

import UIKit
import AVFoundation
import AVKit
import CoreLocation

public var audioPlayer = AVAudioPlayer()

enum PlayingState { case playing, notPlaying }

protocol PlayerDelegate: AnyObject {
    func playSong(_ presenter: HomePresenter, model: MusicModel)
    func stopSong(_ presenter: HomePresenter)
    func handleError(_ presenter: HomePresenter, error: Error?)
}

class HomeViewController: UIViewController {
    
    // MARK: - Properties
    
    @IBOutlet private weak var playerState: UILabel!
    @IBOutlet private weak var trackInfo: UILabel!
    @IBOutlet private weak var playerImageView: UIImageView!
    
    let manager = CLLocationManager()
    var presenter: HomePresenter? = nil
    var isPlaying: Bool = false
    var tapped: Bool = false
    var state: String = "Paused" {
        willSet {
            playerState.text = newValue
        }
    }
    
    // MARK: - Lifecycle Methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configurePresenter()
        setupView()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        manager.desiredAccuracy = kCLLocationAccuracyBest
        manager.delegate = self
        manager.requestWhenInUseAuthorization()
        manager.requestAlwaysAuthorization()
        
        if CLLocationManager.locationServicesEnabled() {
            manager.startUpdatingLocation()
        }
    }
    
    // MARK: - Action Methods

    @IBAction func didTapOnPlayPauseButton(_ sender: Any) {
        if !isPlaying {
            playSong()
        } else {
            pauseSong()
        }
    }
    
    @IBAction func didTapOnBackTrackButton(_ sender: Any) {
        presentError(NSError(domain: "Sorry, we can go back now :(", code: 500, userInfo: nil))
    }
    
    @IBAction func didTapOnNextTrackButton(_ sender: Any) {
        nextSong()
    }
    
    // MARK: - Private Methods
    
    private func configurePresenter() {
        presenter = HomePresenter()
        presenter?.delegate = self
    }
    
    private func setupView() {
        playerState.text = state
    }
    
    private func playSong() {
        if !tapped && !isPlaying {
            tapped = true
            guard let presenter = presenter else { return }
            DispatchQueue.main.async {
                presenter.requestNextSong()
            }
        }
    }
    
    private func pauseSong() {
        isPlaying = false
        trackInfo.text = ""
        playerImageView.image = #imageLiteral(resourceName: "play_icon")
        state = "Paused"
        audioPlayer.pause()
    }
    
    private func nextSong() {
        isPlaying = false
        audioPlayer.pause()
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            self.playSong()
        }
        
    }
    
    private func presentError(_ error: Error?) {
        DispatchQueue.main.async {
            var alert = UIAlertController()
            
            if let error = error {
                alert = UIAlertController(
                    title: "An error occured",
                    message: error.localizedDescription,
                    preferredStyle: .alert
                )
            } else {
                alert = UIAlertController(
                    title: "An error occured",
                    message: "Please try again later",
                    preferredStyle: .alert
                )
            }
            
            alert.addAction(.init(title: "Ok", style: .default, handler: { (view) in
                self.dismiss(animated: true, completion: nil)
            }))
            
            self.present(alert, animated: true)
        }
    }
    
    // MARK: - Deinit Methods
    
    deinit {
        NSLog("Deinit HomeViewController")
    }
}

extension HomeViewController: PlayerDelegate {
    func playSong(_ presenter: HomePresenter, model: MusicModel) {
        DispatchQueue.main.async {
            self.isPlaying = true
            self.tapped = false
            let urlTrack = model.urlTrack
            
            do {
                self.state = "Playing"
                self.trackInfo.text = "\(model.musicArtist) - \(model.musicName)"
                self.playerImageView.image = #imageLiteral(resourceName: "pause_icon")
                guard let url = URL(string: urlTrack) else { return }
                
                let data = try Data(contentsOf: url)
                audioPlayer = try AVAudioPlayer(data: data)
                
                audioPlayer.delegate = self
                audioPlayer.prepareToPlay()
                audioPlayer.play()
                
            } catch let error as NSError {
                print("error: \(error.localizedDescription)")
            }
        }
            
    }
    
    func stopSong(_ presenter: HomePresenter) {
        isPlaying = false
        pauseSong()
    }
    
    func handleError(_ presenter: HomePresenter, error: Error?) {
        presentError(error)
    }
}

extension HomeViewController: CLLocationManagerDelegate {
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.first {
            presenter?.updateCurrentLocation(latitude: location.coordinate.latitude, longitude: location.coordinate.longitude)
        }
    }
}

extension HomeViewController: AVAudioPlayerDelegate {
    func audioPlayerDidFinishPlaying(_ player: AVAudioPlayer, successfully flag: Bool) {
        print("Play next")
        playSong()
    }
}
