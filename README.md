# MIDTERM BADGE EXAM  
## UI Artisan – Widget Literacy Badge  
### Group 7  

---

## Group Members & Roles

**Adrian Anunciacion**  
UI implementation, layout structure, testing, and documentation preparation.

**Aaron Lozano**  
Developer of application logic and OOP structure.

**EJ Pineda** 

Developer of application logic and OOP structure.

**Ed Castillo**  
Recorded and edited the demo video of the application.

**Khristian Pradilla**  
Contributed to UI design planning (Figma), captured screenshots, organized documentation files, and recorded the video.

---

## Project Overview

This project is a Flutter-based mobile application called **Daily Helper Toolkit**.  
The goal of this activity is to convert simple program logic into a working mobile app while applying proper Object-Oriented Programming (OOP) principles and demonstrating widget literacy.

The app contains three mini-tools:

- BMI Checker  
- Expense Splitter  
- Grade Calculator  

It also includes personalization features such as display name input and theme color selection.

---

## Chosen Modules

### 1. BMI Checker  
Allows the user to input height and weight to compute Body Mass Index (BMI) and display its category.

Features:
- Real-time BMI calculation based on height (cm) and weight (kg) input
- Color-coded category indicators
- Visual category guide with BMI ranges for reference
- Reset functionality to clear all inputs and results
- Requires valid numeric input for both height and weight
- Shows error message via SnackBar if inputs are invalid or empty
- Prevents calculation with zero or negative values

### 2. Expense Splitter  
Allows the user to input total amount, number of persons (pax), and tip percentage to calculate per-person share.

Features:
- Adjustable tip/service charge slider (0% to 30%)
- Displays detailed bill breakdown
- Shows number of people and total amount with tip
- Clear button to reset all inputs and results
- Prompts notif on empty or invalid input
- If bill is less than ₱1.00, the app suggests the user may have meant a higher amount (e.g., ₱100 instead of ₱1)
- Requires at least 1 person to split the bill
- If the total bill exceeds ₱1,000,000, the system flags it as unusually high to prevent accidental input mistakes

### 3. Grade Calculator  
Allows the user to input component grades and their corresponding weights to compute the final weighted grade.

Features:
- Add unlimited subjects with name, grade, and units
- Automatic GWA computation as subjects are added or removed
- Displays total units and subject count
- Shows target GWA (Dean's List standard: 1.75)
- Delete individual subjects or clear all at once
- Confirmation dialogs before deleting subjects
- Accepts grades between 1.0 and 5.0
- Requires unit values greater than zero
- All fields must be filled before adding
- Shows error if subject name is left blank

These modules were chosen because they represent real-life daily tools related to health, finance, and academics. They demonstrate computation logic, validation handling, and encapsulated state management.

## Personalization Features

- User can enter display name  
- User can choose from 3 preset theme colors  
- App greets the user: **“Hi, [Name]”**  
- Selected theme color is applied across the application  

---

## Validation Handling

The app properly handles:

- Empty input fields  
- Non-numeric input  
- Division by zero cases (e.g., pax = 0)  
- Invalid computations  

SnackBars are used to notify users of input errors.

---

## How to Run

1. Install Flutter SDK  
2. Open the project folder  
3. Run the following commands:

flutter pub get  
flutter run  

4. Select emulator or connected device  

---

## Conclusion

The Daily Helper Toolkit converts simple program logic into a structured Flutter mobile application.

Through this project, we applied key concepts such as:
- Abstraction
- Inheritance
- Encapsulation
- Polymorphism
- Widget literacy
- Input validation
- UI personalization

This activity helped us better understand modular Flutter development, proper OOP structure, and clean UI implementation.
