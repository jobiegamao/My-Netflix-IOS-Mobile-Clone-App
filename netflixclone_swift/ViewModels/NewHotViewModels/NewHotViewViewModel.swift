//
//  NewHotViewViewModel.swift
//  netflixclone_swift
//
//  Created by may on 3/8/23.
//

import Foundation
import Combine

final class NewHotViewViewModel: ObservableObject {
	
	
	@Published var remindMeFilms: [Film] = []
	
	private var subscriptions: Set<AnyCancellable> = []
	
	func retrieveRemindMeFilms(completion: (() -> Void)? = nil) {
		
		DatabaseManager.shared.collectionRemindMe()
			.sink(receiveCompletion: { result in
				if case .failure(let error) = result {
					print(error.localizedDescription)
				}
			}, receiveValue: { [weak self] arrayResult in
				self?.remindMeFilms = arrayResult.map { $0.film }
				completion?()
			})
			.store(in: &subscriptions)
	}
	
}
