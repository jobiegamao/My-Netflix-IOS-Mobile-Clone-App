//
//  MyListViewViewModel.swift
//  netflixclone_swift
//
//  Created by may on 3/9/23.
//

import Foundation
import Combine



class MyListViewViewModel: ObservableObject {
	
	private var subscriptions: Set<AnyCancellable> = []
	
	var user: UserAccount? = AppSettings.selectedProfile?.user
	var error: Error?

	@Published var myListFilms: [Film] = []


	func retrieveMyListFilms(completion: (() -> Void)? = nil) {
	
		DatabaseManager.shared.collectionMyList()
			.sink(receiveCompletion: { [weak self] result in
				if case .failure(let error) = result {
					self?.error = error
				}
			}, receiveValue: { [weak self] arrayResult in
				let films = arrayResult.map { $0.film }
				self?.myListFilms = films
				completion?()
			})
			.store(in: &subscriptions)
	}
	
	
	func deleteFilm(model: Film, completion: @escaping (Result<Void,Error>) -> Void) {
		DatabaseManager.shared.collectionMyList(delete: model)
			.sink(receiveCompletion: { [weak self] result in
				if case .failure(let error) = result {
					self?.error = error
					completion(.failure(error))
				}
			}, receiveValue: {  _ in
				completion(.success(()))
			})
			.store(in: &subscriptions)

	}
	
	func addFilm(model: Film, completion: @escaping (Result<Void,Error>) -> Void){
		DatabaseManager.shared.collectionMyList(add: model)
			.sink(receiveCompletion: { [weak self] result in
				if case .failure(let error) = result {
					self?.error = error
					completion(.failure(error))
				}
			}, receiveValue: { _ in
				completion(.success(()))
			})
			.store(in: &subscriptions)

	}
	
	
	
}
