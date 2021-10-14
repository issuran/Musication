//
//  HomePresenter.swift
//  Musication
//
//  Created by Tiago Oliveira on 12/10/21.
//

import Foundation

final class HomePresenter {
    
    let service = MusicationService()
    var delegate: PlayerDelegate?
    
    var latitude: String = ""
    var longitude: String = ""
    
    func requestNextSong() {
        service.getNextSong(latitude: self.latitude, longitude: self.longitude) { [weak self] (result) in
            guard let self = self else { return }
            
            switch result {
            case .success(let model):
                self.delegate?.playSong(self, model: model)
            case .failure(let error):
                self.delegate?.handleError(self, error: error)
            }
        }
    }
    
    func updateCurrentLocation(latitude: Double, longitude: Double) {
        self.latitude = "\(latitude)"
        self.longitude = "\(longitude)"
    }
    
    deinit {
        NSLog("Deinit HomePresenter")
    }
}
