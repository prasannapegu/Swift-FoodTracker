//
//  MealTableViewController.swift
//  FoodTracker
//
//  Created by Prasanna Pegu on 12/01/16.
//  Copyright © 2016 Prasanna Pegu. All rights reserved.
//

import UIKit

class MealTableViewController: UITableViewController {
	
	// MARK: Properties
	
	var meals = [Meal]()
	
	
	override func viewDidLoad() {
		super.viewDidLoad()
		
		navigationItem.leftBarButtonItem = editButtonItem()
		
		
		if let savedMeals = loadMeals() {
			meals += savedMeals
		} else {
			// Load sample data
			loadSampleMeals()
		}
	}
	
	
	// MARK: Helper methods
	
	func loadSampleMeals() {
		let photo1 = UIImage(named: "meal1")!
		let meal1 = Meal(name: "Caprese Salad", rating: 4, photo: photo1)!
		
		let photo2 = UIImage(named: "meal2")!
		let meal2 = Meal(name: "Chicken and Potatoes", rating: 5, photo: photo2)!
		
		let photo3 = UIImage(named: "meal3")!
		let meal3 = Meal(name: "Pasta with Meatballs", rating: 4, photo: photo3)!
		
		meals += [meal1, meal2, meal3]
	}
	
	
	// MARK: - Table view data source
	
	override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
		return 1
	}
	
	override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return meals.count
	}
	
	override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
		let cellIdentifier = "MealTableViewCell"
		let cell = tableView.dequeueReusableCellWithIdentifier(cellIdentifier, forIndexPath: indexPath) as! MealTableViewCell
		
		let meal = meals[indexPath.row]
		
		cell.mealLabel.text = meal.name
		cell.photoImageView.image = meal.photo
		cell.ratingControl.rating = meal.rating
		
		return cell
	}
	
	

	// Override to support conditional editing of the table view.
	override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {

		// Return false if you do not want the specified item to be editable.
		return true
	}

	

	// Override to support editing the table view.
	override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
		if editingStyle == .Delete {

			// Delete the row from the data source
			meals.removeAtIndex(indexPath.row)
			
			saveMeals()
			
			tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
		} else if editingStyle == .Insert {
			// Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
		}
	}

	
	/*
	// Override to support rearranging the table view.
	override func tableView(tableView: UITableView, moveRowAtIndexPath fromIndexPath: NSIndexPath, toIndexPath: NSIndexPath) {
	
	}
	*/
	
	/*
	// Override to support conditional rearranging of the table view.
	override func tableView(tableView: UITableView, canMoveRowAtIndexPath indexPath: NSIndexPath) -> Bool {
	// Return false if you do not want the item to be re-orderable.
	return true
	}
	*/
	

	// MARK: - Navigation
	
	// In a storyboard-based application, you will often want to do a little preparation before navigation
	override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
		if segue.identifier == "ShowDetail" {
			let mealDetailViewController = segue.destinationViewController as! MealViewController
			
			if let selectedMealCell = sender as? MealTableViewCell {
				let indexPath = tableView.indexPathForCell(selectedMealCell)!
				let selectedMeal = meals[indexPath.row]
				mealDetailViewController.meal = selectedMeal
			}
		}
		else if segue.identifier == "AddItem" {
			print("Adding new meal")
		}
	}

	
	@IBAction func unwindToMealList(sender: UIStoryboardSegue) {
		if let sourceViewController = sender.sourceViewController as? MealViewController,
		meal = sourceViewController.meal {
			
			// Update the meal in the selected row
			if let selectedIndexPath = tableView.indexPathForSelectedRow {
				meals[selectedIndexPath.row] = meal
				tableView.reloadRowsAtIndexPaths([selectedIndexPath], withRowAnimation: .None)
			}
				
			// Add a new meal
			else {
				let newIndexPath = NSIndexPath(forRow: meals.count, inSection: 0)
				meals.append(meal)
				
				tableView.insertRowsAtIndexPaths([newIndexPath], withRowAnimation: .Bottom)
			}
			
			saveMeals()
			
			
		}
		
	}
	
	
	// MARK: NSCoding
	
	func saveMeals() {
		let isSuccessfulSave = NSKeyedArchiver.archiveRootObject(meals, toFile: Meal.ArchiveURL.path!)
		
		if !isSuccessfulSave {
			print("Failed to save meals.")
		}
	}
	
	func loadMeals() -> [Meal]? {

		return NSKeyedUnarchiver.unarchiveObjectWithFile(Meal.ArchiveURL.path!) as? [Meal]
	}
	
}
