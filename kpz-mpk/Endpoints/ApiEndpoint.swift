//
//  ApiEndpoint.swift
//  kpz-mpk
//
//  Created by Wojciech Konury on 11/04/2020.
//  Copyright © 2020 kpz-mpk. All rights reserved.
//

import Foundation
import Alamofire

protocol ApiEndpoint {
  var method: HTTPMethod { get }
  var encoding: ParameterEncoding { get }
  var queryItems: Parameters? { get }
  var bodyParameters: Encodable? { get }
  var path: String { get }
}

extension ApiEndpoint {
  var encoding: ParameterEncoding {
    switch method {
    case .get:
      return URLEncoding.default
    default:
      return JSONEncoding.default
    }
  }
  
  var queryItems: Parameters? {
    return nil
  }
  
  var bodyParameters: Encodable? {
    return nil
  }
  
  func asURLRequest() -> URLRequest {
    let url = ApiConstants.baseURL
    var request: URLRequest = URLRequest(url: url.appendingPathComponent(path))
    
    request.httpMethod = method.rawValue
    
    if let encodedRequest = try? encoding.encode(request, with: queryItems) {
      request = encodedRequest
    }
    
    request.httpBody = bodyParameters?.toJSONData()
    return request
  }
}

private extension Encodable {
  func toJSONData() -> Data? { try? JSONEncoder().encode(self) }
}
