//
//  URLRequestBuilder.swift
//  SpeedTextingTest
//
//  Created by darryl.beronque on 11/22/18.
//  Copyright © 2018 darrylberonque. All rights reserved.
//

import Foundation

enum HTTPMethodType: String {
    case get = "GET"
    case post = "POST"
}

enum RequestPath {
    // TODO: - Change paragraph endpoint to actual endpoint
    case paragraph(Int)
    case graphql

    var value: String {
        switch self {
        case .paragraph(let pageIndex):
            return "/search/excerpts?page=\(pageIndex)&site=stackoverflow"
        case .graphql:
            return "/graphql"
        }
    }
}

class URLRequestBuilder {
    var method: HTTPMethodType = .get
    var baseURL: String = Constants.baseURL
    var path: RequestPath?
    var parameters: [String : String]?

    typealias BuilderClosure = (URLRequestBuilder) -> Void

    init(buildClosure: BuilderClosure) {
        buildClosure(self)
    }
}
