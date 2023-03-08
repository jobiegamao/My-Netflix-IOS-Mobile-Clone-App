//
//  RemindMeViewModel.swift
//  netflixclone_swift
//
//  Created by may on 3/6/23.
//

import Foundation
import Combine
import UserNotifications


class RemindMeViewViewModel: ObservableObject {
	
	private var subscriptions: Set<AnyCancellable> = []
	
	var user: UserAccount? = AppSettings.selectedProfile?.user
	var error: Error?

	@Published var remindMeFilms: [Film] = []
	
	let center: UNUserNotificationCenter = UNUserNotificationCenter.current()
	

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
			}, receiveValue: { [weak self] _ in
				self?.cancelReminderNotification(for: model)
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
			}, receiveValue: { [weak self] _ in
				self?.createNotification(for: model)
				completion(.success(()))
			})
			.store(in: &subscriptions)

	}
	
	private func createNotification(for model: Film){

		notificationPermission() { [weak self] granted in
			if granted {
				guard let modelTitle = model.title ?? model.original_title ?? model.name ?? model.original_name,
					  let releaseDateStr = model.release_date,
					  let profileID = AppSettings.selectedProfile?.id
				else { return }
				
				// DATE AND TIME NOTIF
				let dateFormatter = DateFormatter()
				dateFormatter.dateFormat = "yyyy-MM-dd"
				guard let releaseDate = dateFormatter.date(from: releaseDateStr) else {return}
				var notificationDateComponents = Calendar.current.dateComponents([.year, .month, .day], from: releaseDate)
				notificationDateComponents.hour = 9
				notificationDateComponents.minute = 10
				
				let trigger = UNCalendarNotificationTrigger(dateMatching: notificationDateComponents, repeats: false)
				
				// CONTENT
				let content = UNMutableNotificationContent()
				content.title = "\(modelTitle) is now streaming!"
				content.body = "Your Welcome."
				
				// ADD THE NOTIF
				let request = UNNotificationRequest(identifier: "\(profileID)_\(model.id)", content: content, trigger: trigger)
				self?.center.add(request)
				print("notification added")
			}
		}
	}
	
	private func notificationPermission(completion: @escaping (Bool) -> Void){
		
		center.getNotificationSettings { [weak self] settings in
			
			switch settings.authorizationStatus{
				case .denied, .notDetermined:
					self?.center.requestAuthorization(options: [.alert, .sound]) { granted, error in
						if let error = error {
							print(error)
							completion(false)
							return
						}
						
						if granted {
							completion(true)
						} else {
							print("notification not created as user denied it")
							completion(false)
						}
					}
				case .authorized:
					completion(true)
				
				default:
					completion(true)
			}
		}
		
		
	}
	
	private func cancelReminderNotification(for model: Film){
		guard let profileID = AppSettings.selectedProfile?.id else { return }
		let notificationID = "\(profileID)_\(model.id)"
		center.removePendingNotificationRequests(withIdentifiers: [notificationID])
		
	}
}


/*
 
 The receiveCompletion closure is called when the publisher finishes emitting values, or when an error occurs. In this closure, the function checks if the result is a failure and sets the error property of self (which is a weak reference to the function's instance). This is done to handle any errors that may occur while fetching remind me films from the database.

 The receiveValue closure is called every time the publisher emits a value (i.e., an array of remind me films). In this closure, the function sets its remindMeFilms property to the array of fetched films, and calls the completion closure (if it's not nil) using the optional chaining syntax completion?(). This is done to notify the caller that the operation has completed and pass any necessary data.
 */
