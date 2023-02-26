//
//  PlaySmallButton.swift
//  netflixclone_swift
//
//  Created by may on 2/22/23.
//

import UIKit

class PlaySmallButton: ButtonImageAndText {

	var filmModel: Film?
	
	init() {
		super.init(text:"Play" ,image: UIImage(systemName:"play.fill"))
		addTarget(self, action: #selector(playAction), for: .touchUpInside)
	}
	
	@objc private func playAction() {
		print("play")
		guard let filmModel = filmModel else { return }
		
		let viewController = GlobalMethods.shared.getNearestViewController(of: self)

		if let vcFrom = viewController{
			let vcTo = FilmDetailsViewController()
			vcTo.configure(model: filmModel)
			
			vcFrom.present(vcTo, animated: true)
		}
	}
	
	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
   

}
