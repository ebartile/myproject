#The Project
--
Your goal is to build a mobile application for the platform of your choice (between iOS and Android), using the provided JSON data for Offers. 

Your work should reflect your experience with the platform selected. Your app should contain 2 screens. Use a UINavigationController on iOS and a Toolbar on Android to structure the app. 

*Note: If you are implementing for iOS, please do not use Storyboards or Nib files. This will help us better evaluate your abilities.*

The details for each screen are as follows:

### Screen 1 (Offers)
* A collection of items displaying offers in a grid built to look like the Offers Mock contained in the project. This view should display all offers contained in the Offers.json data.
	* Fonts & Colors:
		* *Amount*
			* iOS: AvenirNext-DemiBold, 12 pt, #4A4A4A
          * Android: Roboto-Bold, 12 sp, #4A4A4A
		* *Name*
			* iOS: AvenirNext-Regular, 11 pt, #4A4A4A
	      * Android: Roboto-Regular, 11 sp, #4A4A4A
      * *Additional Notes*
	      * Margins are noted in the mock. There are a couple items that are not listed.
		      * Corner radius for the gray background: 5 pt
		      * The width of the gray background should be dictated by the width of the device minus the noted margins. The height of the gray background should be based on its ratio to the width to match the mock.
		      * The leading/trailing edges for the labels should line up with the gray background.
* In addition to the mock, please build a state for offer cells to indicate that an offer is favorited. This can be toggled in Screen 2 (Offer Detail). How this state of an offer is displayed is completely up to you.

![](Offers Mock.png)

### Screen 2 (Offer Detail)
* A detail screen to display when an offer is tapped. 
* A button to favorite/unfavorite an offer or otherwise mark it as something you would like to buy. **This state should also be reflected on the Offers screen as noted in the Offers screen requirements.**
* A mock has not been included for this screen, so please build whatever you would like utilizing the provided offers data.

### General Notes
* You can target the latest, or a very recent, version of the operating system. 
* You should assume the app will run on varying screen sizes, excluding tablets. 
* Feel free to pull in any libraries you'd like to assist in the development of your project.
* Loading images can be slow and memory intensive. We will be looking for an efficient and performant solution to this.
* Code should be legible, well formatted and commented.
* The UI/layouts should be as clean as possible.
* We would like to see at least one automated test written.
* Please keep in mind that this your opportunity to make a good first impression with the team. While the project does not need to be production ready, it should be ready for you to present to the team when you submit.

Deliverable
---
Please provide the code for the assignment either in a private repository (GitHub or Bitbucket) or as a zip file.
