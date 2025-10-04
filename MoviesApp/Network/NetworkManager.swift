//
//  NetworkManager.swift
//  MoviesApp
//
//  Created by Konstantinos Stergiannis on 30/9/25.
//

import Foundation
import Alamofire

class NetworkManager {
    static let shared = NetworkManager()
    private init() {}
    func request<responseData: Decodable>(target: AppRouter, decodable: responseData.Type) async throws -> responseData {
        let (data, response) = try await URLSession.shared.data(from: target.url)
        if let httpResponse = response as? HTTPURLResponse {
            debugPrint("Status code:", httpResponse.statusCode)
        }
        
        guard let httpResponse = response as? HTTPURLResponse,
              200..<300 ~= httpResponse.statusCode else {
            throw NSError(domain: "InvalidResponse", code: -1)
        }
        
        let decoded = try JSONDecoder().decode(responseData.self, from: data)
        return decoded
    }
}
