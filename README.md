# flutter Travel Expense Accountant

This flutter project contains the code for a multi-platform application (web/Linux/MacOS/Windows/Android/iOS) to create a formular for travel expenses. Dies entfernt die Notwendigkeit eines PDF Editors, welcher auf Mobilgeräten of nicht vorinstalliert ist oder schwieriger zu bedienen aufgrund des kleineren Displays im Vergleich zu Laptops etc. 

## Overview

The project is implemented using the Bloc pattern to handle state changes. Stateful Widgets are just used for the textfields which is a best practice also recommended by the Flutter dev team. 

# Storing of a template

To store a template for a website without any compromise on privacy, the information from the template is stored inside the URL and loaded back into the formula, when the URL is used. 
Information on how to use the website can be found in the [travel_expense_accountant](https://github.com/DanXCVII/travel_expense_accountant) repo.
