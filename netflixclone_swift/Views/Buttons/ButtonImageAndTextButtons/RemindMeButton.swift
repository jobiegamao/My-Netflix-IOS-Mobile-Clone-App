import Combine
import UIKit

class RemindMeButton: ButtonImageAndText {
	
	private let viewModel = RemindMeViewViewModel()
	
	var filmModel: Film?
	
	override var isSelected: Bool {
		didSet{
			iconImageView.image = isSelected ? UIImage(systemName: "bell.fill") : UIImage(systemName: "bell")
		}
	}
	
	init() {
		super.init(text: "Remind Me", image: UIImage(systemName: "bell"))
		print(isSelected, "remindmebutton")
		iconImageView.image = isSelected ? UIImage(systemName: "bell.fill") : UIImage(systemName: "bell")
		addTarget(self, action: #selector(remindAction), for: .touchUpInside)
		
	}
	
	
	@objc private func remindAction() {
		print("remind")
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


/*
 
 var filmModel: Film? {
	 didSet {
		 print("didset")
		 guard let filmModel = filmModel else { return }
		 viewModel.isFilmInRemindMeList(film: filmModel) { [weak self] in
			 print($0)
			 self?.updateButtonImage(inRemindMeList: $0)
		 }
		 
	 }
 }
 @objc private func remindAction() {
	 print("remind")
	 guard let filmModel = filmModel else { return }
	 
	 viewModel.isFilmInRemindMeList(film: filmModel) { [weak self] in
		 if $0 { //if in the list, we can delete it. $0 is the boolResult of this closure
			 self?.viewModel.deleteFilm(model: filmModel, completion: { result in
				 // added completion here so when there is error in deleting, we can do something
				 if case .failure(let error) = result {
					 print(error.localizedDescription)
				 } else {
					 // if result is success, then update image since it is already deleted
					 self?.updateButtonImage(inRemindMeList: false)
				 }
			 })
		 }else{ //if not in list, then we add
			 self?.viewModel.addFilm(model: filmModel, completion: { result in
				 if case .failure(let error) = result {
					 print(error.localizedDescription)
				 } else {
					 self?.updateButtonImage(inRemindMeList: true)
				 }
			 })
		 }
	 }
 }
 
 		viewModel.$remindMeFilms.sink { [weak self] _ in
 			print("table reloaded")
 			guard let filmModel = self?.filmModel else { return }
 			self?.viewModel.isFilmInRemindMeList(film: filmModel) { [weak self] in
 				print($0)
 				self?.updateButtonImage(inRemindMeList: $0)
 			}
 		}
 		.store(in: &cancellables)
 
 private func updateButtonImage(inRemindMeList: Bool) {
	 
	 DispatchQueue.main.async {
		 self.iconImageView.image = inRemindMeList ? UIImage(systemName: "bell.fill") : UIImage(systemName: "bell")
	 }
	 
 
 }
 */
