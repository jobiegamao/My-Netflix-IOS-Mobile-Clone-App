//
//  BoxButton.swift
//  netflixclone_swift
//
//  Created by may on 2/26/23.
//

import UIKit

class BoxButton: UIButton {

	private let accentColor = UIColor(named: "NetflixRed")
	
	init(title: String, height: Double = 50.0, filled: Bool = true) {
		super.init(frame: .zero)
		
		
		if filled{
			backgroundColor = accentColor
			setTitleColor(UIColor.init(white: 1, alpha: 0.5), for: .disabled)
			setTitleColor(.white, for: .normal)
		}else{
			layer.borderWidth = 1
			layer.borderColor = accentColor?.cgColor
			setTitleColor(UIColor.init(white: 1, alpha: 0.5), for: .disabled)
			setTitleColor(accentColor, for: .normal)
		}
		
		setTitle(title, for: .normal)
		titleLabel?.font = .systemFont(ofSize: 20, weight: .bold)
		layer.cornerRadius = 10
		
		
		translatesAutoresizingMaskIntoConstraints = false
		heightAnchor.constraint(equalToConstant: height).isActive = true
		isEnabled = false
	}
	
	required init?(coder: NSCoder) {
		fatalError()
	}
}
