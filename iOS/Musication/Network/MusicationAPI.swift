//
//  MusicationAPI.swift
//  Musication
//
//  Created by Tiago Oliveira on 12/10/21.
//

import Foundation

enum MusicationAPI {
    case nextSong(latitude: String, longitude: String)
//    case sendLocation
}

extension MusicationAPI: ServiceProtocol {
    var scheme: String {
        return "https"
    }
    
    var host: String {
        return "stark-shelf-44081.herokuapp.com"
    }
    
    var path: String {
        switch self {
        case .nextSong:
            return "/musication/song"
//        case .sendLocation:
//            return "/musication/location"
        }
    }
    
    var method: HttpMethod {
        switch self {
        case .nextSong:
            return .post
//        case .sendLocation:
//            return .post
        }
    }
    
    var task: HttpTask {
        switch self {
//        case .nextSong:
//            let param: Parameters = [
//                "user-id": "\(UserSession.shared.getUserId())"
//            ]
//
//            return .requestUrlParameters(urlParameters: param)
        case .nextSong(let latitude, let longitude):
            let params: Parameters = [
                "user-id": "\(UserSession.shared.getUserId())",
                "latitude": "\(latitude)",
                "longitude": "\(longitude)"
            ]
            return .requestBodyParameters(bodyParameters: params)
        }
    }
    
    
}
