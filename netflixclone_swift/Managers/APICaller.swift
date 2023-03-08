//
//  APICaller.swift
//  netflixclone_swift
//
//  Created by may on 1/15/23.
// 	file to communicate with API calls
//

import Foundation

enum APIError: Error {
	case failedToGetData, failure
}

enum Categories {
	case Popular
	case Trending
	case Upcoming
	case TopRated
}

enum MediaType: String {
	case all, movie, tv
}

enum Language: String {
	case English = "en-US"
	case Filipino = "tg-PH"
}

public let posterBaseURL = "https://image.tmdb.org/t/p/w500/"




class APICaller {
	static let shared = APICaller()
	
	func getTrending(media_type: String = "all", time_period: String = "day", completion: @escaping (Result<[Film], Error>) -> Void){
		
		guard let url = URL(string: "\(Constants.baseURL)/3/trending/\(media_type)/\(time_period)?api_key=\(Constants.API_KEY)") else {return}
		
		 let task = URLSession.shared.dataTask(with: URLRequest(url: url)){ data, _, error in
			guard let data = data, error == nil else{
				return
			}
			do {
				let decodedJSON = try JSONDecoder().decode(FilmResponse.self, from: data)
				completion(.success(decodedJSON.results)) 
			} catch {
				completion(.failure(error))
			}
		}
		
		task.resume()
	}
	
	
	func getUpcoming(media_type: String, completion: @escaping (Result<[Film], Error>) -> Void){

		guard let url = URL(string: "\(Constants.baseURL)/3/\(media_type)/upcoming?api_key=\(Constants.API_KEY)" ) else {return}
		
		 let task = URLSession.shared.dataTask(with: URLRequest(url: url)){ data, _, error in
			guard let data = data, error == nil else{
				return
			}
			do {
				let decodedJSON = try JSONDecoder().decode(FilmResponse.self, from: data)
				let filtered = GlobalMethods.shared.filterUpcoming(withArray: decodedJSON.results)
				completion(.success(filtered))
			} catch {
				completion(.failure(error))
			}
		}
		
		task.resume()
	}
	
	
	func getPopular(media_type: String, completion: @escaping (Result<[Film], Error>) -> Void){
		
		// api url
		guard let url = URL(string: "\(Constants.baseURL)/3/\(media_type)/popular?api_key=\(Constants.API_KEY)") else {return}
		// start task download from url request
		let task = URLSession.shared.dataTask(with: URLRequest(url: url)) { data, _, error in
			//there should be data and no error
			guard let data = data, error == nil else{return}
			
			// if no error in task, then decode JSON data
			do{
				let decodedJSON = try JSONDecoder().decode(FilmResponse.self, from: data)
				completion(.success(decodedJSON.results))
			}catch{
				completion(.failure(error))
			}
		}
		
		task.resume()
	}
	
	func getTopRated(media_type: String, language: String, completion: @escaping(Result<[Film], Error>) -> Void){
		guard let url = URL(string: "\(Constants.baseURL)/3/\(media_type)/top_rated?api_key=\(Constants.API_KEY)&language=\(language)&page=1") else {return}
		
		let task = URLSession.shared.dataTask(with: URLRequest(url: url)) { data, _, error in
			guard let data = data, error == nil else {return}
			
			do {
				let decodedJSON = try JSONDecoder().decode(FilmResponse.self, from: data)
				completion(.success(decodedJSON.results))
			} catch {
				completion(.failure(error))
			}
		}
		
		task.resume()
	}

	
	func getDiscover(media_type: String, region: String = "PH", language: String = "fil-PH", page: Int = Int.random(in: 1...25), completion: @escaping(Result<[Film], Error>) -> Void){
		guard let url = URL(string: "\(Constants.baseURL)/3/discover/\(media_type)?api_key=\(Constants.API_KEY)&language=\(language)&region=\(region)&sort_by=popularity.desc&include_adult=false&include_video=false&page=\(page)&with_watch_monetization_types=flatrate") else {return}
		
		let task = URLSession.shared.dataTask(with: URLRequest(url: url)) { data, _, error in
			guard let data = data, error == nil else {return}
			
			do {
				let decodedJSON = try JSONDecoder().decode(FilmResponse.self, from: data)
				completion(.success(decodedJSON.results))
			} catch {
				completion(.failure(error))
			}
		}
		
		task.resume()
	}
	
