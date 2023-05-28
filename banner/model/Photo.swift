//
//  Photo.swift
//  banner
//
//  Created by jr on 2023/5/25.
//

import Foundation

struct PhotoInfo:Codable{
    let urls:Urls
}

struct Urls:Codable{
    let regular:URL
}


