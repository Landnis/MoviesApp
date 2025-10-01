//
//  MoviesResponse.swift
//  MoviesApp
//
//  Created by Konstantinos Stergiannis on 30/9/25.
//

import Foundation

struct MovieResponse: Decodable {
    let page: Int
    let results: [PopularMovies]
    
    enum CodingKeys: String, CodingKey {
        case page = "page"
        case results = "results"
    }
}

struct PopularMovies: Decodable {
    let id: Int
    let title: String
    let releaseDate: String
    let posterPath: String?
    
    enum CodingKeys: String, CodingKey {
        case id = "id"
        case title = "title"
        case releaseDate = "release_date"
        case posterPath = "poster_path"
    }
}

struct SearchResponse: Decodable {
    let page: Int
    let results: [SearchResult]
    
    enum CodingKeys: String, CodingKey {
        case page = "page"
        case results = "results"
    }
}

struct SearchResult: Decodable {
    let id: Int?
    let title: String?
    let name: String?
    let overview: String?
    let posterPath: String?
    let backdropPath: String?
    let mediaType: String?
    let releaseDate: String?
    let firstAirDate: String?
    let voteAverage: Double?
    let voteCount: Int?

    enum CodingKeys: String, CodingKey {
        case id
        case title
        case name
        case overview
        case posterPath = "poster_path"
        case backdropPath = "backdrop_path"
        case mediaType = "media_type"
        case releaseDate = "release_date"
        case firstAirDate = "first_air_date"
        case voteAverage = "vote_average"
        case voteCount = "vote_count"
    }
}

struct MovieDetail: Decodable {
    let id: Int?
    let title: String?
    let overview: String?
    let posterPath: String?
    let backdropPath: String?
    let releaseDate: String?
    let voteAverage: Double?
    let voteCount: Int?
    let genres: [Genre]?
    let runtime: Int?

    struct Genre: Decodable {
        let id: Int?
        let name: String?
    }

    enum CodingKeys: String, CodingKey {
        case id, title, overview
        case posterPath = "poster_path"
        case backdropPath = "backdrop_path"
        case releaseDate = "release_date"
        case voteAverage = "vote_average"
        case voteCount = "vote_count"
        case genres
        case runtime
    }
}
