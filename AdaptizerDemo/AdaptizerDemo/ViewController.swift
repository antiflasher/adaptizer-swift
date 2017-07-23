//
//  ViewController.swift
//  AdaptizerDemo
//
//  Created by Anton on 23/07/2017.
//  Copyright © 2017 Anton Lovchikov. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var label: UILabel!
    @IBOutlet weak var labelTop: NSLayoutConstraint!
    @IBOutlet weak var smileImageView: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let title = [w320: "Adaptizer", w375: "It's Adaptizer", w414: "It is Adaptizer"].scaled
        let fontSize = [w320: 40, w375: 45, w414: 50].scaled.cgFloat
        let top = [w320: 60, w375: 70, w414: 80].scaled.cgFloat
        let smileVisibility = [wAny: false, w414: true].scaled
        
        label.text = title
        label.font = UIFont.systemFont(ofSize:fontSize, weight:1000)
        labelTop.constant = top
        smileImageView.isHidden = !smileVisibility
        
    }

}
