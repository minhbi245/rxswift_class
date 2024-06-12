//
//  CustomSegmentControl.swift
//  Rx_Messenger
//
//  Created by khanhnvm-macbook on 29/5/24.
//

import UIKit
import RxSwift
import RxCocoa
import RswiftResources

class CustomSegmentedControl: UIView {
    
    private let segmentedControl: UISegmentedControl
    private let bottomBorder: UIView
    private var borderLeadingConstraint: NSLayoutConstraint?
    
    let selectedSegmentIndex = BehaviorRelay<Int>(value: 0)
    let disposeBag = DisposeBag()
    
    init(items: [String]) {
        segmentedControl = UISegmentedControl(items: items)
        bottomBorder = UIView()
        bottomBorder.backgroundColor = R.color.primaryColor()
        super.init(frame: .zero)
        
        setupSegmentedControl()
        setupBottomBorder()
        setupConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupSegmentedControl() {
        segmentedControl.selectedSegmentIndex = 1
        segmentedControl.setTitleTextAttributes([.foregroundColor: UIColor.lightGray, .font: UIFont.systemFont(ofSize: 16)], for: .normal)
        segmentedControl.setTitleTextAttributes([.foregroundColor: Color.mainTextColor, .font: UIFont.boldSystemFont(ofSize: 16)], for: .selected)
        segmentedControl.backgroundColor = .clear
        segmentedControl.selectedSegmentTintColor = .clear
        segmentedControl.translatesAutoresizingMaskIntoConstraints = false
        addSubview(segmentedControl)
        
        segmentedControl.rx.selectedSegmentIndex
            .bind(to: selectedSegmentIndex)
            .disposed(by: disposeBag)
        
        segmentedControl.rx.selectedSegmentIndex
            .subscribe(onNext: { [weak self] index in
                self?.updateBottomBorderPosition(index: index)
            })
            .disposed(by: disposeBag)
    }
    
    private func setupBottomBorder() {
        bottomBorder.translatesAutoresizingMaskIntoConstraints = false
        addSubview(bottomBorder)
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            segmentedControl.leadingAnchor.constraint(equalTo: leadingAnchor),
            segmentedControl.trailingAnchor.constraint(equalTo: trailingAnchor),
            segmentedControl.topAnchor.constraint(equalTo: topAnchor),
            segmentedControl.bottomAnchor.constraint(equalTo: bottomAnchor),
            
            bottomBorder.heightAnchor.constraint(equalToConstant: 2),
            bottomBorder.bottomAnchor.constraint(equalTo: segmentedControl.bottomAnchor),
            bottomBorder.widthAnchor.constraint(equalTo: segmentedControl.widthAnchor, multiplier: 1.0 / CGFloat(segmentedControl.numberOfSegments))
        ])
        
        borderLeadingConstraint = bottomBorder.leadingAnchor.constraint(equalTo: leadingAnchor)
        borderLeadingConstraint?.isActive = true
    }
    
    private func updateBottomBorderPosition(index: Int) {
        let segmentWidth = segmentedControl.bounds.width / CGFloat(segmentedControl.numberOfSegments)
        borderLeadingConstraint?.constant = segmentWidth * CGFloat(index)
        
        UIView.animate(withDuration: 0.3) {
            self.layoutIfNeeded()
        }
    }
}
