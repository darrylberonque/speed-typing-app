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
        guard let path = builder.path, var components = URLComponents(string: "\(builder.baseURL)/\(path.value)") else { return nil }

        if let parameters = builder.parameters {
            components.queryItems = parameters.map({ URLQueryItem(name: $0, value: $1) })
        }

        guard let url = components.url else { return nil }
        self.init(url: url)

        httpMethod = builder.method.rawValue
        builder.method == .get ? addValue(Constants.postHeader, forHTTPHeaderField: Constants.accept) : addValue(Constants.postHeader, forHTTPHeaderField: Constants.contentType)
    }
}
