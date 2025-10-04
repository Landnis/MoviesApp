//
//  SearchResponse.swift
//  MoviesApp
//
//  Created by Konstantinos Stergiannis on 4/10/25.
//

import Foundation

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
        case id = "id"
        case title = "title"
        case name = "name"
        case overview = "overview"
        case posterPath = "poster_path"
        case backdropPath = "backdrop_path"
        case mediaType = "media_type"
        case releaseDate = "release_date"
        case firstAirDate = "first_air_date"
        case voteAverage = "vote_average"
        case voteCount = "vote_count"
    }
}