	func search(with query: String, completion: @escaping(Result<[Film], Error>) -> Void){
		
		// format query to be placed in url "query=jane%20doe"
		guard let query = query.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed) else {return}
		guard let url = URL(string: Constants.baseURL + "/3/search/multi?api_key=\(Constants.API_KEY)&query=" + query) else {return}
		
		let task = URLSession.shared.dataTask(with: URLRequest(url: url)) { data, _, error in
			guard let data = data, error == nil else {return}
			
			do{
				let decodedJSON = try JSONDecoder().decode(FilmResponse.self, from: data)
				completion(.success(decodedJSON.results))
			}catch{
				completion(.failure(error))
			}
		}
		
		task.resume()
		
	}
	
	func getFilmYoutubeVideo(query: String, completion: @escaping (Result<YTSearchResult, Error>) -> Void){
		//format query
		guard let query = query.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed) else {return}

		guard let url = URL(string: Constants.YT_baseURL + "q=\(query)&key=\(Constants.YT_API_KEY)") else {return}

		let task = URLSession.shared.dataTask(with: URLRequest(url: url)) { data, _, error in
			guard let data = data, error == nil else {return}

			do{
				let decodedJSON = try JSONDecoder().decode(YoutubeResponse.self, from: data)
				completion(.success(decodedJSON.items[0]))
			}catch{
				completion(.failure(error))

			}
		}
		task.resume()
	}
	

	
	func getGenreNames(completion: @escaping (Result<[Int:String], Error>) -> Void){
		
		guard let urlMovie = URL(string: Constants.baseURL + "/3/genre/movie/list?api_key=" + Constants.API_KEY), let urlTv = URL(string: Constants.baseURL + "/3/genre/tv/list?api_key=" + Constants.API_KEY) else {return}
		
		var result = [Genre]()
		var genreDictionary = [Int:String]()
		
		var task = URLSession.shared.dataTask(with: URLRequest(url: urlMovie)) { data, _, error in
			guard let data = data, error == nil else {return}
			do{
				let decodedJSON = try JSONDecoder().decode(GenreResponse.self, from: data)
				result.append(contentsOf: decodedJSON.genres)
			}catch{
				completion(.failure(error))
			}
		}
		task.resume()
		
		task = URLSession.shared.dataTask(with: URLRequest(url: urlTv)) { data, _, error in
			guard let data = data, error == nil else {return}
			do{
				let decodedJSON = try JSONDecoder().decode(GenreResponse.self, from: data)
				result.append(contentsOf: decodedJSON.genres)
				_ = result.map{ r in
					genreDictionary[r.id] = r.name
				}
				completion(.success(genreDictionary))
			}catch{
				completion(.failure(error))
				
			}
		}
		task.resume()
	}
	
	
		
	
}


/*
//  check if api is working
 // call it in home
	func getFilmYoutubeVideo(query: String){
		//format query
		guard let query = query.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed) else {return}

		guard let url = URL(string: Constants.YT_baseURL + "q=\(query)&key=\(Constants.YT_API_KEY)") else {return}

		let task = URLSession.shared.dataTask(with: URLRequest(url: url)) { data, _, error in
			guard let data = data, error == nil else {return}

			do{
				let decodedJSON = try JSONSerialization.jsonObject(with: data)
				print(decodedJSON)
			}catch{
				print(error)

			}
		}
		task.resume()
	}
 
 
 //	https: //api.themoviedb.org/3/movie/upcoming?api_key=066463e142c0da07452286afef0de489&original_language=en
 
 //	https: //api.themoviedb.org/3/movie/popular?api_key=<<api_key>>&language=en-US&page=1
 //	https: //api.themoviedb.org/3/tv/popular?api_key=<<api_key>>&language=en-US&page=1
 */
