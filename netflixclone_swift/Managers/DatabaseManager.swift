//
//  DatabaseManager.swift
//  netflixclone_swift
//
//  Created by may on 2/26/23.
//

import Foundation
import Firebase
import FirebaseFirestoreSwift
import FirebaseFirestoreCombineSwift
import Combine

enum FirebaseError: Error {
	case invalidData
}

class DatabaseManager {
	
	static let shared = DatabaseManager()
	
	let db = Firestore.firestore()
	let usersPath = "users" //collection of users == users table
	let profilesPath = "usersProfiles"
	
	func collectionUsers(add newUser: User) -> AnyPublisher<Bool, Error> {
		let userAccount = UserAccount(from: newUser)
		
		return db.collection(usersPath).document(userAccount.id).setData(from: userAccount)
			.map{ _ in true }
			.eraseToAnyPublisher()
	}
	
	func collectionUsers(retreive id: String) -> AnyPublisher<UserAccount, Error>{
		db.collection(usersPath).document(id).getDocument()
			.tryMap{ try $0.data(as: UserAccount.self) }
			.eraseToAnyPublisher()
	}
	
	func collectionUsers(for id: String, update fields: [String: Any]) -> AnyPublisher<Bool, Error>{
		db.collection(usersPath).document(id).updateData(fields)
			.map { _ in true }
			.eraseToAnyPublisher()
	}
	
	func collectionUsersProfiles(getProfilesOf userID: String) -> AnyPublisher<[UserProfile], Error> {
		db.collection(profilesPath).whereField("userID", isEqualTo: userID)
			.getDocuments()
			.tryMap(\.documents) //array of doc snapshots
			.tryMap{ snapshots in
				try snapshots.map({
					try $0.data(as: UserProfile.self)
				})
			}
			.eraseToAnyPublisher()
	}
	

	func collectionUserProfiles(add profile: UserProfile) -> AnyPublisher<UserProfile, Error> {
		db.collection(profilesPath).document(profile.id).setData(from: profile)
			.flatMap { _ -> AnyPublisher<UserProfile, Error> in
				return self.db.collection(self.profilesPath).document(profile.id).getDocument()
					.tryMap { snapshot -> UserProfile in
						guard let data = snapshot.data(),
							  let userProfile = try? Firestore.Decoder().decode(UserProfile.self, from: data)
						else {
							throw FirebaseError.invalidData
						}
						return userProfile
					}
					.eraseToAnyPublisher()
			}
			.eraseToAnyPublisher()
	}
}
