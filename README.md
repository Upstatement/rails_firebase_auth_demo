# Rails Firebase Auth Demo

A reference implementation using client-side Firebase Authentication with server-side token verification.

Technologies used:
- [Ruby on Rails](https://rubyonrails.org/)
- [Postgres](https://www.postgresql.org/)
- [Firebase JavaScript SDK](https://firebase.google.com/docs/reference/js)
- [Firebase Admin REST API](https://firebase.google.com/docs/reference/rest/auth)

## How it works

[Firebase Authentication](https://firebase.google.com/docs/auth) is an end-to-end identity solution included (for free) with Google's [Firebase Build product](https://firebase.google.com/products-build). It provides a storage solution for user accounts, a variety of authentication providers (Email/Password, Google, Facebook, Phone, etc.), a suite of APIs and client SDKs, and a drop-in UI library. It allows you to quickly spin up account-based features without any server code required.

While you don't _need_ any server code for authentication, odds are if you need authentication you've got some sort of backend, with identity linked to other application entities. Odds are also good that you've got a front-end application that needs to interact with that backend. There're many good resources for client-side Firebase Auth usage, but suprisingly few on how it might interact with a backend.

This repo demonstrates the use of Firebase Auth for user storage, authentication, and session management in tandem with a Ruby on Rails-powered API.

- Client-side authentication logic is [inlined in the welcome view](https://github.com/Upstatement/rails_firebase_auth_demo/blob/main/app/views/welcome/index.html.erb#L30-L112), with Firebase Auth [loaded via CDN](https://github.com/Upstatement/rails_firebase_auth_demo/blob/main/app/views/welcome/index.html.erb#L28-L29). This logic includes:
  - Sign in button that redirects to Google for authentication
  - Rendering of JSON response from Firebase Auth after successful sign in
  - Test button to demonstrate an authenticated API call to the Rails backend
  - Sign out button to clear auth state
- Server-side logic includes a users API and database model. This involves:
  - A [custom user model](https://github.com/Upstatement/rails_firebase_auth_demo/blob/main/db/migrate/20210616011819_create_users.rb) (https://github.com/Upstatement/rails_firebase_auth_demo/blob/main/app/controllers/api/users_controller.rb#L25-L29)
  - An [`authenticate method`](https://github.com/Upstatement/rails_firebase_auth_demo/blob/main/app/controllers/api/users_controller.rb#L21-L33) that pulls the Firebase ID token out of the Authorization header and used to lookup user info. New users are created on first authenticated request, [populated with user info returned by Firebase Auth]
  - A [`/api/me`](https://github.com/Upstatement/rails_firebase_auth_demo/blob/main/app/controllers/api/users_controller.rb#L11-L17) endpoint that returns the user info for a user when authenticated (and a `400` error for anonymous requests)

This code is modeled after code we have used in production, but simplified for the sake of demonstration.

## Setup

1. Install Ruby dependencies with [Bundler](https://bundler.io/)

    ```
    bundle install
    ```

2. Install [Postgres](https://www.postgresql.org/download/). If you're on a Mac, [Homebrew](https://brew.sh/) makes this easy:

    ```
    brew install postgresql
    ```

3. Follow the steps in the [Firebase guide](https://firebase.google.com/docs/web/setup) to register an account, create a project, and configure an app to use the Firebase Auth service.
4. Populate a `.env` file with your Firebase credentials, using `.env.example` as a template
6. Set up the development database

    ```
    bin/rails db:setup
    ```

5. Start the app server

    ```
    bin/rails serve
    ```

You should now be able to visit the site at http://localhost:3000.
