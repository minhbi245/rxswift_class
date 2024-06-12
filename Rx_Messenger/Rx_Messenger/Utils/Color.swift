//
//  Color.swift
//  Rx_Messenger
//
//  Created by khanhnvm-macbook on 29/5/24.
//

import Foundation
import UIKit

public enum Color {
    static var currentTheme: Theme = defaultThem
    static var defaultThem: Theme {
        .init(primary: .init(hex: "#5D20CD"),
              actionBackground: .init(hex: "#C8C5CD"),
              backgroundColor: .init(hex: "#FFFFFF"),
              mainTextColor: .init(hex: "#000000"))
    }
    static var primaryColor: UIColor { currentTheme.primary }
    static var actionBackground: UIColor { currentTheme.actionBackground }
    static var backgroundColor: UIColor { currentTheme.backgroundColor}
    static var mainTextColor: UIColor { currentTheme.mainTextColor }
}
// MARK: - Theme
extension Color {
    struct Theme {
        let primary: UIColor
        let actionBackground: UIColor
        let backgroundColor: UIColor
        let mainTextColor: UIColor
        
        init(primary: UIColor,
             actionBackground: UIColor,
             backgroundColor: UIColor,
             mainTextColor: UIColor) {
            self.primary = primary
            self.actionBackground = actionBackground
            self.backgroundColor = backgroundColor
            self.mainTextColor = mainTextColor
        }
    }
}

// MARK: - UserDefaults
extension Color {
    enum Key {
        public static let isDarkModeEnabled: String = "OngoUI.color.isDarkModeEnabled"
    }
    
    static var isDarkModeEnabled: Bool {
        get { return UserDefaults.standard.bool(forKey: Color.Key.isDarkModeEnabled) }
        set { UserDefaults.standard.setValue(newValue, forKey: Color.Key.isDarkModeEnabled) }
    }
}
