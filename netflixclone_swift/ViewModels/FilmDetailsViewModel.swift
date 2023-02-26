//
//  FilmDetailsViewModel.swift
//  netflixclone_swift
//
//  Created by may on 1/29/23.
//

import Foundation

struct FilmDetailsViewModel {
	let title: String
	let ytSearchResult: YTSearchResult
	let genre_ids: [Int]?
	let description: String
	
	let release_date: String?
}

