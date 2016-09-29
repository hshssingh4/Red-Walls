//
//  ColorPalette.swift
//  Red Walls
//
//  Created by Harpreet Singh on 9/8/16.
//  Copyright © 2016 Harpreet Singh. All rights reserved.
//

import Foundation
import UIKit

// Custom class to manage and abstract out the color scheme of our app.
struct ColorPalette {
    static let BrandColor = UIColor(red: 0.0/255.0, green: 134.0/255.0, blue: 255.0/255.0, alpha: 1.0)
    static let LightGrayColor = UIColor.lightGray
    static let WhiteColor = UIColor.white
    static let BlackColor = UIColor.black
    static let RedColor = UIColor.red
    static let OrangeColor = UIColor.orange
    static let GreenColor = UIColor.green
    static let ClearColor = UIColor.clear
    static let CellColor = UIColor(red: 242.0/255.0, green: 242.0/255.0, blue: 242.0/255.0, alpha: 1.0)
    
    struct GradientColors {
        static let BlackClear = [UIColor.black.cgColor, UIColor.clear.cgColor]
    }
}
