//
//  Provider.swift
//  Musication
//
//  Created by Tiago Oliveira on 12/10/21.
//

import Foundation

struct NoReply: Decodable {}

public class Provider {
    var urlSession = URLSession.shared
    var task: URLSessionDataTask?
    
    public init() { }
    
    public func execute<T: Decodable>(model: T.Type, endpoint: ServiceProtocol, completion: @escaping (Result<T?, Error>) -> Void) throws {
        do {
            let request = try endpoint.urlRequest()
            task = urlSession.dataTask(with: request) { (data, response, error) in
                self.middleware(model: model, data: data, response: response, error: error) { (result) in
                    switch result {
                    case .success(let data):
                        completion(.success(data))
                    case .failure(let error):
                        completion(.failure(error))
                    }
                }
            }
            task?.resume()
        } catch {
            throw error
        }
    }
    
    public func stopRequestOnGoing() {
        if let task = task {
            task.cancel()
        }
    }
    
    private func middleware<T: Decodable>(model: T.Type, data: Data?, response: URLResponse?, error: Error?, completion: @escaping (Result<T?, Error>) -> Void) {
        
        var httpResponse: HTTPURLResponse?
        
        processResponse(response: response) { (result) in
            switch result {
            case .success(let response):
                debugPrint(response)
                httpResponse = response
            case .failure(let error):
                debugPrint(error)
                return completion(.failure(NSError(domain: "Invalid response", code: -999, userInfo: nil)))
            }
        }
        
        processError(error: error, response: httpResponse) { (result) in
            switch result {
            case .success():
                break
            case .failure(let error):
                debugPrint(error)
                completion(.failure(error))
            }
        }
        
        processData(model: model, data: data, response: httpResponse, error: error) { (result) in
            switch result {
            case .success(let data):
                debugPrint(data as Any)
                return completion(.success(data))
            case .failure(let error):
                debugPrint(error)
                return completion(.failure(error))
            }
        }
    }
    
    private func processResponse(response: URLResponse?, completion: @escaping (Result<HTTPURLResponse, Error>) -> Void) {
        guard let httpResponse = response as? HTTPURLResponse else {
            return completion(.failure(NSError(domain: "Invalid response", code: -999, userInfo: nil)))
        }
        
        guard 200 ... 299 ~= httpResponse.statusCode else {
            return completion(.failure(NSError(domain: "Error", code: httpResponse.statusCode, userInfo: nil)))
        }
        
        completion(.success(httpResponse))
    }
    
    private func processError(error: Error?, response: HTTPURLResponse?, completion: @escaping (Result<Void, Error>) -> Void) {
        guard let error = error else {
            return completion(.success(()))
        }
        
        completion(.failure(NSError(domain: "Error: \(error.localizedDescription)", code: response?.statusCode ?? -992, userInfo: nil)))
    }
    
    private func processData<T: Decodable>(model: T.Type, data: Data?, response: HTTPURLResponse?, error: Error?, completion: @escaping (Result<T?, Error>) -> Void) {
        debugPrint(data as Any)
        guard let data = data else {
            return completion(.failure(NSError(domain: "Invalid data", code: response?.statusCode ?? -991, userInfo: nil)))
        }
        
        guard let result = try? JSONDecoder().decode(T.self, from: data) else {
            
            if 200 ... 299 ~= response?.statusCode ?? 200 {
                return completion(.success(nil))
            }
            
            return completion(.failure(NSError(domain: "Could not decode payload", code: response?.statusCode ?? 201, userInfo: nil)))
        }
        
        return completion(.success(result))
    }
}
