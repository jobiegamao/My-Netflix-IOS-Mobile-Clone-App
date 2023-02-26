//
//  InfoButton.swift
//  netflixclone_swift
//
//  Created by may on 2/24/23.
//

import UIKit


class InfoButton: ButtonImageAndText {

	var filmModel: Film?
	
	init() {
		super.init(text:"Info" , image: UIImage(systemName: "info.circle"))
		iconImageView.transform = self.iconImageView.transform.scaledBy(x: 1.2, y: 1.2)
		addTarget(self, action: #selector(infoAction), for: .touchUpInside)
	}
	
	@objc private func infoAction() {
		print("info")
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
