//
//  ProfileViewViewModel.swift
//  netflixclone_swift
//
//  Created by may on 2/27/23.
//

import Foundation
import Combine
import FirebaseAuth

class ProfileViewViewModel: ObservableObject {
	
	@Published var user: UserAccount?
	@Published var profiles: [UserProfile] = []
	@Published var error: Error?
	
	var subscriptions: Set<AnyCancellable> = []
	
	
	func retreiveUser() {
		guard let id = Auth.auth().currentUser?.uid else {return}
		DatabaseManager.shared.collectionUsers(retreive: id)
			.handleEvents(receiveOutput: { [weak self] userResult in
				self?.user = userResult
				self?.retreiveUserProfiles()
			})
			.sink { [weak self] completion in
				if case .failure(let error) = completion {
					self?.error = error
				}
			} receiveValue: { [weak self] userResult in
				self?.user = userResult
			}
			.store(in: &subscriptions)

	}
	
	func retreiveUserProfiles() {
		guard let userID = user?.id else { return }
		
		DatabaseManager.shared.collectionUsersProfiles(getProfilesOf: userID)
			.sink { [weak self] result in
				if case .failure(let error) = result {
					self?.error = error
				}
			} receiveValue: { [weak self] profileArrayResult in
				self?.profiles = profileArrayResult
			}
			.store(in: &subscriptions)

	}
	

	
	
}
