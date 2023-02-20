//
//  JSONHandler.swift
//  InvioChallenge
//
//  Created by EnsarKoseoglu on 17.02.2023.
//

import Foundation

final class JSONHandler {
  func deserializeObject<T: Decodable>(_ value: T.Type, withJSONObject object: Data, options opt: JSONSerialization.WritingOptions = [], function: String = "") -> T? {
    do {
      let decodedObject = try JSONDecoder().decode(T.self, from: object)
      return decodedObject
    } catch let DecodingError.dataCorrupted(context) {
      print(function + " : " + context.debugDescription + "error")
    } catch let DecodingError.keyNotFound(key, context) {
      print(function + " : " + "Key '\(key)' not found:", context.debugDescription)
      print("codingPath:", context.codingPath)
    } catch let DecodingError.valueNotFound(value, context) {
      print(function + " : " + "Value '\(value)' not found:", context.debugDescription)
      print("codingPath:", context.codingPath)
    } catch let DecodingError.typeMismatch(type, context) {
      print(function + " : " + "Type '\(type)' mismatch:", context.debugDescription)
      print("codingPath:", context.codingPath)
    } catch {
      print(function + " : " + "error: ", error)
    }
    return nil
  }
}
