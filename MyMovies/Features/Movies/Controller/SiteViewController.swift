//
//  SiteViewController.swift
//  MyMovies
//
//  Created by Vitor Spessoto on 29/03/21.
//

import UIKit
import WebKit

class SiteViewController: UIViewController {
    
    //*************************************************
    // MARK: - Properties
    //*************************************************
    var url = String()
    
    //*************************************************
    // MARK: - Outlets
    //*************************************************
    @IBOutlet weak var wkWebview: WKWebView!
    
    //*************************************************
    // MARK: - Lifecycle
    //*************************************************
    override func viewDidLoad() {
        super.viewDidLoad()
        if let url = URL(string: url) {
            let request = URLRequest(url: url)
            
            wkWebview.load(request)
        }
    }
    
    //*************************************************
    // MARK: - IBAction
    //*************************************************
    @IBAction func close(_ sender: UIButton) {
        dismiss(animated: true, completion: nil)
    }
}
