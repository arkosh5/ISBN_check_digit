This is a simple web application for calculating the check digit of an ISBN-13 barcode or validating an existing one. The application is built with Vue.js and uses the Quagga.js library for scanning barcodes. The backend is written in Ruby using the Sinatra framework.

Usage
To use the application, simply enter the 12-digit ISBN number in the input field, and then click the "Calculate" button to generate the check digit. Alternatively, click the "Scan Barcode" button to use your device's camera to scan the barcode and automatically populate the ISBN input field. If the ISBN is valid, the complete 13-digit number will be displayed along with a "Copy" button to copy the number to the clipboard.

Installation
To install the application, clone the repository to your local machine. Then, navigate to the root directory of the project and install the necessary dependencies with the following command:



```npm install```
Next, start the application with the following command:

```npm run serve```
The application will be available at http://localhost:8080.

Backend
The backend of the application is written in Ruby and uses the Sinatra framework to provide an API endpoint for calculating the check digit. The code is contained in the app.rb file in the root directory of the project. The API endpoint can be accessed at the following URL:

```http://localhost:4567/calculate_isbn13_check_digit/:isbn```
where :isbn is the 12-digit ISBN number.
