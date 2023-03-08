//
//  NewHotReusableViewsView.swift
//  netflixclone_swift
//
//  Created by may on 2/24/23.
//

import UIKit
import WebKit

class NewHotReusableViews: UIView {

	let webView: WKWebView = {
		let webview = WKWebView()
		webview.translatesAutoresizingMaskIntoConstraints = false
		webview.layer.cornerRadius = 10.0
		webview.layer.masksToBounds = true
		return webview
	}()
	
	lazy var placeholderImageView: UIImageView = {
		let piv = UIImageView(frame: self.webView.frame)
		piv.translatesAutoresizingMaskIntoConstraints = false
		piv.contentMode = .scaleAspectFill
		piv.layer.cornerRadius = 10.0
		piv.layer.masksToBounds = true
		
		piv.isHidden = true
		return piv
	}()
	
	lazy var tabView: VideoTabView = {
		let vtv = VideoTabView()
		return vtv
	}()
	
	let titleLabel: UILabel = {
		let label = UILabel()
		label.translatesAutoresizingMaskIntoConstraints = false
		label.font = .systemFont(ofSize: 18, weight: .bold)
		return label
	}()
	
	
	let descriptionLabel: UILabel = {
		let label = UILabel()
		label.translatesAutoresizingMaskIntoConstraints = false
		label.font = .systemFont(ofSize: 14)
		label.numberOfLines = 3
		label.textColor = UIColor.label.withAlphaComponent(0.5)
		return label
	}()
	
	let genreLabel: UILabel = {
		let label = UILabel()
		label.translatesAutoresizingMaskIntoConstraints = false
		label.font = .systemFont(ofSize: 14, weight: .regular)
		label.numberOfLines = 1
		label.textColor = .label
		return label
	}()
	
	let monthLabel: UILabel = {
		let label = UILabel()
		label.textColor = .label
		label.font = .systemFont(ofSize: 20, weight: .light)
		label.translatesAutoresizingMaskIntoConstraints = false
		return label
	}()
	
	let dayLabel: UILabel = {
		let label = UILabel()
		label.textColor = .label
		label.font = .systemFont(ofSize: 25, weight: .heavy)
		label.translatesAutoresizingMaskIntoConstraints = false
		return label
	}()
	
	
	let leftLabel: UILabel = {
		let label = UILabel()
		label.textColor = .label
		label.font = .systemFont(ofSize: 25, weight: .heavy)
		label.translatesAutoresizingMaskIntoConstraints = false
		return label
	}()
	
	func setWebViewRequest(selectedTitle: String, model: Film){
		
		GlobalMethods.shared.getYtVidURL(model: model) { [weak self] result in
			switch result{
				case .success(let url):
					let request = URLRequest(url: url)
					DispatchQueue.global(qos: .utility).async {
						self?.webView.load(request)
					}
				case .failure(_):
					DispatchQueue.main.async {
						self?.webView.isHidden = true
						self?.placeholderImageView.isHidden = false
					}
					
					guard let backdrop_path = model.backdrop_path else {return}
					let url = URL(string: posterBaseURL + backdrop_path)
					self?.placeholderImageView.sd_setImage(with: url)
			}
		}
	}
	
	
	override init(frame: CGRect) {
		super.init(frame: frame)
	}
		
	required init?(coder aDecoder: NSCoder) {
		super.init(coder: aDecoder)
	}

}
