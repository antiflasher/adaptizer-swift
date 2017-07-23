//
//  Adaptizer
//
//  Created by Anton on 15/07/2017.
//  Copyright © 2017 Anton Lovchikov. All rights reserved.
//

import Foundation
import UIKit



// MARK: USAGE
// 
// # Scaling through a list of explicit break points
// 1. Form a dictionary where 
//    key is in screenIdentifier format (see bellow)
//    value is in any fomat. Only that all values should be in one format
//    values should store EXACT what you want to get on different screens sizes
//    values can be Doubles for constraint counstants for exmple of font size
//    values can be Strings for adaptive lable text
//    values can be Bools for hiding some elements or whatever
// 2. Call .scaled in your dictionary to get a value for current screen size

// # Scaling through a list of multipliers applied to an original value
// 1. Form a dictionary likewise described previously ↑
//    only values should store MULTIPLIERS for different screen sizes
// 2. Call scaled-function simply by adding .scaled to a Double / Float /CGFloat / Int value.










// MARK: LIST OF BREAK POINTS

// Screen identifiers used for the list of break points.

// w320  >  wC  iPhone  iPad
// w375  >  wC  iPhone  iPad
// w414  >  wC  iPhone
// w438  >  wC          iPad
// w504  >  wC          iPad
// w507  >  wC          iPad
// w551  >  wC          iPad
// w568  >  wC  iPhone
// w639  >  wC          iPad
// w667  >  wC  iPhone
// -------------------------
// w678  >  wR          iPad
// w694  >  wR          iPad
// w736  >  wR  iPhone
// w768  >  wR          iPad
// w782  >  wR          iPad
// w834  >  wR          iPad
// w981  >  wR          iPad
// w1024 >  wR          iPad
// w1112 >  wR          iPad
// w1366 >  wR          iPad

// You can use only those you care about.
// F.x [w375 : 100, w1366.default : 200, wR.pad : 300].
// For screen sizes you haven't set value .default value will be used.
// If you haven't set .default value, well the first dictionary value will be used,
// it's almost arbitrary value, you know :)
// 
// Conflicts:
// Are solved towards more specified identifier.
// F.x [w320 : 100, wC.iPhone : 120, wC.all : 140] will be soleveed this way:
// On screen width of 320, value of 100 will be used as the most specified.
// On screen width of 375 for iPhone, value 120 will be used as more specified than wC.all.
// On screen width of 414 for all devices, value of 140 will be used.
//
// iPhones
let wAny        = ScreenIdentifier("wAny")  // Any screen, used as default
let w320        = ScreenIdentifier("w320")  // iPhone 5, 5s, SE in Portrait
let w375        = ScreenIdentifier("w375")  // iPhone 6, 7 in Portrait
let w414        = ScreenIdentifier("w414")  // iPhone 6+, 7+ in Portrait
let w568        = ScreenIdentifier("w568")  // iPhone 5, 5s, SE in Landscape
let w667        = ScreenIdentifier("w667")  // iPhone 6, 7 in Landscape
let w736        = ScreenIdentifier("w736")  // iPhone 6+, 7+ in Landscape

// iPads
// w320                                     // iPad mini, iPad in Port/Land split view 1/3
// w375                                     // iPad Pro 12.9" in Port/Land split view 1/3
let w438        = ScreenIdentifier("w438")  // iPad mini, iPad in Portrait split view 2/3
let w504        = ScreenIdentifier("w504")  // iPad Pro 10.5" in Portrait split view 2/3
let w507        = ScreenIdentifier("w507")  // iPad mini, iPad in Landscape split view 1/2
let w551        = ScreenIdentifier("w551")  // iPad Pro 10.5" in Landscape split view 1/2
let w639        = ScreenIdentifier("w639")  // iPad Pro 12.9"in Portrait split view 2/3
let w678        = ScreenIdentifier("w678")  // iPad Pro 12.9"in Landscape split view 1/2
let w694        = ScreenIdentifier("w694")  // iPad mini, iPad in Landscape split view 2/3
let w768        = ScreenIdentifier("w768")  // iPad mini, iPad in Portrait full screen
let w782        = ScreenIdentifier("w782")  // iPad Pro 10.5" in Landscape split view 3/4
let w834        = ScreenIdentifier("w834")  // iPad Pro 10.5" in Portrait full screen
let w981        = ScreenIdentifier("w981")  // iPad Pro 12.9" in Landscape split view 3/4
let w1024       = ScreenIdentifier("w1024") // iPad Pro 12.9"in Portrait or iPad, iPad mini in Landscape full screen
let w1112       = ScreenIdentifier("w1112") // iPad Pro 10.5" in Landscape full screen
let w1366       = ScreenIdentifier("w1366") // iPad Pro 12.9"in Landscape full screen

