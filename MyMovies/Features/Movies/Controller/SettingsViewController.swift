//
//  SettingsViewController.swift
//  MyMovies
//
//  Created by Vitor Spessoto on 03/03/21.
//

import UIKit

class SettingsViewController: UIViewController {

    //*************************************************
    // MARK: - Outlets
    //*************************************************
    @IBOutlet weak var swPlay: UISwitch!
    
    //*************************************************
    // MARK: - Lifecycle
    //*************************************************
    override func viewDidLoad() {
        super.viewDidLoad()
        swPlay.isOn = UserDefaults.standard.bool(forKey: "play")
    }
    
    //*************************************************
    // MARK: - IBActions
    //*************************************************
    @IBAction func changePlay(_ sender: UISwitch) {
        UserDefaults.standard.set(swPlay.isOn, forKey: "play")
    }
}
