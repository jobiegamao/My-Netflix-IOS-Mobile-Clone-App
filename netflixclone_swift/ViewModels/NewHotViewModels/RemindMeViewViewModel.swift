//
//  RemindMeViewModel.swift
//  netflixclone_swift
//
//  Created by may on 3/6/23.
//

import Foundation
import Combine


class RemindMeViewViewModel: ObservableObject {
	
	private var subscriptions: Set<AnyCancellable> = []
	
	var user: UserAccount? = AppSettings.selectedProfile?.user
	var error: Error?

	@Published var remindMeFilms: [Film] = []
	

	func retrieveRemindMeFilms(completion: (() -> Void)? = nil) {
		guard let profile = AppSettings.selectedProfile else { return }
		print(profile.userProfileName)
		
		DatabaseManager.shared.collectionRemindMe()
			.sink(receiveCompletion: { [weak self] result in
				if case .failure(let error) = result {
					self?.error = error
				}
			}, receiveValue: { [weak self] arrayResult in
				let films = arrayResult.map { $0.film }
				self?.remindMeFilms = films
				completion?()
			})
			.store(in: &subscriptions)
	}
	
	
	func deleteFilm(model: Film, completion: @escaping (Result<Void,Error>) -> Void) {
		DatabaseManager.shared.collectionRemindMe(delete: model)
			.sink(receiveCompletion: { [weak self] result in
				if case .failure(let error) = result {
					self?.error = error
					completion(.failure(error))
				}
			}, receiveValue: { boolResult in
				print("deleted", boolResult)
				completion(.success(()))
			})
			.store(in: &subscriptions)

	}
	
	func addFilm(model: Film, completion: @escaping (Result<Void,Error>) -> Void){
		DatabaseManager.shared.collectionRemindMe(add: model)
			.sink(receiveCompletion: { [weak self] result in
				if case .failure(let error) = result {
					self?.error = error
					completion(.failure(error))
				}
			}, receiveValue: { boolResult in
				print("added remind me", boolResult)
				completion(.success(()))
			})
			.store(in: &subscriptions)

	}
}


/*
 
 The receiveCompletion closure is called when the publisher finishes emitting values, or when an error occurs. In this closure, the function checks if the result is a failure and sets the error property of self (which is a weak reference to the function's instance). This is done to handle any errors that may occur while fetching remind me films from the database.

 The receiveValue closure is called every time the publisher emits a value (i.e., an array of remind me films). In this closure, the function sets its remindMeFilms property to the array of fetched films, and calls the completion closure (if it's not nil) using the optional chaining syntax completion?(). This is done to notify the caller that the operation has completed and pass any necessary data.
 */
