//
//  ViewController.swift
//  MoviesApp
//
//  Created by Konstantinos Stergiannis on 30/9/25.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet var startView: StrartingVew!
    override func viewDidLoad() {
        super.viewDidLoad()
        startView.backgroundColor = .red
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

