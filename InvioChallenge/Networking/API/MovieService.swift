//
//  MovieService.swift
//  InvioChallenge
//
//  Created by EnsarKoseoglu on 18.02.2023.
//

import Foundation

public typealias ResponseHandler<T> = ((T) -> Void)

protocol IMovieService: AnyObject {
  func searchMovie(by title: String,
                   page: Int,
                   onSuccess: @escaping ResponseHandler<Search>,
                   onFailure: @escaping ResponseHandler<ResponseError>)
  func getMovieDetail(with id: String,
                      onSuccess: @escaping ResponseHandler<Movie>,
                      onFailure: @escaping ResponseHandler<ResponseError>)
}

class MovieService: IMovieService {
  let networkService: NetworkManager

  required init() {
    networkService = NetworkManager()
  }

  func searchMovie(by title: String,
                   page: Int,
                   onSuccess: @escaping ResponseHandler<Search>,
                   onFailure: @escaping ResponseHandler<ResponseError>) {

    let config = NetworkConfig(url: Constants.Network.baseUrl,
                               method: .get,
                               queryItems: [Constants.Parameters.search : title,
                                            Constants.Parameters.page : "\(page)",
                                            Constants.Parameters.key : Constants.Network.apiKey])
    networkService.sendRequest(config) { result in
      switch result {
      case .success(let data):
        guard let searchResult = JSONHandler().deserializeObject(Search.self, withJSONObject: data) else { return }
        onSuccess(searchResult)
      case .failure(let error):
        switch error {
        case .unauthorized(let errData):
          guard let responseError = JSONHandler().deserializeObject(ResponseError.self, withJSONObject: errData ?? Data()) else { return }
          onFailure(responseError)
        default:
          onFailure(ResponseError(response: error.localizedDescription, error: error.localizedDescription))
        }
      }
    }
  }

  func getMovieDetail(with id: String,
                      onSuccess: @escaping ResponseHandler<Movie>,
                      onFailure: @escaping ResponseHandler<ResponseError>) {
    let config = NetworkConfig(url: Constants.Network.baseUrl,
                               method: .get,
                               queryItems: [Constants.Parameters.id : id,
                                            Constants.Parameters.key : Constants.Network.apiKey])
    networkService.sendRequest(config) { result in
      switch result {
      case .success(let data):
        guard let movieDetail = JSONHandler().deserializeObject(Movie.self, withJSONObject: data) else { return }
        onSuccess(movieDetail)
      case .failure(let error):
        switch error {
        case .unauthorized(let errData):
          guard let responseError = JSONHandler().deserializeObject(ResponseError.self, withJSONObject: errData ?? Data()) else { return }
          onFailure(responseError)
        default:
          onFailure(ResponseError(response: error.localizedDescription, error: error.localizedDescription))
        }
      }
    }
  }
}
