//
//  YT_SearchResponse.swift
//  netflixclone_swift
//
//  Created by may on 1/25/23.
//

import Foundation

struct YoutubeResponse: Codable {
	let items: [YTSearchResult]
}

struct YTSearchResult: Codable {
	let id: YTVideo
}


// attributes are case sensitive
// base in JSON
struct YTVideo: Codable {
	let kind: String
	let videoId: String
}

/*
 {
 etag = NzTUFT02CDkgih6thEVN6Zj9KJ0;
 items = (
		{
			 etag = "zl4hBAo_w1P6FdJlPkW5LPMcjyY";
			 id = {
				 kind = "youtube#video";
				 videoId = KVLokPFNeaU;
				};
			 kind = "youtube#searchResult";
		},
		{
			 etag = eZ914G1m4rwqAalJ6rLdKgRJ7m8;
			 id = {
				 kind = "youtube#video";
				 videoId = "KaG5-aHUcq0";
				};
			 kind = "youtube#searchResult";
		},
		{
			 etag = "lk8409-m28s-u0WqMRhDC0vgfsE";
			 id = {
				 kind = "youtube#video";
				 videoId = 0Dj2kq5Neus;
			 };
			kind = "youtube#searchResult";
		},
		{
		 etag = br8hN1WnwfeuK8cmuvBIPZaEWiw;
		 id = {
			 kind = "youtube#video";
			 videoId = okUNLqtHRP8;
		 };
		 kind = "youtube#searchResult";
		},
		{
		 etag = "7UboJMIrQupqmQDzXlM_1RJx7Zk";
		 id =             {
			 kind = "youtube#video";
			 videoId = "71xBu_VHTfY";
		 };
		 kind = "youtube#searchResult";
		}
 );
 kind = "youtube#searchListResponse";
 nextPageToken = CAUQAA;
 pageInfo =     {
	 resultsPerPage = 5;
	 totalResults = 1000000;
 };
 regionCode = PH;
}
*/
