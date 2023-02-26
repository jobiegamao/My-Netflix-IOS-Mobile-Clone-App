//
//  videoTabView.swift
//  netflixclone_swift
//
//  Created by may on 2/22/23.
//
import UIKit


class VideoTabView: UIView {
	
	
	//when film exists, only then it will show the buttons that needs the film data
	var buttons: [UIButton] = []{
		didSet {
			configureVideoTabView()
		}
	}
	
	
	let logoImageView: UIImageView = {
		let liv = UIImageView()
		liv.translatesAutoresizingMaskIntoConstraints = false
		liv.contentMode = .scaleAspectFill
		liv.clipsToBounds = true
		return liv
	}()
	
	
	// MARK: init()
	override init(frame: CGRect = .zero) {
		super.init(frame: frame)
		translatesAutoresizingMaskIntoConstraints = false
	}
	
	private func configureVideoTabView(){
		
		addSubview(logoImageView)
		//put buttons in stack
		let stack = UIStackView(arrangedSubviews: buttons)
		stack.spacing = 1
		stack.alignment = .trailing
		stack.translatesAutoresizingMaskIntoConstraints = false
		
		addSubview(stack)
		
		NSLayoutConstraint.activate([
			logoImageView.leadingAnchor.constraint(equalTo: leadingAnchor),
			logoImageView.topAnchor.constraint(equalTo: topAnchor),
			logoImageView.bottomAnchor.constraint(equalTo: bottomAnchor),
			logoImageView.trailingAnchor.constraint(lessThanOrEqualTo: stack.leadingAnchor),
			
			stack.topAnchor.constraint(equalTo: topAnchor),
			stack.trailingAnchor.constraint(equalTo: trailingAnchor),
			stack.bottomAnchor.constraint(equalTo: bottomAnchor),
			
		])
	}
	
	
	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	
}
