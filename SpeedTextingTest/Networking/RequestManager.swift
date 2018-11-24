//
//  RequestManager.swift
//  SpeedTextingTest
//
//  Created by darryl.beronque on 11/23/18.
//  Copyright © 2018 darrylberonque. All rights reserved.
//

import Foundation
import RxSwift

class RequestManager {

    private var apiClient: APIClient

    init(apiClient: APIClient = APIClient()) {
        self.apiClient = apiClient
    }

    // MARK: - API requests
    func getParagraph(pageIndex: Int) -> Observable<ExcerptsModel> {
        guard let urlRequest = URLRequest(builder: URLRequestBuilder { builder in
            builder.baseURL = Constants.stackOverflowBaseURL
            builder.method = .get
            builder.path = .paragraph(pageIndex)
        }) else { return Observable.just(ExcerptsModel(excerpts: []))}

        return apiClient.sendRequest(request: urlRequest)
    }

}
