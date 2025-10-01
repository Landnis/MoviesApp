//
//  ViewController.swift
//  MoviesApp
//
//  Created by Konstantinos Stergiannis on 30/9/25.
//

import UIKit

class LaunchViewController: UIViewController {

    @IBOutlet var startView: LaunchView!
    override func viewDidLoad() {
        super.viewDidLoad()
        startView.backgroundColor = UIColor(red: 116/255.0, green: 19/255.0, blue: 15/255.0, alpha: 1.0)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 5) { [weak self] in
            let movieScreenVC = MoviesScreenViewController()
            let navController = UINavigationController(rootViewController: movieScreenVC)
            navController.modalPresentationStyle = .fullScreen
            navController.isNavigationBarHidden = true
            self?.present(navController, animated: true, completion: nil)
        }
    }

}

