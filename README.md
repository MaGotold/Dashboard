

## Prerequisites


- **Elixir**
- **Phoenix Framework**: 

  ```bash
  mix archive.install hex phx_new
  ```

- **PostgreSQL**

## Setup Instructions

1. **Clone the Repository**

   Clone the repository to your local machine:

   ```bash
   git clone https://github.com/MaGotold/Dashboard.git
   cd your-repo
   ```

2. **Install Dependencies**

   Fetch and install the project dependencies:

   ```bash
   mix deps.get
   ```

3. **Setup the Database**

  Open the `config/dev.exs` file and update the database configuration to match your setup

   Create the database:

   ```bash
   mix ecto.create
   ```

   Run the migrations:

   ```bash
   mix ecto.migrate
   ```

4. **Seed the Database**

   Run the seed file to populate the database with initial data:

   ```bash
   mix run priv/repo/seeds.exs
   ```

## Testing the Application

As part of the setup, I added PubSub and a login screen to the application. For testing purposes, two users have been created automatically:

- **Test User 1**:  
  - Email: `testuser@example.com`  
  - Password: `password1234!`

- **Test User 2**:  
  - Email: `seconduser@example.com`  
  - Password: `password1234!`

You can use these credentials to log in and test the application.

## Running the Application

Start the Phoenix server by running:

```bash
mix phx.server
```

- Task 1 is available at [http://localhost:4000/products](http://localhost:4000/products).
- Task 2 is available at [http://localhost:4000/dashboard](http://localhost:4000/dashboard).
