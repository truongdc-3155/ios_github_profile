//
//  APIService.swift
//  github_profile
//
//  Created by dang.chi.truong on 10/5/26.
//

import Foundation


final class APIService {
    static let shared = APIService()
    private init() {}

    func searchUsers(query: String) async throws -> [User] {
        guard let encoded = query.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed),
              let url = URL(string: "https://api.github.com/search/users?q=\(encoded)") else { return [] }
        let (data, _) = try await URLSession.shared.data(from: url)
        return try JSONDecoder().decode(UserSearchResponse.self, from: data).items
    }

    func getUserDetail(username: String) async throws -> User {
        let url = URL(string: "https://api.github.com/users/\(username)")!
        let (data, _) = try await URLSession.shared.data(from: url)
        return try JSONDecoder().decode(User.self, from: data)
    }
}
