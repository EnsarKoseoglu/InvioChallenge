//
//  NetworkConfig.swift
//  InvioChallenge
//
//  Created by EnsarKoseoglu on 17.02.2023.
//

import Foundation

protocol IRequest {
  var url: String { get }
  var method: HttpMethod { get }
  var queryItems: [String : String] { get }
}

struct NetworkConfig: IRequest {
  var url: String
  var method: HttpMethod
  var queryItems: [String:String]

  init(url: String, method: HttpMethod, queryItems: [String:String] = [:]) {
    self.url = url
    self.method = method
    self.queryItems = queryItems
  }
}

enum HttpError: Error {
  case invalidURL
  case badRequest
  case apiError
  case failed
  case unauthorized(Data?)
  case invalidResponse(Data?)
}

enum HttpMethod: String {
  case post = "POST"
  case get = "GET"
  case put = "PUT"
  case delete = "DELETE"
}
