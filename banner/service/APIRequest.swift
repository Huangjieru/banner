//
//  APIRequest.swift
//  banner
//
//  Created by jr on 2023/5/26.
//

import Foundation
import UIKit

//定義 protocol APIRequest。
protocol APIRequest
{
    associatedtype Response
    
    var path:String {get}
    var queryItems:[URLQueryItem]? {get}
    var request:URLRequest {get}
    var method:HTTPMethod {get}
//    var postData: Data? {get}
    
}
extension APIRequest
{
    var host:String {"api.unsplash.com"}
    var queryItems: [URLQueryItem]? {nil}
//    var postData:Data? {nil}
    
}

extension APIRequest
{
    var request:URLRequest{
        var components = URLComponents()
        components.scheme = "https"
        components.host = host
        components.path = "/photos" + path
        components.queryItems = queryItems
        
        var requestUrl = URLRequest(url: components.url!)
        requestUrl.httpMethod = method.rawValue
//        if let data = postData{
//            requestUrl.httpBody = data
//            requestUrl.addValue("application/json", forHTTPHeaderField: "Content-Type")
//        }
        return requestUrl
    }
}
//定義發送 request 的 function sendRequest
extension APIRequest where Response:Decodable
{
    func sendRequest(completion: @escaping (Result<[Response], Error>) -> Void)
    {
        URLSession.shared.dataTask(with: request) {
            data, response, error
            in
            do{
                if let data = data
                {
                    let decoder = JSONDecoder()
                    guard let httpResponse = response as? HTTPURLResponse, 200 ~= httpResponse.statusCode
                    else
                    {
                        if let apiErrorResponse = try? decoder.decode(ErrorResponse.self, from: data)
                        {
                            completion(.failure(apiErrorResponse))
                        }
                        return
                    }
                    let decoded = try decoder.decode([Response].self, from: data)
                    completion(.success(decoded))
                }
                else if let error = error
                {
                    completion(.failure(error))
                }
            }
            catch
            {
                completion(.failure(error))
            }
        }.resume()
        
    }
    
}


