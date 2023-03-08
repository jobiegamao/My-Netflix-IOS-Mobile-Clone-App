//
//  GlobalMethods.swift
//  netflixclone_swift
//
//  Created by may on 2/21/23.
//

import Foundation
import UIKit

struct AppSettings {
	static var selectedProfileIDForKey = "selectedProfileID"
	static var selectedProfile: UserProfile?
	
}

class GlobalMethods {
	static let shared = GlobalMethods()

	private init() {}

	func getGenresFromAPI(genres_id: [Int], completion: @escaping (String) -> Void) {
		APICaller.shared.getGenreNames { result in
			switch result {
				case .success(let genreDict):
					var names = [String]()
					for id in genres_id{
						names.append(genreDict[id] ?? "")
					}
					completion(names.joined(separator: " \u{2022} "))
			
				case .failure(let failure):
					print(failure)
			}
		}
	}
	
	func getMonthAndDay(from dateString: String) -> (String, String)? {
		let dateFormatter = DateFormatter()
		dateFormatter.dateFormat = "yyyy-MM-d"
		
		if let date = dateFormatter.date(from: dateString) {
			let monthFormatter = DateFormatter()
			monthFormatter.dateFormat = "MMM"
			let month = monthFormatter.string(from: date)
			let dayFormatter = DateFormatter()
			dayFormatter.dateFormat = "d"
			let day = dayFormatter.string(from: date)
			
			return (month.uppercased(), day)
		} else {
			return nil
		}
	}
	
	
	func filterUpcoming(withArray arraylist: [Film]) -> [Film] {
		let dateFormatter = DateFormatter()
		dateFormatter.dateFormat = "yyyy-MM-dd"
		let today = Date()
//		guard let maxDate = dateFormatter.date(from: "2022-12-31") else { return arraylist}
		
		
		return arraylist.filter { film in
			if let releaseDateStr = film.release_date,
			   let releaseDate = dateFormatter.date(from: releaseDateStr) {
				return releaseDate > today
			}
			return false
		}
	}
	
	func getYtVidURL(model: Film, completion: @escaping (Result<URL, Error>) -> Void){
		
		let selectedTitle = model.name ?? model.title ?? model.original_title ?? model.original_name ?? "No Title"
		
		APICaller.shared.getFilmYoutubeVideo(query: selectedTitle + " trailer") { result in
			switch result {
				case .success(let searchResult):
	
					guard let url = URL(string: "https://www.youtube.com/embed/\(searchResult.id.videoId)") else {
						return
					}
					
					completion(.success(url))
					
				case .failure(let error):
					print("YT APIKey has reached max for the day")
					completion(.failure(error))
			}
		}
	}
	
	func getNearestViewController(of view: UIView) -> UIViewController? {
		var viewController: UIViewController?
		var responder: UIResponder? = view
		while responder != nil {
		   responder = responder?.next
		   if let nextResponder = responder as? UIViewController {
			   viewController = nextResponder
			   return viewController
		   }
		}
		
		return nil
	}
	
}
