//
//  ViewController.swift
//  WeatherAPP II
//
//  Created by JokerChuang on 2014/8/16.
//  Copyright (c) 2014年 JokerChuang. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet var city: UILabel!
    @IBOutlet var icon: UIImageView!
                            
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        // background image
        let background = UIImage(named: "Rainy-wallpaper.jpg")
        self.view.backgroundColor = UIColor(patternImage: background)
        
        self.city.text = "Taipei"
        self.icon.image = UIImage(named: "rainy")
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

