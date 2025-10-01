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
