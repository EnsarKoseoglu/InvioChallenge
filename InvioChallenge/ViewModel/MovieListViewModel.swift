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
}

final class MovieListViewModelImpl: MovieListViewModel {
    
    var searchResult: Search = Search(movies: [Movie(id: "tt1568322", title: "Batman: Arkham City", year: "2011", type: "game", poster: "https://m.media-amazon.com/images/M/MV5BZDE2ZDFhMDAtMDAzZC00ZmY3LThlMTItMGFjMzRlYzExOGE1XkEyXkFqcGdeQXVyNTAyODkwOQ@@._V1_SX300.jpg"),
                                               Movie(id: "tt3139072", title: "Son of Batman", year: "2014", type: "movie",poster: "https://m.media-amazon.com/images/M/MV5BYjdkZWFhNzctYmNhNy00NGM5LTg0Y2YtZWM4NmU2MWQ3ODVkXkEyXkFqcGdeQXVyNTA0OTU0OTQ@._V1_SX300.jpg"),
                                               Movie(id: "tt1673430", title: "Superman/Batman: Apocalypse", year: "2010", type: "movie", poster: "https://m.media-amazon.com/images/M/MV5BMjk3ODhmNjgtZjllOC00ZWZjLTkwYzQtNzc1Y2ZhMjY2ODE0XkEyXkFqcGdeQXVyNTAyODkwOQ@@._V1_SX300.jpg"),
                                               Movie(id: "tt0233298", title: "Batman Beyond: Return of the Joker", year: "2000", type: "movie", poster: "https://m.media-amazon.com/images/M/MV5BNmRmODEwNzctYzU1MS00ZDQ1LWI2NWMtZWFkNTQwNDg1ZDFiXkEyXkFqcGdeQXVyNTI4MjkwNjA@._V1_SX300.jpg"),
                                               Movie(id: "tt0059968", title: "Batman", year: "1966–1968", type: "series", poster: "https://m.media-amazon.com/images/M/MV5BMTkzNDY5NTg5MF5BMl5BanBnXkFtZTgwNzI4NzM1MjE@._V1_SX300.jpg"),
                                               Movie(id: "tt1398941", title: "Superman/Batman: Public Enemies", year: "2009", type: "movie", poster: "https://m.media-amazon.com/images/M/MV5BZDc5NTFiMzgtZWJiOS00N2M1LWJmOGYtZmNjMzFhMzcxZjRiXkEyXkFqcGdeQXVyNTAyODkwOQ@@._V1_SX300.jpg"),
                                               Movie(id: "tt4870838", title: "Batman: Bad Blood", year: "2016", type: "movie", poster: "https://m.media-amazon.com/images/M/MV5BZWZiZmZhYmQtYjVkZi00MWIzLWEzM2MtYzhkNjliNzc2MTMwL2ltYWdlL2ltYWdlXkEyXkFqcGdeQXVyNTAyODkwOQ@@._V1_SX300.jpg"),
                                               Movie(id: "tt4324274", title: "Batman vs. Robin", year: "2015", type: "movie", poster: "https://m.media-amazon.com/images/M/MV5BMjI0ODY2MDE5Nl5BMl5BanBnXkFtZTgwMTk0NTcyNTE@._V1_SX300.jpg"),
                                               Movie(id: "tt7451284", title: "Batman Ninja", year: "2018", type: "movie", poster: "https://m.media-amazon.com/images/M/MV5BMjFlMDc2NGMtYjkyMS00MTlhLTgxNWItMmYxZjc5NzVhMGE0XkEyXkFqcGdeQXVyMTA4NjE0NjEy._V1_SX300.jpg"),
                                               Movie(id: "tt1282022", title: "Batman: Arkham Asylum", year: "2009", type: "game", poster: "https://m.media-amazon.com/images/M/MV5BMWE1MGI0ZmItNzU2My00Mzk5LThkNTMtMmFiMjRiZDNlNzkwXkEyXkFqcGdeQXVyNjgyODQ1Mzk@._V1_SX300.jpg")],
                                      totalResults: "7", response: "True", error: nil)
    
    var stateClosure: ((Result<ViewInteractivity, Error>) -> ())?
    
    func start() {
        self.stateClosure?(.success(.updateMovieList))
    }
}

// MARK: ViewModel to ViewController interactivity
extension MovieListViewModelImpl {
    enum ViewInteractivity {
        case updateMovieList
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
}
