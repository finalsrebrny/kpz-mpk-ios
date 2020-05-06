//
//  IncidentApiService.swift
//  kpz-mpk
//
//  Created by Wojciech Konury on 30/03/2020.
//  Copyright © 2020 kpz-mpk. All rights reserved.
//

import Foundation

protocol IncidentApiServiceProtocole {
  func getIncidents(success: (([Incident]) -> ())?, failure: ((ApiError) -> Void)?)
  func getIncident(id: String, success: ((Incident) -> ())?, failure: ((ApiError) -> Void)?)
}

class IncidentApiService: IncidentApiServiceProtocole {
  let apiService: ApiServiceProtocol = ApiService()
  
  func getIncidents(success: (([Incident]) -> ())?, failure: ((ApiError) -> Void)?) {
    apiService.request(endpoint: IncidentEndpoint.getIncidents, success: { (response) in
      success?(response)
    }, failure: { (apiError) in
      failure?(apiError)
    })
  }
  
  func getIncident(id: String, success: ((Incident) -> ())?, failure: ((ApiError) -> Void)?) {
    apiService.request(endpoint: IncidentEndpoint.getIncident(id: id), success: { (response) in
      success?(response)
    }, failure: { (apiError) in
      failure?(apiError)
    })
  }
}
