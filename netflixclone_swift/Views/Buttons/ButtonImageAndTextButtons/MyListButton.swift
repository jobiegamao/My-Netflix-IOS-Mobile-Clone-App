//
//  MyListButton.swift
//  netflixclone_swift
//
//  Created by may on 2/22/23.
//

import UIKit

class MyListButton: ButtonImageAndText {
	
	private let viewModel = MyListViewViewModel()
	
	var filmModel: Film?
	
	private let rotationAnimation: CABasicAnimation = {
		let rotationAnimation = CABasicAnimation(keyPath: "transform.rotation.z")
		rotationAnimation.toValue = CGFloat.pi
		rotationAnimation.duration = 0.3
		rotationAnimation.repeatCount = 1
		return rotationAnimation
	}()
	
	override var isSelected: Bool {
		didSet{
			UIView.animate(withDuration: 0.3, animations: { [weak self] in
				guard let isSelected = self?.isSelected else {return}
				self?.iconImageView.image = isSelected ? UIImage(systemName: "checkmark") : UIImage(systemName: "plus")
				if let animation = self?.rotationAnimation{
					self?.iconImageView.layer.add(animation, forKey: "rotationAnimation")
				}
				
			})
		}
	}

	init() {
		super.init(text: "My List", image: UIImage(systemName: "plus"))
		iconImageView.transform = self.iconImageView.transform.scaledBy(x: 1.2, y: 1.2)
		iconImageView.image = isSelected ? UIImage(systemName: "checkmark") : UIImage(systemName: "plus")
		addTarget(self, action: #selector(MyListAction), for: .touchUpInside)
	}
	
	@objc private func MyListAction() {
		print("MyListAction")
		guard let filmModel = filmModel else { return }
		
		switch isSelected {
			case true:
				viewModel.deleteFilm(model: filmModel, completion: { [weak self] result in
					if case .failure(let error) = result {
						print(error.localizedDescription)
					} else {
						self?.isSelected.toggle()
					}
				})
			case false:
				viewModel.addFilm(model: filmModel, completion: { [weak self] result in
					if case .failure(let error) = result {
						print(error.localizedDescription)
					} else {
						self?.isSelected.toggle()
					}
				})
		}

	}
	
	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}

}
