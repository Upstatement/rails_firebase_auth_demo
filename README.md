# Rails Firebase Auth Demo

A reference implementation using client-side Firebase Authentication with server-side token verification.

Technologies used:
- Ruby on Rails
- Postgres
- Firebase Authentication JS SDK
- Firebase Admin REST API

## How it works

[Firebase Authentication](https://firebase.google.com/docs/auth) is an end-to-end identity solution included (for free) with Google's [Firebase Build product](https://firebase.google.com/products-build). It provides a storage solution for user accounts, a variety of authentication providers (Email/Password, Google, Facebook, Phone, etc.), a suite of APIs and client SDKs, and a drop-in UI library. It allows you to quickly spin up account-based features without any server code required.

While you don't _need_ any server code for authentication, odds are if you need authentication you've got some sort of backend, with identity linked to other application entities. Odds are also good that you've got a front-end application that needs to interact with that backend. There's a lot of good resources for client-side Firebase Auth usage, but suprisingly few good resources on how it might interact with a backend.

This repo demonstrates the use of Firebase Auth for user storage, authentication, and session management in tandem with a Ruby on Rails-powered API.

- Client-side authentication logic is [inlined in the root page](), with Firebase Auth loaded via CDN. This logic includes:
  - Sign in button that redirects to Google for authentication
  - Firebase Auth response in a JSON pre block
  - Test button to demonstrate an authenticated API call to the Rails backend
  - Sign out button to clear session state
- Server-side logic involves a users API and database model. This includes:
  - An authentication call that pulls the Firebase ID token out of the Authorization header and retrieves user info from Firebase
  - A user model that is created automatically on first authentication
  - A `/api/me` endpoint that returns the user info for a user when authenticated 
## Set Up

1. Install RoR dependencies with Bundler

    ```
    bundle install
    ```

2. Install Postgres

    ```
    brew install postgresql
    ```

3. Create a Firebase project (if you haven't already) and populate a `.env` file with app credentials, using `.env.example` as a template
4. Set up the development database

    ```
    bin/rails db:setup
    ```

5. Serve the app

    ```
    bin/rails serve
    ```

You should now be able to visit the site at http://localhost:3000.
