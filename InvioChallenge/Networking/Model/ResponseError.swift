//
//  ResponseError.swift
//  InvioChallenge
//
//  Created by EnsarKoseoglu on 17.02.2023.
//

import Foundation

public struct ResponseError: Error, Codable {
  let response: String
  let error: String

  enum CodingKeys: String, CodingKey {
    case response = "Response"
    case error = "Error"
  }
}
