//
//  URLRequest+extensions.swift
//  SpeedTextingTest
//
//  Created by darryl.beronque on 11/22/18.
//  Copyright © 2018 darrylberonque. All rights reserved.
//

import Foundation

extension URLRequest {
    init?(builder: URLRequestBuilder) {
        guard var components = URLComponents(string: "\(builder.baseURL)\(builder.path.rawValue)") else { return nil }

        if let parameters = builder.parameters {
            components.queryItems = parameters.map({ URLQueryItem(name: $0, value: $1) })
        }

        guard let url = components.url else { return nil }
        self.init(url: url)

        httpMethod = builder.method.rawValue

        if builder.method == .post {
            do {
                guard let parameters = builder.parameters else { return nil }
                httpBody = try JSONSerialization.data(withJSONObject: parameters, options: [])
                addValue(Constants.postHeader, forHTTPHeaderField: Constants.contentType)
            } catch {
                print("Request error: \(URLRequestError.urlRequestBuilderError).")
            }
        } else {
            addValue(Constants.postHeader, forHTTPHeaderField: Constants.accept)
        }
    }
}
