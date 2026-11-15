Online Quiz System · Quiz Studio
A complete educational web project built with C# / .NET 10 / ASP.NET Core / Blazor Interactive Server / Entity Framework Core / SQLite / ASP.NET Core Identity.

The user interface and these instructions are in English. The project runs locally; no separate database server, API keys, or paid services are required. On the first launch, the application restores NuGet packages, creates the database tables, and seeds demo data. Once dependencies have been restored, the application does not rely on external CDNs, fonts, or cloud APIs.
Quick Start on Windows
1. Install the .NET 10 SDK: https://dotnet.microsoft.com/en-us/download/dotnet/10.0. You need the SDK, not just the Runtime.
2. Extract the entire ZIP archive, for example to C:\Projects\OnlineQuizSystem. Do not run files directly from inside the ZIP.
3. Run START_WINDOWS.cmd.
4. When you see Now listening on, open http://localhost:5080.
5. Sign in using one of the Student, Teacher, or Admin accounts listed below.
6. Keep the terminal window open. To stop the application, press Ctrl+C.
Alternatively, open a terminal in the folder containing OnlineQuizSystem.sln and run:
dotnet restore OnlineQuizSystem.sln
dotnet run --project src/OnlineQuizSystem --launch-profile OnlineQuizSystem
An internet connection is required on the first launch to restore NuGet packages. The .NET SDK itself is not included in the ZIP archive.
Running in Visual Studio
1. Use Visual Studio 2026 with .NET 10 support and the ASP.NET and web development workload. Visual Studio 2022 does not support this target framework; you can instead run the project from VS Code or a terminal with the .NET 10 SDK installed.
2. Open OnlineQuizSystem.sln.
3. Set the OnlineQuizSystem project under src as the Startup Project.
4. Wait for NuGet packages to be restored.
5. Select the OnlineQuizSystem launch profile and press Ctrl+F5.
6. If the browser does not open automatically, go to http://localhost:5080.
macOS / Linux / VS Code
Install the .NET 10 SDK, then run these commands from the project root:
dotnet restore OnlineQuizSystem.sln
dotnet run --project src/OnlineQuizSystem --launch-profile OnlineQuizSystem
# Alternatively: bash start.sh
Open http://localhost:5080. The project requires .NET SDK version 10.0.100 or later within the 10.0 release series; global.json allows later feature bands within that series. The C# extension for VS Code is optional for running the application.
Demo Accounts
Role	Email	Password	What to Test
Student	student@quiz.local	Student123!	Quizzes, attempt history, leaderboard, topic analysis
Teacher	teacher@quiz.local	Teacher123!	Own quizzes, questions, results, CSV export
Admin	admin@quiz.local	Admin123!	All quizzes and overall statistics


Additional student accounts for the leaderboard: dana@quiz.local and amina@quiz.local, both with the password Student123!.

Public registration always creates a Student account. Users cannot assign themselves the Teacher or Admin role during registration. The demo data includes three published quizzes with 10 questions each: Computer Networks, Database Essentials, and C# & .NET Fundamentals. It also includes nine completed demo attempts. All demo accounts and results are created only when the application runs in Development and Demo:Enabled=true. Existing quizzes are not overwritten on subsequent launches.
Implemented Features
- User registration with validation, sign-in, and sign-out using ASP.NET Core Identity; password hashing, cookies, roles, lockout after five failed sign-in attempts, and rate limiting for sign-in and registration requests.
- Student dashboard and quiz catalog with search, subject filters, and pagination.
- Quiz creation, editing, publishing, and archiving; four answer options per question, single or multiple correct answers, question topics, and explanations.
- Role-based permissions: students cannot manage quizzes; teachers can manage their own quizzes and results; admins can manage all quizzes and results.
- Server-side timer, automatic saving of each answer selection to SQLite, question navigation, and resuming an attempt after a page reload.
- Automatic submission when the deadline expires, even if the browser tab is closed: a background task checks overdue attempts every 15 seconds. An attempt is also checked immediately when opened. If the server is offline, the attempt is finalized after the server restarts, while its recorded completion time remains the original deadline.
- Automatic grading, review of correct and incorrect answers, and explanations after submission. Answer keys are not included in the DTO for an active attempt before submission.
- Account-specific attempt history, retakes, a leaderboard based on each student's best score for each unique quiz, weak-topic analysis, and a chart of the last eight results.
- Administrative statistics and CSV export. CSV content is escaped, including protection against spreadsheet-formula injection in names and titles.
- Randomized question order, light and dark themes with saved preferences, and responsive styling.
- Question snapshots for each attempt: editing a quiz does not change attempts that have already started or finished. Archiving preserves history.
- Server-side ownership checks and protection against duplicate submissions and edit conflicts across multiple browser tabs.
How to Use the Application
Student: Sign in → Explore quizzes → Select a quiz card → Start or resume quiz → Select answers → Next/Previous → Submit quiz → Submit answers → Review the results. Closing the page does not pause the timer. Attempt history is available under My attempts, and rankings are available under Leaderboard.

Teacher: Sign in as Teacher → Manage quizzes → Create quiz → Enter the title, subject, description, time limit, and passing percentage → Add questions with four distinct answer options → Mark the correct option(s) → Enable Multiple correct answers, if needed → Select Publish in the student catalog → Save quiz. After students complete quizzes, open Class insights and use Export CSV.

