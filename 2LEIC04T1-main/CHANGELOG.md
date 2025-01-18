# Changelog of Sprint 1

## Added features

### Create Account

    - Users can now easily sign up and create their accounts within the app.
    - Seamless registration process with minimal required information for quick setup.
    - Enhanced security measures ensure user data protection and privacy.
    - Personalized account creation experience tailored to individual preferences.

### Edit Profile

    - Introducing the ability for users to customize and manage their profiles effortlessly.
    - Easily update profile information such as name, etc.
    - Empowering users to maintain accurate and up-to-date profiles with ease.
    - Streamlined editing interface for a seamless user experience.
    - Improved user engagement and interaction through personalized profiles.

# Changelog of Sprint 2

In this second sprint, we've made significant strides in improving our codebase, enhancing our testing suite, fixing bugs, and maintaining the overall health of our project. Here are the key changes we've made:

**Code Refactoring and Design Improvements:**
- Refactored AlertDialog and TextField into custom classes, making for easier access and cleaner code.
- Created a new TextField widget to enable password hiding in the login and register pages.
- Created a new Confirm Dialog to allow the user to confirm his choice in important occasions.
- Created a file (widgets.dart) to simplify the widgets import process.
- Changed the names of the colors in the styles.dart file to improve syntax.
- Remade the Login Page to better accommodate the new feature (front and back end).
- Reworked the front-end of the Register Page to match the new Login Page design.
- Other minor design updates on several different files, not worth mentioning. 

**Back-End Upgrades:**
- Improved Firebase Storage image upload handler, simplifying the process.
- Updated the Edit Profile page functions, including more error-handling processes, as well as, implementing a condition to check if the username is already in use.
- Made a interface to handle password recovery via Firebase.
- Created elements in the Login and Edit Profile pages to enable the user to recover/change his password via the new interface.
- Added more error control checks to the Edit Profile and Login pages.

**Unit / Acceptance Tests:**
- Added acceptance tests for the Reset Password feature.
- Added acceptance tests for the Edit Profile feature/page.

**Bug Fixes:**
- Fixed some minor bugs related to overflow errors.
- Fixed other small issues and bugs.

### Added posts

    - Introduced the ability for users to create and view other users posts.
    - Users can now easily share their ways of recycling and eco-friendly ideas.
    - This is the primary feature of the app and encourages its users to recycle and connect while doing so.
    
### Added filters
    - You can now filter posts its product material.

### Added products
    - The user can now add products to the app.

# Changelog of Sprint 3

In this final sprint, we've polished the app to make sure it corresponds to our idealization, making significant improvements to the source code, enhancing our testing suite, fixing bugs, and enhancing the overall visual style of our project. Here are the key changes we've made:

[Sprint 3 Issue](https://github.com/FEUP-LEIC-ES-2023-24/2LEIC04T1/issues/21) / [Sprint 3 Pull Request](https://github.com/FEUP-LEIC-ES-2023-24/2LEIC04T1/pull/20)

**Unit / Acceptance Tests:**
- Added unit tests for the Material Filter and Bottom Navigation Bar widget.
- Improved the syntax for the other widgets tests, and added a few more tests.

**Code Refactoring and Design Improvements:**
- ***Reworked the Post class:***
  - Changed the class idealization to make it a widget instead of a `struct`.
  - Created a PostData `struct` to carry the post data passing the Firebase connection to the parent page instead of it being handled by the widget itself.

- ***Reworked the Filter class:***
  - Changed the class idealization to make it a widget instead of a function that showed a widget.
  - Improved the class data handling to parent classes.
  - Improved the widget's visual style.
  - Updated the app post-filtering logic to harbor the new class data handling.
 
- ***Reworked the HomePage:***
  - Improved general code readability.
  - Changed Icons to better differentiate the 2 add buttons and added tooltips to further explain the difference between the 2.
  - Fixed padding overflow bugs.
  - Improved code syntax using more accurate elements.
  - Added error prevention mechanisms for the 3 PostLoaders.

- ***Reworked the AddPost page:***
  - Improved page overall code readability. 
  - Added a button to let the user reset the page inputted data.
  - Added a feature to let the user see the image that he has selected. 
  - Updated the page's visual style to fit the project's overall style.
  - Upgraded the page Firebase functions to properly handle data upload.

- ***Reworked the AddProduct page:***
  - Improved page overall code readability. 
  - Updated the page's visual style to fit the project's overall style.
  - Upgraded the page Firebase functions to properly handle data upload.

- ***Reworked the PostPage:***
  - Improved page overall code readability.
  - Updated the page's visual style to fit the project's overall style.
  - Upgraded the page Firebase functions to properly handle data upload.

- Created a ProductPage to allow the user to see all posts regarding that product.
- Extracted the CustomBottomNavigationBar class from the HomePage file to a new widget file.
- Created a new CustomListSelector to handle selections in the AddPost and AddProduct pages.
- Updated several files reflecting the work done on the widget folder.
- Other minor design updates on several different files that aren't worth mentioning. 

**Bug Fixes and Efficiency Upgrades:**
- ***Reworked the app routing system:***
  - Made the routing system easier to follow and understand.
  - Upgraded the system efficiency by better managing the app's screen stack usage.
  - Added transition animations between pages to improve the user experience.
  - Added an AuthRouter class to handle the start of the app, redirecting the user to the HomePage or LoginPage accordingly.
  - Updated the main.dart file to implement this new routing system and improve code readability.

- Fixed a major bug that caused the HomePage to give a null operator error, not showing any type of information.
- Fixed a bug where the dialog that informs the user that the account was successfully created was not showing up and messing up the close of the page as well.
- Fixed warning regarding async gaps.
- Fixed some minor bugs related to overflow errors.
- Fixed other small issues and bugs.

**Android Devices Compatibility:**
- Updated the app's logo to give the app more personality.
- Updated the AndroidManifest.xml files adding missing permissions to access the phone's gallery and internet.

**Project Maintenance:**
- Updated the styles.dart file readability.
- Updated the project's Domain Model image and description.
- Removed unnecessary files and directories linked to Firebase tests.
- Committed some runtime files linked with some changes made in this merge request.
- Updated the project's import file system merging the 2 files being used previously.
