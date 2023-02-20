//
//  Movie.swift
//  InvioChallenge
//
//  Created by invio on 13.11.2022.
//

import Foundation

struct Movie: Codable, Equatable {
    var id: String
    var title: String
    var year: String
    var type: String
    var poster: String?
    var plot: String?
    var director: String?
    var writer: String?
    var actors: String?
    var country: String?
    var boxOffice: String?
    var duration: String?
    var language: String?
    var rating: String?
    
    enum CodingKeys: String, CodingKey {
        case id = "imdbID"
        case title = "Title"
        case year = "Year"
        case type = "Type"
        case poster = "Poster"
        case plot = "Plot"
        case director = "Director"
        case writer = "Writer"
        case actors = "Actors"
        case country = "Country"
        case boxOffice = "BoxOffice"
        case duration = "Runtime"
        case language = "Language"
        case rating = "imdbRating"
    }
    
    static func == (lhs: Movie, rhs: Movie) -> Bool {
        return lhs.id == rhs.id
    }
}
