//
//  APIClient.swift
//  SpeedTextingTest
//
//  Created by darryl.beronque on 11/23/18.
//  Copyright © 2018 darrylberonque. All rights reserved.
//

import Foundation
import RxSwift

enum URLRequestError: Error {
    case noResponseError
    case responseError
    case noDataError
    case decodingError
}

class APIClient {
    func sendRequest<T: Codable>(request: URLRequest) -> Observable<T> {
        return Observable<T>.create({ observer in
            let task = URLSession.shared.dataTask(with: request) { data, response, error in
                if let error = error {
                    observer.on(.error(error))
                    return
                }

                guard let response = response as? HTTPURLResponse else {
                    observer.on(.error(URLRequestError.noResponseError))
                    return
                }

                guard response.statusCode < 400 else {
                    observer.on(.error(URLRequestError.responseError))
                    return
                }

                guard let data = data else {
                    observer.on(.error(URLRequestError.noDataError))
                    return
                }
                
                do {
                    let result = try JSONDecoder().decode(T.self, from: data)
                    observer.on(.next(result))
                    return
                } catch {
                    observer.on(.error(URLRequestError.decodingError))
                }

                observer.onCompleted()
            }

            task.resume()

            return Disposables.create {
                task.cancel()
            }
        })
    }
}