For multiple-answer questions, one point is awarded only when the student selects all and only the correct options. No partial credit is given. All questions have equal weight. An unanswered question earns zero points. The percentage score is displayed to two decimal places. The pass threshold is evaluated using the exact ratio of correct answers to the total number of questions before rounding.
Data Storage
The application database is stored at src/OnlineQuizSystem/App_Data/quiz.db. Enabled Entity Framework Core migrations create the database on first launch. The database file is not included in the archive; accounts and demo results are generated when the application starts.

To back up the database, stop the server and copy the entire App_Data folder. To completely reset the educational data, stop the application, delete App_Data, and start it again. This deletes all created accounts, quizzes, and results. Do not delete the folder for a normal restart.
Project Structure
OnlineQuizSystem.sln
src/OnlineQuizSystem/
  Components/Pages/       Student, teacher, and account pages
  Components/Shared/      QuizCard, QuestionCard, StatCard, HistoryTable, chart
  Components/Layout/      Navigation and shared application layout
  Models/                 Entities, DTOs, and editing models
  Data/                   DbContext and demo seed data
  Migrations/             Initial EF Core schema and model snapshot
  Services/               Quizzes, attempts, scoring, statistics, authorization
  wwwroot/                Local CSS, JavaScript, and favicon
  Program.cs              Dependency injection, HTTP authentication,
                          middleware, and endpoints
  tests/OnlineQuizSystem.Tests/  xUnit, integration, and UI tests
  tests/e2e/                    Playwright real-browser scenario
  docs/                         Architecture, test plan, and defense guide
Testing
Run all .NET tests with:
dotnet test OnlineQuizSystem.sln
Automated tests use temporary SQLite databases and do not modify your working database. Test results and documented limitations are in docs/TEST_REPORT.md; manual testing scenarios are in docs/TEST_PLAN.md.

The optional browser test requires Node.js and a running application with demo mode enabled:
npm install
npx playwright install chromium
npm test
The browser test uses demo accounts, creates and archives a quiz named Browser QA Quiz, registers an additional test student, and creates a quiz attempt. Run it against an educational or test database. Set QUIZ_BASE_URL to test a different address. The scenario checks desktop and mobile viewports, but it does not replace testing on a physical smartphone.
Database Migrations for Further Development
The initial launch does not require manual migration commands. After changing the data models, run:
dotnet tool restore
dotnet tool run dotnet-ef migrations add YourChange --project src/OnlineQuizSystem
dotnet tool run dotnet-ef database update --project src/OnlineQuizSystem
Do not combine EnsureCreated with migrations for the working database. EnsureCreated is used only in isolated service tests.
Limitations of the Educational Version
The application is designed for a single server process with SQLite. Writes are serialized through a shared MutationGate, making interactions across multiple tabs and background deadline processing predictable. Supporting multiple server instances would require a server-based database, transactional constraints or distributed coordination, and load testing. The project does not claim to have been tested with large classes or heavy workloads.

The application uses Blazor Interactive Server, so interactive features require a running server and an active SignalR connection. An answer successfully submitted before a connection interruption is saved. If saving was not confirmed, reconnect and verify the selected answer. Offline quiz-taking is not implemented.

Email-based password reset, email confirmation, role management through the UI, access codes, AI-generated questions, adaptive difficulty, and a dedicated real-time leaderboard hub are not implemented. The leaderboard refreshes when its page is opened. The chart is a custom Blazor/CSS component; Chart.js is not required.

Before deploying to a public server, disable demo mode, enable HTTPS, and use a unique administrator password. The initial administrator is configured through Bootstrap:AdminEmail and Bootstrap:AdminPassword (for example, with .NET User Secrets during local development or a secrets manager in hosting). Production mode does not create demo passwords, regardless of Demo:Enabled. However, existing accounts in a transferred database are not automatically deleted. Do not move a database containing demo accounts to a public environment.
Preparation Before Submission
- Add your real full name, group, and GitHub repository URL to the defense materials.
- Study the services and database relationships; the instructor may ask about any part of the code.
- Practice the presentation scenario in docs/DEFENSE.md and complete the manual checklist in docs/TEST_PLAN.md.
- Prepare a presentation based on the structure in docs/DEFENSE.md. The ZIP includes a text-based defense script, but no separate PPTX presentation was created.
- Commit the source code to GitHub and submit it to the LMS using your own accounts. The archive is ready for upload after you verify the instructor's submission requirements.
Primary References
- .NET SDK: https://dotnet.microsoft.com/en-us/download/dotnet/10.0
- Blazor: https://learn.microsoft.com/en-us/aspnet/core/blazor/?view=aspnetcore-10.0
- EF Core in Blazor and DbContextFactory: https://learn.microsoft.com/en-us/aspnet/core/blazor/blazor-ef-core?view=aspnetcore-10.0
- Identity: https://learn.microsoft.com/en-us/aspnet/core/security/authentication/identity?view=aspnetcore-10.0
- bUnit: https://bunit.dev/docs/getting-started/writing-tests.html
- Playwright: https://playwright.dev/docs/library
