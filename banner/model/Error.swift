//
//  Error.swift
//  banner
//
//  Created by jr on 2023/5/26.
//

import Foundation
struct ErrorResponse:Decodable,Error{
    let errors:[String]
}
