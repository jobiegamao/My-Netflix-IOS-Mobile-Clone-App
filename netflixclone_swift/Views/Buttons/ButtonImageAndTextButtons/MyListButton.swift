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
		addTarget(self, action: #selector(MyListAction), for: .touchUpInside)
	}
	
	@objc private func MyListAction() {
		print("MyListAction")

	}
	
	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}

}