// Compact size class
struct wC {
    static var all     : ScreenIdentifier { get { return ScreenIdentifier("wC_all") }}     // iPhones and iPads
    static var phone   : ScreenIdentifier { get { return ScreenIdentifier("wC_phone") }}   // iPhones only
    static var pad     : ScreenIdentifier { get { return ScreenIdentifier("wC_pad") }}     // iPads only
}

// Regular size class
struct wR {
    static var all     : ScreenIdentifier { get { return ScreenIdentifier("wR_all") }}     // iPhones and iPad
    static var phone   : ScreenIdentifier { get { return ScreenIdentifier("wR_phone") }}   // iPhones only
    static var pad     : ScreenIdentifier { get { return ScreenIdentifier("wR_pad") }}     // iPads only
}

// Container with screen identifier
struct ScreenIdentifier : Hashable {
    
    // Call .default to set this identifier as default value
    // It will be used in cases when there is no explicit identifier set
    var `default` : ScreenIdentifier {
        get {
            var updSelf = self
            updSelf.isDefault = true
            return updSelf }
    }
    
    
    // Technical stuff
    //
    var hashValue: Int {
        get { return stringValue.hash }
    }
    
    static func == (lhs: ScreenIdentifier, rhs: ScreenIdentifier) -> Bool {
        return
            lhs.hashValue == rhs.hashValue
    }
    
    private(set) var stringValue : String
    
    fileprivate init(_ value: String) {
        self.stringValue = value
    }
    
    fileprivate var isDefault : Bool = false
}



// Call .scaled to get one value out of the dictionary formed
extension Dictionary where Key == ScreenIdentifier {
    var scaled : Dictionary.Value {
        get {
            let value : Value = Adaptizer.valueForScreenWidth(self)
            return value
        }
    }
}





// MARK: LIST OF MULTIPLIERS

// Call .scaleRule to save the list of multipliers as rule for scaling
// round parameter determines if the result value should be rounded to the whole value
extension Dictionary where Key == ScreenIdentifier {
    
    func scalingRule(rounding: Bool = true) {
        if let dictionary = self as? [ScreenIdentifier : Double] {
            if dictionary.values.count > 0 {
                Adaptizer.setScalingRule(dictionary, withRounding:rounding)
            } else {
                print("Adaptizer can't set the scale rule: dictionary shouldn't be empty. Original value is used for all screens")
            }
        } else {
            print("Adaptizer can't set the scale rule. Expected dictionary format is [String : Double]. Provided dictionary format is [\(Dictionary.Key.self) : \(Dictionary.Value.self)]. Original value will be used for all screens")
        }
    }
}

// Calling scaled metrics.
// You can use Double, Float, CGFloat and Int.
// 20.scaled = 20.0.scaled = CGFloat(20).scaled 
// Since Adaptizer is created for interface tweaking, .scaled returns CGFloat!
//
extension Double {
    var scaled : CGFloat {
        get { return CGFloat(Adaptizer.scale(Double(self))) }
    }
}



extension Float {
    var scaled : CGFloat {
        get { return CGFloat(Adaptizer.scale(Double(self))) }
    }
}



extension CGFloat {
    var scaled : CGFloat {
        get { return CGFloat(Adaptizer.scale(Double(self))) }
    }
}



extension Int {
    var scaled : CGFloat {
        get { return CGFloat(Adaptizer.scale(Double(self))) }
    }
}





