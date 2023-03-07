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
	case invalidData, NoUserError
}

class DatabaseManager {
	
	static let shared = DatabaseManager()
	
	let db = Firestore.firestore()
	let usersPath = "users" //collection of users == users table
	let profilesPath = "usersProfiles"
	let mylistPath = "myList"
	let remindmePath = "remindMe"
	
	
	func collectionUsers(add newUser: User) -> AnyPublisher<Bool, Error> {
		let userAccount = UserAccount(from: newUser)
		
		return db.collection(usersPath).document(userAccount.id).setData(from: userAccount)
			.map{ _ in true }
			.eraseToAnyPublisher()
	}
	
	func collectionUsers(retrieve id: String) -> AnyPublisher<UserAccount, Error>{
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
	

	func collectionUsersProfiles(add profile: UserProfile) -> AnyPublisher<UserProfile, Error> {
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
	
	func collectionUsersProfiles(getProfile id: String) -> AnyPublisher<UserProfile, Error> {
		return db.collection(profilesPath).document(id).getDocument()
			.tryMap{ try $0.data(as: UserProfile.self) }
			.eraseToAnyPublisher()
	}
	
	func collectionMyList() -> AnyPublisher<[MyList], Error> {
		guard let userProfile = AppSettings.selectedProfile else {return Fail(error: FirebaseError.NoUserError).eraseToAnyPublisher()}
		
		return db.collection(mylistPath)
			.whereField("profile.id", isEqualTo: userProfile.id)
			.getDocuments()
			.tryMap(\.documents) //array of doc snapshots
			.tryMap{ snapshots in
				try snapshots.map({
					try $0.data(as: MyList.self)
				})
			}
			.eraseToAnyPublisher()
	}
	
	func collectionMyList(add model: Film) -> AnyPublisher<Bool, Error>{
		guard let userProfile = AppSettings.selectedProfile else {return Fail(error: FirebaseError.NoUserError).eraseToAnyPublisher()}
				
		let documentId = "\(userProfile.id)_\(model.id)"
		let data = MyList(id: documentId, film: model, profile: userProfile)
		
		return db.collection(mylistPath).document(documentId).setData(from: data)
			.map{ _ in true }
			.eraseToAnyPublisher()
	}
	
	
	func collectionMyList(delete model: Film) -> AnyPublisher<Bool, Error>{
		guard let userProfile = AppSettings.selectedProfile else {return Fail(error: FirebaseError.NoUserError).eraseToAnyPublisher()}
		
		let query = db.collection(mylistPath)
			.whereField("profile.id", isEqualTo: userProfile.id)
			.whereField("film.id", isEqualTo: model.id)
			.limit(to: 1)

		return query.getDocuments()
			.flatMap { (querySnapshot) -> AnyPublisher<Bool, Error> in
				guard let document = querySnapshot.documents.first else {
					return Fail(error: FirebaseError.invalidData).eraseToAnyPublisher()
				}
				return document.reference.delete()
					.map{ _ in true }
					.eraseToAnyPublisher()
			}
			.eraseToAnyPublisher()
	}
	
	
	func collectionRemindMe() -> AnyPublisher<[MyList], Error> {
		guard let userProfile = AppSettings.selectedProfile else {return Fail(error: FirebaseError.NoUserError).eraseToAnyPublisher()}
		
		return db.collection(remindmePath)
			.whereField("profile.id", isEqualTo: userProfile.id)
			.getDocuments()
			.tryMap(\.documents) //array of doc snapshots
			.tryMap{ snapshots in
				try snapshots.map({
					try $0.data(as: MyList.self)
				})
			}
			.eraseToAnyPublisher()
	}
	
	func collectionRemindMe(add model: Film) -> AnyPublisher<Bool, Error>{
		guard let userProfile = AppSettings.selectedProfile else {return Fail(error: FirebaseError.NoUserError).eraseToAnyPublisher()}
				
		let documentId = "\(userProfile.id)_\(model.id)"
		let data = RemindMe(id: documentId, film: model, profile: userProfile)
		
		return db.collection(remindmePath).document(documentId).setData(from: data)
			.map{ _ in true }
			.eraseToAnyPublisher()
	}
	
	
	func collectionRemindMe(delete model: Film) -> AnyPublisher<Bool, Error>{
		guard let userProfile = AppSettings.selectedProfile else {return Fail(error: FirebaseError.NoUserError).eraseToAnyPublisher()}
		
		let query = db.collection(remindmePath)
			.whereField("profile.id", isEqualTo: userProfile.id)
			.whereField("film.id", isEqualTo: model.id)
			.limit(to: 1)

		return query.getDocuments()
			.flatMap { (querySnapshot) -> AnyPublisher<Bool, Error> in
				guard let document = querySnapshot.documents.first else {
					return Fail(error: FirebaseError.invalidData).eraseToAnyPublisher()
				}
				return document.reference.delete()
					.map{ _ in true }
					.eraseToAnyPublisher()
			}
			.eraseToAnyPublisher()
	}
}
