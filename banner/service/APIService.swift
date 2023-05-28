//
//  APIService.swift
//  banner
//
//  Created by jr on 2023/5/26.
//

import UIKit

struct PhotoRequest:APIRequest{
    typealias Response = PhotoInfo

    var path: String {"/random/"}
    var method: HTTPMethod {.get}
    var queryItems: [URLQueryItem]?{
        [
            URLQueryItem(name: "count", value: "5"),
            URLQueryItem(name: "client_id", value: "MMkSjecQ9JgbXPjfgzIvKnRZawfldw4s2hXU5Jwhol4")
        ]
    }
}
