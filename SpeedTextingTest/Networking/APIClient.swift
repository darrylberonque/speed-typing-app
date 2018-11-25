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
    case urlRequestBuilderError
    case noResponseError
    case responseError(Int)
    case noDataError
    case decodingError

    var description: String {
        switch self {
        case .urlRequestBuilderError:
            return "Error: Failed constructing the url request."
        case .noResponseError:
            return "Error: Given nil response"
        case .responseError(let statusCode):
            return "Error: Response error with status code \(statusCode)"
        case .noDataError:
            return "Error: Given nil data"
        case .decodingError:
            return "Error: Decoding failed"
        }
    }
}

class APIClient {
    func sendRequest<T: Codable>(request: URLRequest) -> Observable<T> {
        return Observable<T>.create({ observer in
            let task = URLSession.shared.dataTask(with: request) { data, response, error in
                if let error = error {
                    observer.onError(error)
                    return
                }

                guard let response = response as? HTTPURLResponse else {
                    observer.onError(URLRequestError.noResponseError)
                    return
                }

                guard response.statusCode < 400 else {
                    observer.onError(URLRequestError.responseError(response.statusCode))
                    return
                }

                guard let data = data else {
                    observer.onError(URLRequestError.noDataError)
                    return
                }

                do {
                    let result = try JSONDecoder().decode([String: T].self, from: data)
                    guard let resultContents = result[Constants.rootQueryString] else { return }
                    observer.onNext(resultContents)
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
