# Lab 4 : TableViews and CollectionViews #


## Due Date ##
Tuesday, March 7th at 11:59 pm

## Overview ##

In this lab you'll get to see how tableviews and collectionviews are typically implemented in an iOS app. We'll be building a simple Pokedex app that displays a list of different Pokemon by category and allows you to view their statistics.

To begin this lab, clone this repository onto your own computer:
	
	git clone https://github.com/iosdecal/ios-decal-lab4

## Getting Started 

Open the project in Xcode and go into the project navigator. You'll notice that the following files have been created and implemented or partially implemented for you:

1. `pokeData.json` - this is our data file which contains information for over 600 Pokemon in JSON format. You will not need to do anything with this file. 
2. `Pokemon.swift` in the `Model` folder - this is the model for Pokemon objects. Take a look at all the variables we are keeping track of. Note that there is not much code in this file - we simply use it to store and access the properties of each Pokemon. You do not need to edit any code here.
3. `PokemonGenerator.swift` in the `Model` folder - this file contains a useful function which goes through the JSON file and generates an array of Pokemon objects for us. It also stores a dictionary mapping integer values to all of the possible categories of Pokemon. You will need to reference this dictionary in the first part of the lab.
4. `SearchViewController.swift` in the `Controllers` folder - this is the initial view controller which handles category selection. You will have to implement all of the collectionview functionality for this class.
5. `CategoryViewController.swift` in the `Controllers` folder - displays a list of Pokemon which belong to the selected category. You will have to implement all of the tableview functionality for this class.
6. `PokemonInfoViewController.swift` in the `Controllers` folder - displays an expanded view of the statistics for a single Pokemon. You do not need to edit any code in this file, but you still need to handle the segue from `CategoryViewController` to `PokemonInfoViewController` and the passing of data.

In `Main.storyboard`, you'll see three screens corresponding to each of our three view controllers. The third one has already been set up, but you need to complete the first two, as well as handle all navigation between screens. 

Also notice images of all 18 categories in the `Assets.xcassets` folder. 

Now, let's go ahead and get started! 

## Part 1: Navigation ##
Before we start writing any code, let's make sure that the flow of our app is completely fleshed out. Go to `Main.storyboard` and complete the following tasks:
- **Create a segue** between `SearchViewController` and `CategoryViewController` and another one between `CategoryViewController` and `PokemonInfoViewController`. Both of these should be "show" type segues. Since we don't have an UI elements in those views yet, you'll need to need to Control+drag from the Document Outline or the yellow, circular icon at the top of each view controller. **Be sure to give the segues identifiers so that we can reference them from our code**. 
- Embed the first screen in a **navigation controller** (this will allow us to move freely back and forth between screens). You can do this either by dragging out a navigation controller and dragging a segue to `SearchViewController` as its root view controller, or by clicking on `SearchViewController`, going to the Editor tab, and choosing Embed In > Navigation Controller. Also, **make sure that the navigation controller is set to our initial view controller in the attributes inspector**.

## Part 2: SearchViewController ##

Now we'll start implementing the collectionview in `SearchViewController`, which will display all of our 18 categories in a grid format. 

![](/README-images/collectionview.png)

- Still in `Main.storyboard`, drag out a collectionview onto the first screen and extend it so that it fills the whole screen, including the navigation bar segment (you'll need to set some constraints here). Notice that a small box appears in the top left corner of the collectionview - this is a prototype cell where you can design the layout for each collectionview cell. Extend the box to be a square that fills about a third of the width of the screen (ideally we want our grid to be something like six rows of three - see the image above). 
- Inside the prototype cell, place an imageview and set its constraints to fill the entire cell. 
- We need to create two outlets at this point: one for the collectionview itself and one for the imageview. The collectionview should be easy - just drag an outlet onto `SearchViewController`. However, the imageview isn't a property of the view controller, so it's outlet doesn't belong there! Instead, we need to create a class for our custom collectionviewcell that subclasses UICollectionViewCell. Once you've created this file, make sure to set the prototype cell's class in the identity inspector to your new class. Then, you can go ahead and create an outlet for the imageview in your new collectionviewcell class file.

Feel free to change background colors of the collectionview and/or cells to improve the UI, if you wish.

Head over to `SearchViewController.swift` now. The code for this section isn't too difficult, but there's many tedious things to take care of. By the end of this section, you should have implemented all of the collectionview's functionality.

Some things to consider:
- The view controller should be a subclass of UICollectionViewDataSource and UICollectionViewDelegate (this tells the program that the view controller is guaranteed to implement a certain set of functions that are relevant to the collectionview).
- In `viewDidLoad`, set the collectionview's delegate and datasource properties to self (this tells the collectionview that it should look within the view controller for the functions it needs to be functional).

You should implement the following collectionview functions:

	func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {}

	func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {}

	func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {}

You'll find the dictionary in `PokemonGenerator.swift` particularly useful for this section. You can reference the dictionary as follows:
	
	PokemonGenerator.categoryDict[/* some int */]

- In `cellForItemAt`, make sure to dequeue a cell object and cast it to the custom cell class you created before setting its properties. In order to dequeue the cell, you'll need to set a cell reuse identifier for your collectionview cell in `Main.storyboard` 
- In `didSelectItemAt` you'll need to implement the following functionality:
 - Use the `filteredPokemon(ofType type: Int)` function to get an array of Pokemon belonging to the selected category (based off the cell the user selected).
 - Then perform a segue to CategoryViewController using the identifier you created in Part 1. (Though we've only gone over triggering segues in Storyboard by control-dragging from a button, you can trigger a segue that you created in Storyboard between two view controllers programmatically by calling the following method in your code: `performSegue(withIdentifier: <YourSegueIdentifierFromStoryboard>, sender: <Any?>)`	
- Since we only want the CategoryViewController to display Pokemon from the category selected by the user, we need to create and implement the `prepareForSegue` method as well to pass along which Pokemon should be displayed. To do this, add the prepareForSegue method to the SearchViewController, and set the pokemonArray variable in the destination view controller (segue.destination) to your filtered array. (If you're having trouble at this step, check out the prepare for segue example in [Lecture 3](http://iosdecal.com/Lectures/Lecture3.pdf#page=28))

Once you've completed all of these steps, you should be able to run the program and see a grid of 18 different Pokemon categories. 

## Part 3: CategoryViewController ##

Our goal in this section is to display a list of all Pokemon that fit the search criteria (e.g. selecting "electric" should show us only electric type Pokemon). We'll use a tableview for this part, but the process will be very similar.

- Go back to `Main.storyboard` and this time, place a tableview fitting the entire screen on `CategoryViewController`. You won't see a prototype cell automatically this time, but you can drag out a tableview cell and drop it on the tableview to see this. Extend the height of the cell to be a reasonable amount (about 80-100 should be good). 
- We want to display four things on each cell: the name, number, key stats (attack/defense/health), and image for each Pokemon. Drag out the necessary UI elements and place them on the cell.

The format should look something like this (does not have to be exact):
![alt text](/README-images/tableviewcell.png)
