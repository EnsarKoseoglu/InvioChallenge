//
//  MovieDetailViewModel.swift
//  InvioChallenge
//
//  Created by EnsarKoseoglu on 17.02.2023.
//

import Foundation

protocol MovieDetailViewModel: BaseViewModel {
  var stateClosure: ((Result<MovieDetailViewModelImpl.ViewInteractivity, Error>) -> ())? { get set }

  var isFavorite: Bool { get }
  func addToFavorites()
  func removeFromFavorites()

  func getMovieDetail() -> Movie?
}

final class MovieDetailViewModelImpl: MovieDetailViewModel {
  var stateClosure: ((Result<ViewInteractivity, Error>) -> ())?

  private var movieDetail: Movie?

  private let apiService: MovieService
  private let id: String
  init(apiService: MovieService, movieId: String) {
    self.apiService = apiService
    self.id = movieId
  }

  func start() {
    fetchMovieDetail()
  }

  private func fetchMovieDetail() {
    apiService.getMovieDetail(with: self.id, onSuccess: didSucceed, onFailure: didFail)
  }

  private func didSucceed(_ detail: Movie) {
    movieDetail = detail
    self.stateClosure?(.success(.didFetchMovieDetail))
  }

  private func didFail(_ error: ResponseError) {
    self.stateClosure?(.failure(error))
  }
}

extension MovieDetailViewModelImpl {
  enum ViewInteractivity {
    case didFetchMovieDetail
  }
}

extension MovieDetailViewModelImpl {
  var isFavorite: Bool {
    UserDefaults.standard.bool(forKey: self.id)
  }

  func addToFavorites() {
    UserDefaults.standard.set(true, forKey: self.id)
  }

  func removeFromFavorites() {
    UserDefaults.standard.removeObject(forKey: self.id)
  }

  func getMovieDetail() -> Movie? {
    movieDetail
  }
}
