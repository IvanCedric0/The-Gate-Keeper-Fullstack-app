# The Gate Keeper Management System

A full-stack application for managing student information using Vue.js, Node.js, Express, MySQL, Flutter and Dart.

## Prerequisites

- Node.js (v14 or higher)
- MySQL Server
- npm or yarn
- Flutter SDK (latest stable version)
- Android Studio or VS Code with Flutter extensions

## Setup Instructions

### Backend Setup

1. Navigate to the backend directory:
   ```bash
   cd backend
   ```

2. Install dependencies:
   ```bash
   npm install
   ```

3. Create the MySQL database and table:
   - Open MySQL command line or MySQL Workbench
   - Run the SQL commands from `schema.sql`

4. Create an `uploads` directory in the backend folder:
   ```bash
   mkdir uploads
   ```

5. Start the backend server:
   ```bash
   npm run dev
   ```

### Frontend Setup (Web Admin Panel)

1. Navigate to the frontend directory:
   ```bash
   cd frontend
   ```

2. Install dependencies:
   ```bash
   npm install
   ```

3. Start the development server:
   ```bash
   npm run serve
   ```

### Flutter App Setup (Mobile Scanner)

1. Navigate to the gatekeeper directory:
   ```bash
   cd gatekeeper
   ```

2. Get Flutter dependencies:
   ```bash
   flutter pub get
   ```

3. Run the app:
   ```bash
   flutter run
   ```

## Web Admin Panel Usage

For login, username: admin ; password: gate808

1. Open your browser and navigate to `http://localhost:8080`
2. Use the form to add new students with their information and photo
3. View the list of all students below the form

## Flutter App Usage

1. Launch the app on your Android/iOS device
2. Insert students IDs manually in the text field
3. Use the QR scanner to scan student IDs
4. View student information instantly after scanning

## Features

### Web Admin Panel
- Add new students with ID, full name, major, and photo
- View all students in a grid layout
- Responsive design
- Image upload support
- Real-time updates when adding new students

### Flutter Mobile App
- Secure admin authentication
- QR code scanning functionality
- Real-time student information retrieval
- Mobile-optimized interface
- Works on both Android and iOS devices

## Technologies Used

- Web Frontend: Vue.js 3
- Mobile App: Flutter & Dart
- Backend: Node.js with Express
- Database: MySQL
- File Upload: Multer
- Authentication: JWT
- QR Scanning: mobile_scanner package 