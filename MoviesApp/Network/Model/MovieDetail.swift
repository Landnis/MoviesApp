//
//  MovieDetailsResponse.swift
//  MoviesApp
//
//  Created by Konstantinos Stergiannis on 4/10/25.
//

import Foundation

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
        case id = "id"
        case title = "title"
        case overview = "overview"
        case posterPath = "poster_path"
        case backdropPath = "backdrop_path"
        case releaseDate = "release_date"
        case voteAverage = "vote_average"
        case voteCount = "vote_count"
        case genres = "genres"
        case runtime = "runtime"
    }
}

struct MovieCredits: Decodable {
    let id: Int?
    let cast: [Cast]?
    enum CodingKeys: String, CodingKey {
        case id = "id"
        case cast = "cast"
    }
}

struct Cast: Decodable {
    let adult: Bool?
    let gender: Int?
    let id: Int?
    let knownForDepartment: String?
    let name: String?
    let originalName: String?
    let popularity: Double?
    let profilePath: String?
    let castId: Int?
    let character: String?
    let creditId: String?
    let order: Int?
    
    enum CodingKeys: String, CodingKey {
        case adult = "adult"
        case gender = "gender"
        case id = "id"
        case name = "name"
        case popularity = "popularity"
        case character, order
        case knownForDepartment = "known_for_department"
        case originalName = "original_name"
        case profilePath = "profile_path"
        case castId = "cast_id"
        case creditId = "credit_id"
    }
}
