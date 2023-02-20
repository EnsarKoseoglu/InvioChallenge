//
//  NetworkManager.swift
//  InvioChallenge
//
//  Created by EnsarKoseoglu on 17.02.2023.
//

import Foundation

protocol IService: AnyObject {
  func sendRequest<T:IRequest>(_ components: T, completion: @escaping (Result<Data, HttpError>) -> Void)
}

class NetworkManager: IService {
  private func createNewSession() -> URLSession {
    return URLSession.shared
  }

  private func createNewRequest(_ request: IRequest) -> URLRequest? {
    guard var urlComponent = URLComponents(string: request.url) else {
      return nil
    }

    var queryItems: [URLQueryItem] = []

    request.queryItems.forEach {
      let urlQueryItem = URLQueryItem(name: $0.key, value: $0.value)
      queryItems.append(urlQueryItem)
    }

    urlComponent.queryItems = queryItems
    
    guard let url = urlComponent.url else {
      return nil
    }

    var urlRequest = URLRequest(url: url)
    urlRequest.httpMethod = request.method.rawValue
    
    return urlRequest
  }

  func sendRequest<T>(_ components: T, completion: @escaping (Result<Data, HttpError>) -> Void) where T : IRequest {
    let session = createNewSession()
    guard let request = createNewRequest(components) else {
      completion(.failure(.invalidURL))
      return
    }

    let task = session.dataTask(with: request as URLRequest) { (data, response, error) in
      guard error == nil else {
        completion(.failure(.invalidResponse(data)))
        return
      }

      guard let responseData = data,
            let httpResponse = response as? HTTPURLResponse else {
        completion(.failure(.invalidResponse(data)))
        return
      }

      switch httpResponse.statusCode {
      case 200...299:
        return completion(.success(responseData))
      case 400:
        return completion(.failure(.badRequest))
      case 401...499:
        return completion(.failure(.unauthorized(responseData)))
      case 500...599:
        return completion(.failure(.apiError))
      default:
        return completion(.failure(.failed))
      }
    }
    task.resume()
  }
}

