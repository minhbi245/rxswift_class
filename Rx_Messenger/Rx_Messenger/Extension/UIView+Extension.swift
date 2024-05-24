//
//  UIView+Extension.swift
//  Rx_Messenger
//
//  Created by khanhnvm-macbook on 24/5/24.
//

import UIKit

extension UIView {
    func addConstraintsToFillSuperview(padding: UIEdgeInsets = .zero) {
        guard let superview = self.superview else {
            print("No superview for \(self).")
            return
        }
        
        translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            topAnchor.constraint(equalTo: superview.topAnchor, constant: padding.top),
            leadingAnchor.constraint(equalTo: superview.leadingAnchor, constant: padding.left),
            trailingAnchor.constraint(equalTo: superview.trailingAnchor, constant: -padding.right),
            bottomAnchor.constraint(equalTo: superview.bottomAnchor, constant: -padding.bottom)
        ])
    }
    
    func centerInSuperview(size: CGSize = .zero) {
        guard let superview = self.superview else {
            print("No superview for \(self).")
            return
        }
        
        translatesAutoresizingMaskIntoConstraints = false
        if size.width != 0 {
            widthAnchor.constraint(equalToConstant: size.width).isActive = true
        }
        if size.height != 0 {
            heightAnchor.constraint(equalToConstant: size.height).isActive = true
        }
        
        NSLayoutConstraint.activate([
            centerXAnchor.constraint(equalTo: superview.centerXAnchor),
            centerYAnchor.constraint(equalTo: superview.centerYAnchor)
        ])
    }
    
    func setSizeConstraints(size: CGSize) {
        translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            widthAnchor.constraint(equalToConstant: size.width),
            heightAnchor.constraint(equalToConstant: size.height)
        ])
    }
    
    func pinEdges(to otherView: UIView, padding: UIEdgeInsets = .zero) {
        translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            topAnchor.constraint(equalTo: otherView.topAnchor, constant: padding.top),
            leadingAnchor.constraint(equalTo: otherView.leadingAnchor, constant: padding.left),
            trailingAnchor.constraint(equalTo: otherView.trailingAnchor, constant: -padding.right),
            bottomAnchor.constraint(equalTo: otherView.bottomAnchor, constant: -padding.bottom)
        ])
    }
    
    func centerInView(_ otherView: UIView, size: CGSize = .zero) {
        translatesAutoresizingMaskIntoConstraints = false
        if size.width != 0 {
            widthAnchor.constraint(equalToConstant: size.width).isActive = true
        }
        if size.height != 0 {
            heightAnchor.constraint(equalToConstant: size.height).isActive = true
        }
        
        NSLayoutConstraint.activate([
            centerXAnchor.constraint(equalTo: otherView.centerXAnchor),
            centerYAnchor.constraint(equalTo: otherView.centerYAnchor)
        ])
    }
    
    func setSizeConstraints(to otherView: UIView, padding: UIEdgeInsets = .zero) {
        translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            widthAnchor.constraint(equalTo: otherView.widthAnchor, constant: padding.left + padding.right),
            heightAnchor.constraint(equalTo: otherView.heightAnchor, constant: padding.top + padding.bottom)
        ])
    }
}