// MARK: PRIVATE
//
fileprivate class Adaptizer {
    
    
    
    fileprivate static func setScalingRule(_ rule: Dictionary<ScreenIdentifier, Double>, withRounding rounding: Bool) {
        self.scalingRule = rule
        self.rounding = rounding
    }
    
    fileprivate static var scalingRule : [ScreenIdentifier : Double]?
    fileprivate static var rounding : Bool = true

    
    
    fileprivate static func scale(_ originalValue: Double) -> Double {
        
        if let rule = scalingRule {
            let multiplier = valueForScreenWidth(rule)
            let semiresult = originalValue * multiplier
            let result = rounding ? round(semiresult) : semiresult
            return result
        } else {
            print("Adaptizer scale rule hasn't been set. Original value is used for all screens")
            return originalValue
        }
    }
    
    
    // Function shooses exact value based on screen width
    fileprivate static func valueForScreenWidth<T>(_ rule:[ScreenIdentifier : T]) -> T {
        
        // Device parameters
        let isLandscape = UIDevice.current.orientation.isLandscape
        let screenWidth = UIScreen.main.bounds.width
        let sizeClass = UIScreen.main.traitCollection.horizontalSizeClass
        let isPhone = UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiom.pad ? false : true
        
        // Find default value
        var defaultValue : T = rule.first!.value
        for (key,value) in rule {
            if key == ScreenIdentifier("wAny") { defaultValue = value ; break }
            else if key.isDefault { defaultValue = value ; break }
        }
        
        let sizeClassValue : T? = sift(sizeClass:sizeClass, rule:rule)
        let sizeClassDeviceValue : T? = sift(sizeClass:sizeClass, isPhone:isPhone, rule:rule)
        let widthOrientationValue : T? = sift(screenWidth:screenWidth, isLandscape:isLandscape, rule:rule)
        
        if sizeClassValue != nil {
            return sizeClassValue!
        } else if sizeClassDeviceValue != nil {
            return sizeClassDeviceValue!
        } else if widthOrientationValue != nil {
            return widthOrientationValue!
        } else {
            return defaultValue
        }
        
    }
    
    
    // Searching if there is wC.all or wR.all in the rule provided
    fileprivate static func sift<T>(sizeClass:UIUserInterfaceSizeClass, rule:[ScreenIdentifier : T]) -> T? {
        
        var targetValue : T?
        switch sizeClass {
            
        case .compact:
            if let value = rule[ScreenIdentifier("wC_all")] { targetValue = value }
            
        case .regular:
            if let value = rule[ScreenIdentifier("wR_all")] { targetValue = value }
            
        default:
            targetValue = nil
            
        }
        
        return targetValue
    }
    
    
    
    // Searching if there is wC.phone or wC.pad or wR.phone or wR.pad in the rule provided
    fileprivate static func sift<T>(sizeClass:UIUserInterfaceSizeClass, isPhone:Bool, rule:[ScreenIdentifier : T]) -> T? {
        
        var targetValue : T?
        switch sizeClass {
            
        case .compact:
            if isPhone { if let value = rule[ScreenIdentifier("wC_phone")] { targetValue = value }}
            else       { if let value = rule[ScreenIdentifier("wC_pad")]   { targetValue = value }}
            
        case .regular:
            if isPhone { if let value = rule[ScreenIdentifier("wR_phone")] { targetValue = value }}
            else       { if let value = rule[ScreenIdentifier("wR_pad")]   { targetValue = value }}
            
        default:
            targetValue = nil
            
        }
        
        return targetValue
    }
    
    

    // Searching if there is w3_5, w4_0, w4_7, w5_0, w7_9, w9_7, w10_5 or w12_9 in the rule provided
    fileprivate static func sift<T>(screenWidth:CGFloat, isLandscape:Bool, rule:[ScreenIdentifier : T]) -> T? {
        
        var targetValue : T?
        
        if screenWidth < 320, let value = rule[ScreenIdentifier("w320")] {
            targetValue = value
        } else if screenWidth >= 320 && screenWidth < 375, let value = rule[ScreenIdentifier("w320")] {
            targetValue = value
        } else if screenWidth >= 375 && screenWidth < 414, let value = rule[ScreenIdentifier("w375")] {
            targetValue = value
        } else if screenWidth >= 414 && screenWidth < 568, let value = rule[ScreenIdentifier("w414")] {
            targetValue = value
        } else if screenWidth >= 568 && screenWidth < 667, let value = rule[ScreenIdentifier("w568")] {
            targetValue = value
        } else if screenWidth >= 667 && screenWidth < 736, let value = rule[ScreenIdentifier("w667")] {
            targetValue = value
        } else if screenWidth >= 736 && screenWidth < 768, let value = rule[ScreenIdentifier("w736")] {
            targetValue = value
        } else if screenWidth >= 768 && screenWidth < 1024, let value = rule[ScreenIdentifier("w768")] {
            targetValue = value
        } else if screenWidth >= 1024 && screenWidth < 1366, let value = rule[ScreenIdentifier("w1024")] {
            targetValue = value
        } else if let value = rule[ScreenIdentifier("w1366")] {
            targetValue = value
        } else {
            targetValue = nil
        }
        
        return targetValue
    }
}

