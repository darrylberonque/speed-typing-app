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

enum RequestPath: String {
    case graphql = "/graphql"
}

enum RequestParameters {
    case allTrials
    case allParagraphs
    case userTrials(String)
    case postTrial(TrialModel)
    case postUser(UserModel)

    var parameters: String {
        switch self {
        case .allTrials:
            return "{ trials { paragraph userID userInput metrics { wpm cpm accuracy time }} }"
        case .userTrials(let userID):
            return "{ user(id: \"\(userID)\" ) { id name email imageURL authID trials { id paragraph userID userInput metrics { wpm cpm accuracy time } } } }"
        case .allParagraphs:
            return "{ paragraphs { content } }"
        case .postTrial(let trial):
            guard let paragraph = trial.paragraph, let userID = trial.userID, let userInput = trial.userInput, let metrics = trial.metrics else { return "" }
            return """
            mutation { postTrial( paragraph: "\(paragraph)" userID: "\(userID)" userInput: "\(userInput)" metrics: { time: \(Int(metrics.time)) wpm: \(Int(metrics.wpm)) cpm: \(Int(metrics.cpm)) accuracy: \(Int(metrics.accuracy)) }) { id paragraph userID userInput metrics { time wpm cpm accuracy } } }
            """
        case .postUser(let user):
            guard let name = user.name, let email = user.email, let imageURL = user.imageURL, let authID = user.authID else { return ""}
            return """
            mutation { postUser( name: "\(name)" email: "\(email)" imageURL: "\(imageURL)" authID: "\(authID)") { id name email imageURL authID trials { id paragraph userID userInput metrics { time wpm cpm accuracy } } } }
            """
        }
    }
}

class URLRequestBuilder {
    var method: HTTPMethodType = .get
    var baseURL: String = Constants.baseURL
    var path: RequestPath = .graphql
    var parameters: [String : String]?

    typealias BuilderClosure = (URLRequestBuilder) -> Void

    init(buildClosure: BuilderClosure) {
        buildClosure(self)
    }
}
