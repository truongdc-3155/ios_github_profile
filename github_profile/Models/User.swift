//
//  User.swift
//  github_profile
//
//  Created by dang.chi.truong on 10/5/26.
//

import Foundation


struct User: Codable {
    let login: String
    let id: Int
    let avatarUrl: String
    let name: String?
    let bio: String?
    let location: String?
    let publicRepos: Int?
    let followers: Int?
    let following: Int?

    enum CodingKeys: String, CodingKey {
        case login, id, bio, location, name, followers, following
        case avatarUrl = "avatar_url"
        case publicRepos = "public_repos"
    }
}
