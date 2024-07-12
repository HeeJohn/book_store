<div align="center">

# University Book Exchange Platform

<h3>An application for students to easily trade textbooks</h3>
  
</div>

---

## 🙌 Project Overview

### Vision and Goals
- Provide a platform for university students to quickly search for and trade used textbooks based on their semester schedules.
- Reduce financial burdens by facilitating the exchange of second-hand textbooks.

### Technical Goals
- Develop a user-friendly UI using Flutter.
- Build the backend using Node.js and MySQL.
- draw ERD from the skatch & design relational tables based on ERD

## 🤞 First time - Challenges

### Frontend
- Develop cross-platform UI using Flutter.
- Design intuitive user experience (UX).

### Backend
- Build the server using Node.js.
- Design and integrate MySQL database.
- write efficient queries to handle data
  
### 📚 Tech Stack

| Frontend | Backend |
| --- | --- |
| ![Flutter](https://img.shields.io/badge/Flutter-02569B?style=flat&logo=flutter&logoColor=white) ![Dart](https://img.shields.io/badge/Dart-0175C2?style=flat&logo=dart&logoColor=white) | ![Node.js](https://img.shields.io/badge/Node.js-339933?style=flat&logo=node.js&logoColor=white) ![JavaScript](https://img.shields.io/badge/JavaScript-F7DF1E?style=flat&logo=javascript&logoColor=white) ![MySQL](https://img.shields.io/badge/MySQL-4479A1?style=flat&logo=mysql&logoColor=white) |


---

## 👥 Team Members
| HyoYoung Baek | HeeJun Seo |
| :---: | :---: |
| <img src="https://github.com/HyoYoung0829.png" width="100"/> | <img src="https://github.com/HeeJohn.png" width="100"/> |
| [@HyoYoung0829](https://github.com/HyoYoung0829) | [@HeeJohn](https://github.com/HeeJohn) |

### Team Roles

| Name           | Role                                                                 |
|----------------|----------------------------------------------------------------------|
| HyoYoung Baek  | Design, UI Implementation, Backend Implementation, Client Request Handling, DB Design, Testing |
| Huijun Seo     | UI Implementation, Backend Design and Implementation, DB Design, SQL Processing, Testing, Optimization |

---

## 📆Project Development Schedule

| Task                        | Oct (3rd Week) | Oct (4th Week) | Nov (1st Week) | Nov (2nd Week) | Nov (3rd Week) | Nov (4th Week) | Dec (1st Week) | Dec (2nd Week) |
|-----------------------------|----------------|----------------|----------------|----------------|----------------|----------------|----------------|----------------|
| Planning and Page Layout    | ✔️              | ✔️              |                |                |                |                |                |                |
| UI Creation and Functionality|                | ✔️              | ✔️              | ✔️              |                |                |                |                |
| DB Design and Creation      |                |                |                | ✔️              | ✔️              |                |                |                |
| Query Writing & server development     |                |                |                |                | ✔️              | ✔️              | ✔️              |                |
| Testing and Maintenance     |                |                |                |                |                | ✔️              | ✔️              | ✔️              |

### ⏳ Detailed Development Plan

| Date           | Phase                    | Task Details                                                                                              |
|----------------|--------------------------|-----------------------------------------------------------------------------------------------------------|
| 10.20~         | Planning and Page Layout | - Write Capstone Design plan, configure services<br>- Design UI, abstract DB<br>- Write MVP, plan schedule |
| 10.23 ~ 11.13  | UI Creation and Functionality | - Create MVP UI, admin interface<br>- Implement service functions                                          |
| 11.06 ~ 11.30  | DB Design and Creation   | - Design ERD and external schema<br>- Separate tables and relational tables<br>- Implement tables using DBMS |
| 10.23 ~ 11.30  | Query Writing & server development      | - Assign roles and permissions to admin<br>- Develop backend<br>- Write queries according to client requests |
| 12.01 ~ 12.06  | Testing and Maintenance      | - Test service and receive feedback<br>- Handle errors and exceptions, modularize code, optimize<br>- Write final report |

---

## 📌 Requirement Analysis
- Reduce financial burden through second-hand textbook transactions.
- Provide a convenient system for quick and efficient textbook transactions at the start of each semester.
- Offer an intuitive user interface and experience.

### Functional Requirements
- User registration and login
- Textbook search and transaction based on schedule
- Manage transaction appointments and locations
<br><br>
---

## 🖼️DB design

### 1. ☝️ Requirements Analysis

* **User Registration and Login**
  The platform provides a service for users to register their schedules or facilitate book transactions between students. Hence, it needs to store and manage user information. The User table requires 'student_id, name, phone number, password,' with student_id being unique for each student to distinguish users. Also, session ID is assigned to manage logged-in users and prevent double login.

  (Registration): student_id, name, phone number, password
  (Login): student_id, session ID

* **Timetable Registration and Viewing**
  Logged-in users register the courses they are taking into their timetable. This allows students to quickly find and purchase necessary books. The relationship between User and Class tables is established to create personal timetables.

  (Course Information): class_id, class_name, professor, credit
  (Timetable): student_id, class_id

* **Book Sale Registration**
  Users are categorized into buyers and sellers. The book sale registration service allows sellers to register used books for sale. Each book has unique conditions, and details like highlights, pencil marks, pen marks, dirt level, fading, and tear degree are stored to provide comprehensive information to buyers.

  (Book Basic Information): book_id, book name, author, price, publisher, published year, upload time, student_id, class_id
  (Book Condition Information): highlights, pencil marks, pen marks, dirt level, fading, tear degree, book_id

* **Book Search for Purchase**
  Buyers can search for books in two ways: through a general search by entering the course name or a timetable-based search using the registered timetable.

  (General Search): class_id, class_name, book_id
  (Timetable-based Search): timetable information (user info, class info), book_id
  (Search Result Sorting): upload time, price, condition, book_id 

* **Meeting**
  Buyers select desired books and send purchase requests to sellers. Upon acceptance, contact information is exchanged, and meeting details are stored, including time, place, and location coordinates.

  (Purchase Request): buyer student_id, book_id, seller student_id
  (Meeting): (buyer, seller) name, (buyer, seller) phone number, book_id, meeting time, meeting place
  (Map): latitude, longitude


### 2. 🏗️ Conceptual Database Design (ERD)


&lt;ENTITY&gt;
- **User** (student_id(학번), name(이름), phone(전화번호), password(비밀번호))
- **Session** (student_id(학번), session_id(세션ID))
- **Class** (class_id(과목 코드), class_name(강좌 명), professor(교수명), credit(학점))
- **Book** (book_id(책ID), book_name(책 이름), author(저자), price(가격), publisher(출판사), published_year(출판연도), upload_time(등록 시간), student_id(학번), class_id(과목 코드))
- **Status** (book_id(책ID), light(하이라이트), pencil(연필), pen(볼펜), dirty(오염도), fade(책 바램), ripped(찢김))

&lt;RELATIONSHIP&gt;
- **login** (로그인) = User(student_id(학번)) + Session(session_id(세션ID))
- **Class_table** (시간표) = User(student_id(학번)) + Class(class_id(과목 코드))
- **Class has Book** (강좌와 교재의 관계) = Book(book_id(책ID)) + Class(class_id(과목 코드))
- **Book has Status** (책과 책 상태의 관계) = Book(book_id(책ID)) + Status(book_id(책ID))
- **register** (판매 목적의 책 등록) = User(student_id(학번)) + Book(book_id(책ID))
- **Meeting** (약속 성사) = User(student_id(구매자/판매자 학번)) + Book(book_id(책ID)) + meeting_time(약속 시간), place(약속 장소), approval(승인 여부), latitude(위도), longitude(경도)

&lt;CONSTRAINT&gt;
- **User table - Session table**:
  When login is successful, a session_id is assigned to the user. Therefore, session_id must exist only if the user exists. If student_id is deleted from the User table, the corresponding session_id should also be deleted. Hence, a CASCADE constraint is set.

- **Book table - Status table**:
  Each book listed for sale has a unique condition. The condition exists because the book exists. To ensure data integrity, if a book is deleted from the Book table, the corresponding status should also be deleted. Hence, a CASCADE constraint is set.

- **User table - Class_table table**:
  The personal timetable (Class_table) created by a student also needs constraints. If a student drops out or takes a leave of absence, the timetable data becomes unnecessary. Therefore, if a student's information is deleted from the User table, the corresponding timetable should also be deleted. Hence, a CASCADE constraint is set.

- **Class table - Book table**:
  The platform matches textbooks to specific courses. If a course is deleted from the Class table, the textbooks referring to that course should also be deleted. To ensure data integrity, a CASCADE constraint is set.

<br><br>

### 데이터베이스 ERD
<div align="center">
  <img src="https://github.com/user-attachments/assets/6b810e40-25e9-415a-9b24-abcfb8aa73f0" alt="erd" height="300"/>
</div>
<br><br>

---

## 👣 Features overview
![image](https://github.com/user-attachments/assets/d284282a-d4f5-4c68-86a1-ee7639665c2d)

## ☝️ Main Features

### 🔔 Notification box
- Notify users during transaction requests and acceptances

### 📖 Book Management
- Register and manage second-hand textbooks
- Input and edit textbook condition details

### 🤝 Transaction System
- Search for and request desired textbooks
- Manage transaction status and set appointment times/locations

### 👥 User Management
- User registration and login
- Edit and delete user information
<br><br>
---

![image](https://github.com/user-attachments/assets/2a9587fe-2eb5-4f6a-b579-f7cb380121fd)

![image](https://github.com/user-attachments/assets/f23e7489-97c5-42ee-b8ac-30f33f5d23e5)

![image](https://github.com/user-attachments/assets/b231a986-b937-4b0a-8f7b-7658be46d465)

![image](https://github.com/user-attachments/assets/be4ec001-adad-4021-9321-9167c3555370)

![image](https://github.com/user-attachments/assets/aa37522f-e06b-4081-a731-f661007281b1)



