//
//  MyLeaguesdViewController.swift
//  MyLeagues
//
//  Created by Guillaume Audinet on 28/07/2023.
//

import UIKit

class EnginedViewController: UIViewController {
    let engine: Engine

    init(engine: Engine) {
        self.engine = engine
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
//    func presentErrorAlert(message: String, okHandler: ((UIAlertAction) -> Void)? = nil) {
//        let alertController = UIAlertController(
//            title: "Erreur",
//            message: message,
//            preferredStyle: .alert
//        )
//        alertController.addAction(.init(title: "Ok", style: .default, handler: okHandler))
//        present(alertController, animated: true, completion: nil)
//    }
}
