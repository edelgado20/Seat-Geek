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
    
    let backButton = UIButton(type: .custom)
    var heartButton = UIButton(type: .custom)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupNavigationBarItems()
        
//        //self.title = "Los Angeles Rams at Tampa Bay Buccaneers"
//        let label = UILabel(frame: CGRect(x: 0, y: 0, width: 200, height: 150))
//        label.backgroundColor = .clear
//        label.numberOfLines = 0
//        label.lineBreakMode = .byWordWrapping
//        label.sizeToFit()
//
//        label.font = UIFont.boldSystemFont(ofSize: 24.0)
//        label.adjustsFontSizeToFitWidth = true
//        label.textAlignment = .left
//        label.textColor = .white
//        label.text = "This is a multiline string for the navBar"
//        self.navigationItem.titleView = label
    }
    
    func setupNavigationBarItems() {
        //backButton.frame = CGRect(x: 0, y: 0, width: 20, height: 20)
        backButton.setImage(#imageLiteral(resourceName: "back").withRenderingMode(.alwaysOriginal), for: .normal)
        backButton.addTarget(self, action: #selector(backBtnTapped), for: .touchUpInside)
        
        let backBarButtonItem = UIBarButtonItem(customView: backButton)
        backBarButtonItem.customView?.widthAnchor.constraint(equalToConstant: 24).isActive = true
        backBarButtonItem.customView?.heightAnchor.constraint(equalToConstant: 24).isActive = true
        backBarButtonItem.customView?.backgroundColor = .brown
        navigationItem.leftBarButtonItem = backBarButtonItem
        
        // Add title label on navigationItem.titleView
        let titleLabel = UILabel(frame: CGRect(x: 0, y: 0, width: 50, height: 50))
        titleLabel.numberOfLines = 0
        //titleLabel.lineBreakMode = .byWordWrapping
        titleLabel.adjustsFontSizeToFitWidth = true
        titleLabel.font = UIFont.boldSystemFont(ofSize: 17.0)
        titleLabel.textAlignment = .left
        titleLabel.textColor = .white
        titleLabel.text = "Los Angeles Rams at Tampa Bay Buccaneers"
        titleLabel.backgroundColor = .blue
        navigationItem.titleView = titleLabel
        
        heartButton.setImage(#imageLiteral(resourceName: "heart").withRenderingMode(.alwaysOriginal), for: .normal)
        heartButton.addTarget(self, action: #selector(heartBtnTapped), for: .touchUpInside)
        
        let heartBarButtonItem = UIBarButtonItem(customView: heartButton)
        heartBarButtonItem.customView?.widthAnchor.constraint(equalToConstant: 24).isActive = true
        heartBarButtonItem.customView?.heightAnchor.constraint(equalToConstant: 24).isActive = true
        heartBarButtonItem.customView?.backgroundColor = .brown
        navigationItem.rightBarButtonItem = heartBarButtonItem
    }
    
    @objc func backBtnTapped() {
        print("back btn tapped")
        navigationController?.popViewController(animated: true)
    }
    
    @objc func heartBtnTapped() {
        print("tapped")
        heartButton.setImage(#imageLiteral(resourceName: "whiteHeart").withRenderingMode(.alwaysOriginal), for: .normal)
    }
}
