//
//  RatingControl.swift
//  FoodTracker
//
//  Created by Prasanna Pegu on 12/01/16.
//  Copyright © 2016 Prasanna Pegu. All rights reserved.
//

import UIKit

class RatingControl: UIView {
	
	// MARK: Properties
	var rating = 0 {
		didSet {
			setNeedsLayout()
		}
	}
	var ratingButtons = [UIButton]()
	var spacing = 5
	var stars = 5
	
	
	// MARK: Initialization
	required init?(coder aDecoder: NSCoder) {
		super.init(coder: aDecoder)
		
		let emptyStartImage = UIImage(named: "emptyStar")
		let filledStarImage = UIImage(named: "filledStar")
		
		for _ in 0..<stars {
			let button = UIButton(frame: CGRect(x: 0, y: 0, width: 44, height: 44))
			
			button.setImage(emptyStartImage, forState: .Normal)
			button.setImage(filledStarImage, forState: .Selected)
			button.setImage(filledStarImage, forState: [.Highlighted, .Selected])
			
			button.adjustsImageWhenHighlighted = false
			
			button.addTarget(self, action: "ratingButtonTapped:", forControlEvents: .TouchDown)
			
			ratingButtons += [button]
			addSubview(button)
		}
	}
	
	override func layoutSubviews() {
		let buttonSize = Int(frame.size.height)
		var buttonFrame = CGRect(x: 0, y: 0, width: buttonSize, height: buttonSize)
		
		for (index, button) in ratingButtons.enumerate() {
			buttonFrame.origin.x = CGFloat(index * (buttonSize + spacing))
			button.frame = buttonFrame
		}
		
		updateButtonSelectionStates()
	}
	
	override func intrinsicContentSize() -> CGSize {
		return CGSize(width: 240, height: 44)
	}
	
	// MARK: Button Action
	
	func ratingButtonTapped(button: UIButton) {
		rating = ratingButtons.indexOf(button)! + 1
		
		updateButtonSelectionStates()
	}
	
	func updateButtonSelectionStates() {
		
		for (index, button) in ratingButtons.enumerate() {
			
			button.selected = index < rating
		}
	}

}
