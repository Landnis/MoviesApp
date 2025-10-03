//
//  MoviesRouter.swift
//  MoviesApp
//
//  Created by Konstantinos Stergiannis on 1/10/25.
//

import Foundation
import Alamofire

enum AppRouter: ApiRouter {
    case popularMovies
    case searchMovie(textQuery: String)
    case movieDetail(id: Int)
    case creditsDetails(id: Int)
    
    var path: String {
        switch self {
        case .popularMovies:
            "/3/movie/popular?api_key="
        case .searchMovie:
            "/3/search/multi?api_key="
        case .movieDetail(let id):
            "/3/movie/\(id)?api_key="
        case .creditsDetails(let id):
            "/3/movie/\(id)/credits?api_key="
        }
    }
    
    var method: HTTPMethod {
        switch self {
        case .popularMovies, .searchMovie, .movieDetail, .creditsDetails:
                .get
        }
    }
    
    var url: URL {
           let apiKey = "6b2e856adafcc7be98bdf0d8b076851c"
           switch self {
           case .popularMovies:
               return URL(string: "https://api.themoviedb.org" + path + apiKey)!
           case .searchMovie(let query):
               let encodedQuery = query.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? ""
               let fullURL = "https://api.themoviedb.org" + path + apiKey + "&query=" + encodedQuery + "&page=1"
               return URL(string: fullURL)!
           case .movieDetail:
               return URL(string: "https://api.themoviedb.org" + path + apiKey)!
           case .creditsDetails:
               return URL(string: "https://api.themoviedb.org" + path + apiKey)!
           }
       }
    
    func asURLRequest() throws -> URLRequest {
        var request = URLRequest(url: url)
        request.method = method
        return request
    }
    
}
