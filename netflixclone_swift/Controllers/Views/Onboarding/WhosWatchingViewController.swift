//
//  WhosWatchingViewController.swift
//  netflixclone_swift
//
//  Created by may on 3/1/23.
//

import UIKit
import Combine

class WhosWatchingViewController: UIViewController {
	
	private var viewModel = ProfileViewViewModel()
	private var subscriptions: Set<AnyCancellable> = []
	
	private var profiles = [UserProfile]()
	private var profileBtns = [ButtonImageAndText]()
	
	private let vcTitleLabel: UILabel = {
		let label = UILabel()
		label.translatesAutoresizingMaskIntoConstraints = false
		label.text = "Who's Watching?"
		label.font = UIFont.systemFont(ofSize: 25, weight: .heavy)
		label.sizeToFit()
		return label
	}()
	
	
	private lazy var myProfilesView: UICollectionView = {
		let cellSpacing = 15.0

		let layout = UICollectionViewFlowLayout()
		layout.scrollDirection = .vertical
		layout.minimumInteritemSpacing = cellSpacing
		layout.minimumLineSpacing = cellSpacing
		
		layout.itemSize = CGSize(width: 130, height: 130)

		// Create collection view
		let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
		cv.translatesAutoresizingMaskIntoConstraints = false
		cv.dataSource = self
		cv.delegate = self
		cv.register(UICollectionViewCell.self, forCellWithReuseIdentifier: "cell")
		
		return cv
	}()
	
	
	
	

	// MARK: - Main
	override func viewDidLoad() {
		super.viewDidLoad()
		title = vcTitleLabel.text
		view.backgroundColor = .systemBackground
		
		view.addSubview(vcTitleLabel)
		view.addSubview(myProfilesView)
		
		applyConstraints()
		bindViews()
	}
	
	override func viewWillAppear(_ animated: Bool) {
		super.viewWillAppear(animated)
		
		viewModel.retreiveUser()
	}
	
	
	
	
	// MARK: - Private Methods
	
	private func bindViews(){
		viewModel.$profiles.sink { [weak self] profileArrayResult in
			self?.profiles = profileArrayResult
			self?.profileBtns = profileArrayResult.map { userProfile in
				let btn = UserProfileButton(userProfile: userProfile)
				btn.heightAnchor.constraint(equalToConstant: 130).isActive = true
				btn.widthAnchor.constraint(equalToConstant: 130).isActive = true
				btn.label.font = .systemFont(ofSize: 20, weight: .semibold)
				btn.label.frame.origin.y -= 10
				
				btn.addTarget(self, action: #selector(self?.didTapProfileButton(_:)), for: .touchUpInside)
				
				return btn
			}
			
			DispatchQueue.main.async {
				self?.myProfilesView.reloadData()
			}
		}
		.store(in: &subscriptions)
		
	}
	
	@objc private func didTapProfileButton(_ sender: UserProfileButton){
		guard let userProfile = sender.userProfile  else { return  }
		AppSettings.selectedProfile = userProfile
		NotificationCenter.default.post(name: NSNotification.Name(rawValue: "selectedProfile"), object: nil)
		if let vc = navigationController?.viewControllers.first as? OnboardingViewController{
			vc.dismiss(animated: true){ [weak self] in
				let homeVC = HomeViewController()
				self?.navigationController?.pushViewController(homeVC, animated: true)
			
			}
		} else {
			dismiss(animated: true)
		}

//		if let navigationController = self.navigationController {
//			navigationController.popToRootViewController(animated: true)
//		}
		
				
				
	}

	
	
	private func applyConstraints(){
		NSLayoutConstraint.activate([
			vcTitleLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 15),
			vcTitleLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
			vcTitleLabel.heightAnchor.constraint(equalToConstant: 50),
			
			myProfilesView.topAnchor.constraint(equalTo: vcTitleLabel.bottomAnchor, constant: 50),
			myProfilesView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 50),
			myProfilesView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -50),
			myProfilesView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -50),
		])
	}



}

extension WhosWatchingViewController: UICollectionViewDataSource, UICollectionViewDelegate {

	func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
		return viewModel.profiles.count
	}

	func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
		let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath)

		cell.addSubview(profileBtns[indexPath.row])

		return cell
	}
	
	func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
		print(profiles[indexPath.row])
		
		
//		guard let vc = navigationController?.viewControllers.first as? OnboardingViewController else {return}
//		vc.dismiss(animated: true){ [weak self] in
//			AppSettings.selectedProfile = self?.profiles[indexPath.row]
//			print(AppSettings.selectedProfile)
//			let homeVC = HomeViewController()
//			self?.navigationController?.pushViewController(homeVC, animated: true)
		//
//		}
	}

}

