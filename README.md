# Rails Firebase Auth Demo

A reference implementation using client-side Firebase Authentication with server-side token verification.

Technologies used:
- Ruby on Rails
- Postgres
- Firebase Authentication JS SDK
- Firebase Admin REST API
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
