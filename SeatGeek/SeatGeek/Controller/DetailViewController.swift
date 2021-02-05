//
//  DetailViewController.swift
//  SeatGeek
//
//  Created by Edgar Delgado on 1/25/21.
//

import UIKit

class DetailViewController: UIViewController {

    @IBOutlet weak var imgView: UIImageView!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var locationLabel: UILabel!
    @IBOutlet weak var viewTopConstraint: NSLayoutConstraint!
    
    let navItem = UINavigationItem()
    let backButton = UIButton(type: .custom)
    var heartButton = UIButton(type: .custom)
    
    var eventViewModel: EventViewModel? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavBar()
        setupNavigationBarItems()
        setupLabels()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(true)
        guard let eventViewModel = eventViewModel else { return }
        let idString = String(eventViewModel.id)
        print("viewWillDisappear() DetailVC")
        do {
            try UserDefaults.standard.setObject(eventViewModel, forKey: idString)
            print("->Set ID: \(idString)")
        } catch {
            print(error.localizedDescription)
        }
    }
    
    func setupNavBar() {
        let height: CGFloat = 44
        let statusBarHeight = UIApplication.shared.statusBarFrame.height
        viewTopConstraint.constant = height
        
        let navigationBar = UINavigationBar(frame: CGRect(x: 0, y: statusBarHeight, width: UIScreen.main.bounds.width, height: height))
        navigationBar.delegate = self as? UINavigationBarDelegate
        navigationBar.barTintColor = .white
        navigationBar.items = [navItem]
        
        view.addSubview(navigationBar)
        
        self.view.frame = CGRect(x: 0, y: height, width: UIScreen.main.bounds.width, height: (UIScreen.main.bounds.height-height))
    }
    
    func setupNavigationBarItems() {
        setupLeftBarButton()
        setupTitleView()
        setupRightBarButton()
    }
    
    func setupLeftBarButton() {
        backButton.setImage(#imageLiteral(resourceName: "back").withRenderingMode(.alwaysOriginal), for: .normal)
        backButton.addTarget(self, action: #selector(backBtnTapped), for: .touchUpInside)
        
        let backBarButtonItem = UIBarButtonItem(customView: backButton)
        backBarButtonItem.customView?.widthAnchor.constraint(equalToConstant: 24).isActive = true
        backBarButtonItem.customView?.heightAnchor.constraint(equalToConstant: 24).isActive = true
        
        navItem.leftBarButtonItem = backBarButtonItem
    }
    
    func setupTitleView() {
        let titleLabel = UILabel()
        titleLabel.numberOfLines = 0
        titleLabel.adjustsFontSizeToFitWidth = true
        titleLabel.font = UIFont.boldSystemFont(ofSize: 17)
        titleLabel.textAlignment = .center
        titleLabel.textColor = .black
        titleLabel.text = eventViewModel?.name
        navItem.titleView = titleLabel
    }
    
    func setupRightBarButton() {
        guard let eventViewModel = eventViewModel else { return }
        if eventViewModel.isFavorite {
            heartButton.setImage(#imageLiteral(resourceName: "heart").withRenderingMode(.alwaysOriginal), for: .normal)
        } else {
            heartButton.setImage(#imageLiteral(resourceName: "whiteHeart").withRenderingMode(.alwaysOriginal), for: .normal)
        }
        heartButton.addTarget(self, action: #selector(heartBtnTapped), for: .touchUpInside)
        
        let heartBarButtonItem = UIBarButtonItem(customView: heartButton)
        heartBarButtonItem.customView?.widthAnchor.constraint(equalToConstant: 24).isActive = true
        heartBarButtonItem.customView?.heightAnchor.constraint(equalToConstant: 24).isActive = true

        navItem.rightBarButtonItem = heartBarButtonItem
    }
    
    func setupLabels() {
        if let date = eventViewModel?.date, let location = eventViewModel?.location {
            dateLabel.text = eventViewModel?.utcToLocal(convert: date, to: "EEEE, dd MMM yyyy hh:mm a")
            locationLabel.text = location
        }
    }
    
    @objc func backBtnTapped() {
        self.dismiss(animated: true, completion: nil)
    }
    
    @objc func heartBtnTapped() {
        print("->heartBtnTapped")
        if eventViewModel?.isFavorite == true {
            print("->Switching to non favorite")
            eventViewModel?.isFavorite = false
            heartButton.setImage(#imageLiteral(resourceName: "whiteHeart").withRenderingMode(.alwaysOriginal), for: .normal)
        } else {
            print("->Switching to favorite")
            eventViewModel?.isFavorite = true
            heartButton.setImage(#imageLiteral(resourceName: "heart").withRenderingMode(.alwaysOriginal), for: .normal)
        }
    }
}
