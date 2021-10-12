//
//  MusicationService.swift
//  Musication
//
//  Created by Tiago Oliveira on 12/10/21.
//

import Foundation

final class MusicationService {
    let provider = Provider()
    
    func getNextSong(completion: @escaping (Result<MusicModel, Error>)->Void)->Void {
        do {
            try provider.execute(model: MusicModel.self, endpoint: MusicationAPI.nextSong, completion: { (result) in
                switch result {
                case .success(let model):
                    guard let model = model else { return completion(.failure(NSError(domain: "Unexpected error", code: 400, userInfo: nil))) }
                    completion(.success(model))
                case .failure(let error):
                    completion(.failure(error))
                }
            })
        } catch {
            completion(.failure(error))
        }
    }
    
    func postLocation(latitude: String, longitude: String, completion: @escaping (Result<Void, Error>)->Void)->Void {
        do {
            try provider.execute(model: NoReply.self, endpoint: MusicationAPI.sendLocation(latitude: latitude, longitude: longitude), completion: { (result) in
                switch result {
                case .success:
                    completion(.success(()))
                case .failure(let error):
                    completion(.failure(error))
                }
            })
        } catch {
            completion(.failure(error))
        }
    }
}
