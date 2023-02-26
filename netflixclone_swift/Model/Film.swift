//
// 
//  netflixclone_swift
//
//  Created by may on 1/16/23.
//

import Foundation

struct FilmResponse: Codable {
	let results: [Film]
}


struct Film: Codable {
	let id: Int
	let media_type: String?
	let title: String?
	let name: String? // in some categories, title == name
	let original_title: String?
	let original_name: String?
	let overview: String?
	let poster_path: String?
	let release_date: String?
	let genre_ids:  [Int]?
	let backdrop_path: String?
}


/*
 adult = 0;
 "backdrop_path" = "/5pMy5LF2JAleBNBtuzizfCMWM7k.jpg";
 "genre_ids" =             (
	 10752,
	 36,
	 18
 );
 id = 653851;
 "media_type" = movie;
 "original_language" = en;
 "original_title" = Devotion;
 overview = "The harrowing true story of two elite US Navy fighter pilots during the Korean War. Their heroic sacrifices would ultimately make them the Navy's most celebrated wingmen.";
 popularity = "407.211";
 "poster_path" = "/lwybGlEEJtXZM3ynY19PNwNlPn9.jpg";
 "release_date" = "2022-11-23";
 title = Devotion;
 video = 0;
 "vote_average" = "6.7";
 "vote_count" = 54;
},
*/
