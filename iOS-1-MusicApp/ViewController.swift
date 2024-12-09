//
//  ViewController.swift
//  iOS-1-MusicApp
//
//  Created by Khushi Mineshkumar Gor on 2024-12-08.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        let searchSongButton = UIButton(type: .system)
        searchSongButton.addTarget(self, action: #selector(openSearchSongs), for: .touchUpInside)
        view.addSubview(searchSongButton)
        
        let savedSongsButton = UIButton(type: .system)
        savedSongsButton.addTarget(self, action: #selector(openSavedSongs), for: .touchUpInside)
        view.addSubview(savedSongsButton)
    }

    
    @objc func openSearchSongs() {
            let searchVC = SearchTableViewController()
            navigationController?.pushViewController(searchVC, animated: true)
        }

        @objc func openSavedSongs() {
            let savedVC = SavedSongsTableViewController()
            navigationController?.pushViewController(savedVC, animated: true)
        }

}

