//
//  MovieListViewModel.swift
//  InvioChallenge
//
//  Created by invio on 12.11.2022.
//

import Foundation

protocol MovieListViewModel: BaseViewModel {
    /// ViewModel ' den viewController' a event tetitkler.
    var stateClosure: ((Result<MovieListViewModelImpl.ViewInteractivity, Error>) -> ())? { set get }
    
    /// ViewController' daki tableView'in row sayısını döner.
    /// - Returns: Int
    func getNumberOfRowsInSection() -> Int
    
    /// ViewController' daki tableView için cell datasını döner.
    /// - Parameter indexPath: Görünür cell'in index'i
    /// - Returns: Movie datası
    func getMovieForCell(at indexPath: IndexPath) -> Movie?

    /// Yeni arama için önceki sonuçları temizler.
    func resetSearching()

    /// Aranacak olan title'ı set eder
    /// - Parameter title: Film adı
    func willSetSearchTitle(title: String)

    /// Arama işlemini başlatır.
    func searchMovies()

    /// Bir sonraki arama sayfası çekilebilir ise true döner.
    var isFetchEnabled: Bool { get set }

    /// Aranacak filmlerde bir sonraki sayfayı çeker.
    func willFetchNextPage()

    /// Son sayfa çekildiyse true döner.
    var isLastPage: Bool { get }
}

final class MovieListViewModelImpl: MovieListViewModel {
    
    var searchResult: Search = Search(movies: [],
                                      totalResults: "0",
                                      response: "False",
                                      error: nil)

    var isFetchEnabled: Bool = true
    var isLastPage: Bool {
      return searchResult.movies?.count == Int(searchResult.totalResults ?? "0")
    }
    var stateClosure: ((Result<ViewInteractivity, Error>) -> ())?

    private var page = 1
    private var searchTitle = ""
    private var isFirstPage: Bool {
      page == 1
    }

    private let apiService: MovieService
    init(apiService: MovieService) {
      self.apiService = apiService
    }

    func start() {
        self.stateClosure?(.success(.updateMovieList))
    }

    func searchMovies() {
      apiService.searchMovie(by: searchTitle, page: page, onSuccess: didSucceed, onFailure: didFail)
    }

    private func didSucceed(_ result: Search) {
      if result.error == nil {
        if isFirstPage {
          searchResult = result
        } else {
          searchResult.movies?.append(contentsOf: result.movies ?? [])
        }
        self.stateClosure?(.success(.updateMovieList))
      } else {
        self.stateClosure?(.failure(ResponseError(response: result.response, error: result.error ?? "")))
      }
    }

    private func didFail(_ error: ResponseError) {
      self.stateClosure?(.failure(error))
    }
}

// MARK: ViewModel to ViewController interactivity
extension MovieListViewModelImpl {
    enum ViewInteractivity {
        case updateMovieList
        case willBeginNewSearch
    }
}


// MARK: TableView DataSource
extension MovieListViewModelImpl {
    func getNumberOfRowsInSection() -> Int {
        return self.searchResult.movies!.count
    }
    
    func getMovieForCell(at indexPath: IndexPath) -> Movie? {
        guard let movie = self.searchResult.movies?[indexPath.row] else { return nil }
        return movie
    }

    func resetSearching() {
      page = 1
      isFetchEnabled = true
      searchResult = Search(movies: [],
                            totalResults: "0",
                            response: "False",
                            error: nil)
      self.stateClosure?(.success(.willBeginNewSearch))
    }

    func willFetchNextPage() {
        page += 1
        searchMovies()
    }

    func willSetSearchTitle(title: String) {
      searchTitle = title
    }
}
