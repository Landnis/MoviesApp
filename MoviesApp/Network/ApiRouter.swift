//
//  ApiRouter.swift
//  MoviesApp
//
//  Created by Konstantinos Stergiannis on 1/10/25.
//

import Foundation
import Alamofire

protocol ApiRouter: URLRequestConvertible {
    var url: URL { get }
    var path: String { get }
    var method: HTTPMethod { get }
}

