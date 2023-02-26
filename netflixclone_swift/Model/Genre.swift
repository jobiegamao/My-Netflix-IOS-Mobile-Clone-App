//
//  Genre.swift
//  netflixclone_swift
//
//  Created by may on 1/30/23.
//

import Foundation

struct GenreResponse: Codable {
	let genres: [Genre]
}
struct Genre: Codable {
	let id: Int
	let name: String
}
