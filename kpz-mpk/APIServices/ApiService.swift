//
//  ApiService.swift
//  kpz-mpk
//
//  Created by Wojciech Konury on 22/03/2020.
//  Copyright © 2020 kpz-mpk. All rights reserved.
//

import Foundation
import Alamofire

protocol ApiServiceProtocol {
  func request<T: Decodable>(endpoint: ApiEndpoint, success: ((T) -> ())?)
}

class ApiService: ApiServiceProtocol {
  
  // MARK: - Private Properties
  private lazy var session: Session = {
    return Session()
  }()
  
  func request<T: Decodable>(endpoint: ApiEndpoint, success: ((T) -> ())?) {
    
    let url = ApiConstants.baseURL
    var request: URLRequest = URLRequest(url: url.appendingPathComponent(endpoint.path))
    
    request.httpMethod = endpoint.method.rawValue
    
    if let encodedRequest = try? endpoint.encoding.encode(request, with: endpoint.queryItems) {
      request = encodedRequest
    }
    
    request.httpBody = endpoint.bodyParameters?.toJSONData()
    
    let urlConvertible: URLRequestConvertible = request
    let dataRequest: DataRequest = session.request(urlConvertible)
    
    dataRequest
      .validate()
      .responseDecodable { (response: DataResponse<T, AFError>) in
        switch response.result {
        case let .success(data):
          success?(data)
        case let .failure(error):
          print(error)
        }
    }
  }

}
