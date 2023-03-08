//
//  ButtonImageAndText.swift
//  netflixclone_swift
//
//  Created by may on 2/21/23.
//

import UIKit

enum Position {
	case top, left
}

class ButtonImageAndText: UIButton {
	
	let iconImageView: UIImageView = {
		let iconImageView = UIImageView()
		iconImageView.contentMode = .scaleAspectFit
		iconImageView.tintColor = .label
		iconImageView.translatesAutoresizingMaskIntoConstraints = false
		iconImageView.clipsToBounds = true
		
		return iconImageView
	}()
	
	let label: UILabel = {
		let label = UILabel()
		label.font = UIFont.systemFont(ofSize: 14, weight: .medium)
		label.textAlignment = .center
		label.numberOfLines = 1
		label.textColor = .label
		label.translatesAutoresizingMaskIntoConstraints = false
		
		return label
	}()
	
	
	
	init(text: String, image: UIImage?, iconPlacement: Position = .top) {
		super.init(frame: .zero)
		
		if let image = image {
			iconImageView.image = image
		}

		label.text = text
		

		addSubview(iconImageView)
		addSubview(label)

		// Set up constraints
		switch iconPlacement {
			case .top:
				iconOnTop()
			case .left:
				iconOnLeft()
		}
		
		
		translatesAutoresizingMaskIntoConstraints = false
		isUserInteractionEnabled = true
		
		sizeToFit()

	}
	
	private func iconOnTop(){
		NSLayoutConstraint.activate([
			iconImageView.centerXAnchor.constraint(equalTo: centerXAnchor),
			iconImageView.topAnchor.constraint(equalTo: topAnchor),

			label.topAnchor.constraint(equalTo: iconImageView.bottomAnchor, constant: 2),
			label.centerXAnchor.constraint(equalTo: centerXAnchor),
			label.leadingAnchor.constraint(equalTo: leadingAnchor),
			label.trailingAnchor.constraint(equalTo: trailingAnchor),
			label.bottomAnchor.constraint(equalTo: bottomAnchor)
		])

	}
	
	private func iconOnLeft(){
		NSLayoutConstraint.activate([
			iconImageView.centerYAnchor.constraint(equalTo: centerYAnchor),
			iconImageView.leadingAnchor.constraint(equalTo: leadingAnchor),
			iconImageView.bottomAnchor.constraint(equalTo: bottomAnchor),
			iconImageView.widthAnchor.constraint(equalToConstant: 30),
			
			label.centerYAnchor.constraint(equalTo: iconImageView.centerYAnchor),
			label.leadingAnchor.constraint(equalTo: iconImageView.trailingAnchor, constant: 20),
			label.trailingAnchor.constraint(equalTo: trailingAnchor),
			label.bottomAnchor.constraint(equalTo: bottomAnchor),
		])
	}
	
	
	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	
}
