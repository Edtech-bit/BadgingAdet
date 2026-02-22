# MIDTERM BADGE EXAM  
## UI Artisan – Widget Literacy Badge  
### Group 7  

---

## Group Members & Roles

**Adrian Anunciacion**  
UI implementation, layout structure, testing, and documentation preparation.

**Aaron Lozano**  
Main developer of application logic and OOP structure.

**EJ Pineda**  
Assisted in coding, debugging, and validation handling.

**Ed Castillo**  
Recorded and edited the demo video of the application.

**Khristian Pradilla**  
Contributed to UI design planning (Figma), captured screenshots, and organized documentation files.

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

### 2. Expense Splitter  
Allows the user to input total amount, number of persons (pax), and tip percentage to calculate per-person share.

### 3. Grade Calculator  
Allows the user to input component grades and their corresponding weights to compute the final weighted grade.

These modules were chosen because they represent real-life daily tools related to health, finance, and academics. They demonstrate computation logic, validation handling, and encapsulated state management.

---

## OOP Implementation

### Abstraction  
An abstract class `ToolModule` was created with:

- `String get title`  
- `IconData get icon`  
- `Widget buildBody(BuildContext context)`  

All modules follow this structure.

### Inheritance  
Three concrete classes extend `ToolModule`:

- `BmiModule`  
- `ExpenseSplitterModule`  
- `GradeCalculatorModule`  

### Encapsulation  
Each module contains private state variables such as:

- `_height`, `_weight`  
- `_total`, `_pax`, `_tipPercent`  
- `_grades`, `_weights`  

State is updated only through controlled methods like:

- `compute()`  
- `reset()`  

No result variables are directly modified from outside the module.

### Polymorphism  
A `List<ToolModule>` is used to dynamically generate navigation items and display module UI using the selected index.

---

## Widget Literacy Checklist

The application includes:

- Scaffold  
- AppBar  
- BottomNavigationBar  
- Text & Icon  
- Container / Card  
- TextField with TextEditingController  
- ElevatedButton  
- ListView  
- SnackBar for validation feedback  
- Slider (for tip percentage)  
- Padding and SizedBox for spacing  

Widgets are used logically across different modules and not crowded in a single screen.

---

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

## Documentation Folder

The `/docs` folder contains:

- 8–12 screenshots (home + each module + validation examples)  
- Reflection file  
- Demo: video link of the application  

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
