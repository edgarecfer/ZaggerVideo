//
//  ModeloPrincipal.swift
//  zaggerEjemplo
//
//  Created by Edgar Cruz on 07/05/24.
//

import Foundation

struct ModeloPrincipal: Codable {
    var zags: [zagsList]?
}

struct zagsList: Codable {
    var user: userList?
    var zag: String?
    var caption: String?
    var zag_parent: ZagParent?
}

struct userList: Codable {
    var name: String?
    var username: String?
    var profile_picture_url: String?
    var biography: String?
}

struct ZagParent:Codable {
    var files: [FileUrl]?
}

struct FileUrl: Codable {
    var file_url: String?
}

