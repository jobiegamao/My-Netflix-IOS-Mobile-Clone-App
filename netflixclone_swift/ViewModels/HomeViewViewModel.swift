//
//  HomeViewViewModel.swift
//  netflixclone_swift
//
//  Created by may on 2/27/23.
//

import Foundation
import Combine
import FirebaseAuth

final class HomeViewViewModel: ObservableObject {
	
	private var subscriptions: Set<AnyCancellable> = []
	
	@Published var user: UserAccount?
	@Published var currentUserProfile: UserProfile?
	@Published var error: Error?
	
	
	
	func retrieveUser() {
		guard let id = Auth.auth().currentUser?.uid else {return}
		DatabaseManager.shared.collectionUsers(retrieve: id)
			.sink { [weak self] result in
				if case .failure(let error) = result {
					self?.error = error
				}
			} receiveValue: { [weak self] user in
				self?.user = user
			}
			.store(in: &subscriptions)
	}
	
	func retrieveCurrentUserProfile(profileID id: String, completion: @escaping (Result<UserProfile, Error>) -> Void?){
		DatabaseManager.shared.collectionUsersProfiles(getProfile: id)
			.sink { [weak self] result in
				if case .failure(let error) = result {
					self?.error = error
					completion(.failure(error))
				}
			} receiveValue: { userProfileResult in
				self.currentUserProfile = userProfileResult
				completion(.success(userProfileResult))
			}
			.store(in: &subscriptions)

	}
	
	
	
	
}

