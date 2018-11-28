//
//  RequestManager.swift
//  SpeedTextingTest
//
//  Created by darryl.beronque on 11/23/18.
//  Copyright © 2018 darrylberonque. All rights reserved.
//

import Foundation
import RxSwift

final class RequestManager {

    private static var apiClient =  APIClient()
    static var sharedInstance = RequestManager()

    private init() {}

    // MARK: - API requests
    
    class func getAllTrials() -> Observable<TrialsModel> {
        guard let urlRequest = URLRequest(builder: URLRequestBuilder { builder in
            builder.parameters = ["query" : RequestParameters.allTrials.parameters]
        }) else { return Observable.just(TrialsModel(trials: []))}

        return apiClient.sendRequest(request: urlRequest)
    }

    class func getUser(userID: String) -> Observable<UserDecodableResult> {
        guard let urlRequest = URLRequest(builder: URLRequestBuilder { builder in
            builder.parameters = ["query" : RequestParameters.userTrials(userID).parameters]
        }) else { return Observable.just(UserDecodableResult()) }

        return apiClient.sendRequest(request: urlRequest)
    }

    class func getAllParagraphs() -> Observable<ParagraphsModel> {
        guard let urlRequest = URLRequest(builder: URLRequestBuilder { builder in
            builder.parameters = ["query" : RequestParameters.allParagraphs.parameters]
        }) else { return Observable.just(ParagraphsModel(paragraphs: [])) }

        return apiClient.sendRequest(request: urlRequest)
    }

    class func postTrial(trialResult: TrialEncodableResult) -> Observable<TrialEncodableResult> {
        guard let trial = trialResult.trial, let urlRequest = URLRequest(builder: URLRequestBuilder { builder in
            builder.method = .post
            builder.parameters = ["query" : RequestParameters.postTrial(trial).parameters]
        }) else { return Observable.just(TrialEncodableResult()) }

        return apiClient.sendRequest(request: urlRequest)
    }

    class func postUser(userResult: UserEncodableResult) -> Observable<UserEncodableResult> {
        guard let user = userResult.user, let urlRequest = URLRequest(builder: URLRequestBuilder { builder in
            builder.method = .post
            builder.parameters = ["query" : RequestParameters.postUser(user).parameters]
        }) else { return Observable.just(UserEncodableResult()) }

        return apiClient.sendRequest(request: urlRequest)
    }
}
