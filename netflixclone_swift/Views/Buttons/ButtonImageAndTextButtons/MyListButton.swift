//
//  MyListButton.swift
//  netflixclone_swift
//
//  Created by may on 2/22/23.
//

import UIKit

class MyListButton: ButtonImageAndText {
	
	var filmModel: Film?

	init() {
		super.init(text: "My List", image: UIImage(systemName: "plus"))
		iconImageView.transform = self.iconImageView.transform.scaledBy(x: 1.5, y: 1.5)
		
		setImage(UIImage(systemName: "checkmark"), for: .selected)
		addTarget(self, action: #selector(downloadAction), for: .touchUpInside)
	}
	
	@objc private func downloadAction() {
//		guard let filmModel = self.filmModel else {return}
		print("downloadAction")
//		DataPersistenceManager.shared.downloadFilmWith(model: filmModel) { result in
//			switch result {
//				case .success():
//					NotificationCenter.default.post(Notification(name: NSNotification.Name("downloaded")))
//				case .failure(let error):
//					print(error, "MyListButton, downloadAction() ")
//			}
//		}
	}
	
	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}

}
