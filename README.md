# TicTacToeApi

## webserver that allows a user to play tic tac toe by posting moves to the server as JSON.

## Get Started
`git clone repo`
`cd tictactoeapi`
`rake db:migrate`
`rails s`

## What I added
1. User authentication
2. End of game information report (Who won, game was a tie)
3. End of game lockout (game cannot be updated once game has ended
4. Force correct turn (one player cannot go twice in a row)

## How to check end of game info
'''
curl -X POST -H 'content-type: application/json' -d '{"username":<username>,"password":<password>}' http://localhost:3000/games/<game>/status
'''


## User Curl Commands

### Creating a User

```
curl --request POST --header "Content-Type: application/json" -d '{
  "user": {
    "username": "johndoe",
    "password": "foobarbaz"
  }
}' http://localhost:3000/users
```

```
{"user":{"id":1,"username":"johndoe","created_at":"2015-10-16T15:17:27.657Z","updated_at":"2015-10-16T15:17:27.657Z"}}
```

### Show a User

```
curl --request GET --header "Content-Type: application/json" -d '{}' http://localhost:3000/users/1
```

example response
```
{"user":{"id":1,"username":"johndoe","created_at":"2015-10-16T15:17:27.657Z","updated_at":"2015-10-16T15:17:27.657Z"}}
```


### Updating a User

```
curl --request PATCH --header "Content-Type: application/json" -d '{
  "username": "johndoe",
  "password": "foobarbaz",
  "user": {
    "username": "henry"
  }
}' http://localhost:3000/users/1
```

example response
```
{"user":{"id":1,"username":"henry","created_at":"2015-10-16T15:17:27.657Z","updated_at":"2015-10-16T15:18:08.224Z"}
```

### Destroying a User

```
curl --request DELETE --header "Content-Type: application/json" -d '{
  "username": "henry",
  "password": "foobarbaz"
}' http://localhost:3000/users/1
```

### Creating a Game

```
curl --request POST --header "Content-Type: application/json" -d '{
  "game": {
    "player_1_id": "1"
  }
}' http://localhost:3000/games
```

example response
```
{"game":{"id":20,"status":"Game in Progress","board":[["","",""],["","",""],["","",""]],"player_1_id":1,"player_2_id":null}}
```

### Show a Game

```
curl --request GET --header "Content-Type: application/json" -d '{}' http://localhost:3000/games/1
```

example response
```
{"game":{"id":1,"status":"Game in Progress","board":[["","",""],["","",""],["","",""]],"created_at":"2015-10-16T15:44:08.583Z","updated_at":"2015-10-16T15:44:08.583Z","player_1_id":1,"player_2_id":null}}
```

### Show a Game's Status

```
curl --request POST --header "Content-Type: application/json" -d '{
  "username": "johndoe",
  "password": "foobarbaz"
}' http://localhost:3000/games/1/status
```

example response
```
{"status":"Game in Progress"}
```

### Updating/Joining a game

```
curl --request PATCH --header "Content-Type: application/json" -d '{
  "username": "johndoe",
  "password": "foobarbaz"
  "game": {
    "player_2_id": "2"
  }
}' http://localhost:3000/games/1
```

example response
```
{"game":{"id":1,"status":"Game in Progress","board":[["","",""],["","",""],["","",""]],"created_at":"2015-10-16T15:44:08.583Z","updated_at":"2015-10-16T16:02:34.835Z","player_1_id":1,"player_2_id":2}}
```

### Destroy a Game

```
curl --request DELETE --header "Content-Type: application/json" -d '{
  "username": "johndoe",
  "password": "foobarbaz"
}' http://localhost:3000/games/1
```


### make a move

Choose a location where you want to post your move

<table>
  <tr>
    <td>1</td>
    <td>2</td>
    <td>3</td>
  </tr>
  <tr>
    <td>4</td>
    <td>5</td>
    <td>6</td>
  </tr>
  <tr>
    <td>7</td>
    <td>8</td>
    <td>9</td>
  </tr>
</table>

```
curl --request POST --header "Content-Type: application/json" -d '{
  "username": "johndoe",
  "password": "foobarbaz",
  "location": "1"
}' http://localhost:3000/games/2/make_move
```

<table>
  <tr>
    <td>X</td>
    <td>2</td>
    <td>3</td>
  </tr>
  <tr>
    <td>4</td>
    <td>5</td>
    <td>6</td>
  </tr>
  <tr>
    <td>7</td>
    <td>8</td>
    <td>9</td>
  </tr>
</table>

example response

```
{"game":{"id":1,"status":"Game in Progress","board":[["x","",""],["","",""],["","",""]],"created_at":"2015-10-16T16:06:40.925Z","updated_at":"2015-10-16T16:15:15.049Z","player_1_id":1,"player_2_id":null}}
```

## Todo List
 - User authentication (DONE)
 - Make it two player (DONE)
 - Ability to switch players (DONE)
 - Showing which player has one (DONE)
 - Ability to play against the computer
