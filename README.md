# Quoridor iOS Game

[![GitHub license](https://img.shields.io/github/license/5j54d93/Quoridor-iOS-Game)](https://github.com/5j54d93/Quoridor-iOS-Game/blob/main/LICENSE)
![GitHub Repo stars](https://img.shields.io/github/stars/5j54d93/Quoridor-iOS-Game)
![GitHub repo size](https://img.shields.io/github/repo-size/5j54d93/Quoridor-iOS-Game)
![Platform](https://img.shields.io/badge/platform-iOS｜iPadOS｜macOS-lightgrey)

An iOS game develop with [**SwiftUI**](https://developer.apple.com/xcode/swiftui) & [**Firebase**](https://firebase.google.com) in MVVM with so many excellent features！UI refer to [**STARLUX**](https://www.starlux-airlines.com)、[**Pokémon GO**](https://pokemongolive.com) and [**Instagram**](https://www.instagram.com). User could login with many social media accounts and play Quoridor with others on Internet.

<img src="https://repository-images.githubusercontent.com/524391031/d73dd059-7e15-4adb-b99b-97d1fab9c4e1"/>

## Overview

## Authentication

<img src="https://github.com/5j54d93/Quoridor-iOS-Game/blob/main/.github/assets/Sign%20In/firebaseAuthentication.png"/>

### Sign In／Sign Up

- User should choose「**RETURING PLAYER**」or「**NEW PLAYER**」first
  - If user choose RETURING PLAYER will display「**Sign in**」and show「**Forgot your password？**」button
  - If user choose NEW PLAYER will display「**Sign up**」and hide「**Forgot your password？**」button
- We provide **4 Sign-in method**：
  - Facebook、Google、Twitter：「Sign In」and「Sign Up」are using the same function
  - Email／Password：
    - If user has finished typing email, he/she could click「**Enter**」on the keyboard to switch `@FocusState` to password rather than touch the password field on screen
    - If user has finished typing password, he/she could click「**Enter**」on the keyboard to process「Sign In」or「Sign Up」rather than click the button on screen

<img src="https://github.com/5j54d93/Quoridor-iOS-Game/blob/main/.github/assets/Sign%20In/choosePlayerType.png" width="24.685%"/> <img src="https://github.com/5j54d93/Quoridor-iOS-Game/blob/main/.github/assets/Sign%20In/chooseSignInMethod.png" width="24.685%"/> <img src="https://github.com/5j54d93/Quoridor-iOS-Game/blob/main/.github/assets/Sign%20In/chooseSignUpMethod.png" width="24.685%"/> <img src="https://github.com/5j54d93/Quoridor-iOS-Game/blob/main/.github/assets/Sign%20In/forgotPassword.gif" width="24.685%"/>

> **Demo GIF** on iPhone 13 Pro Max：_This may need some time to load._

<img src="https://github.com/5j54d93/Quoridor-iOS-Game/blob/main/.github/assets/Sign%20In/facebookLogin.gif" width="25%"/><img src="https://github.com/5j54d93/Quoridor-iOS-Game/blob/main/.github/assets/Sign%20In/googleSignIn.gif" width="25%"/><img src="https://github.com/5j54d93/Quoridor-iOS-Game/blob/main/.github/assets/Sign%20In/twitterSignIn.gif" width="25%"/><img src="https://github.com/5j54d93/Quoridor-iOS-Game/blob/main/.github/assets/Sign%20In/emailSignIn.gif" width="25%"/>

### Forgot & Reset Password

- 「**Forgot your password？**」button will show only if user is a「**RETURING PLAYER**」
- We'll send a reset password email to what email account user input
- User could follow the link in email to reset their password

<img src="https://github.com/5j54d93/Quoridor-iOS-Game/blob/main/.github/assets/Sign%20In/resetPassword.gif" width="25%"/><img src="https://github.com/5j54d93/Quoridor-iOS-Game/blob/main/.github/assets/Sign%20In/resetPasswordEmail.png" width="75%"/>

### Change Password

- Only if user had linked an email account to Quoridor could see security section and change their password in settings because sign in with Facebook, Google or Twitter doesn't need to use password
- Because we couldn't access user's password through Firebase to check the current password that user inputed is correct, I save user's password in `@AppStorage` when they login or link using「Email／Password」successfully
- Because changing password is a security-sensitive action, Firebase need user to have signed in recently. If user had login for a while, we'll show error to tell user to relogin and try again
- While `SecureField` is focused, the prompt will become smaller and move up, the clear button will appear on right
- While `SecureField` is not focused, but it has value, the prompt will not back to down, the clear button will disappear
- The third `SecureField`'s prompt,「New password, again」, will determine whether the second and third `SecureField`'s values are the same, if not, it will display red alert message instead
- Only if all three `SecureField` have value and two new passwords are match could click the「SAVE」button on top right to change password
- Using `@FocusState` and `onSubmit` to let user could change focus to the next `SecureField` easily by clicking「Enter」on the keyboard
- Click on the blank below will cancel any `@FocusState` on `SecureField`

<img src="https://github.com/5j54d93/Quoridor-iOS-Game/blob/main/.github/assets/Settings/changePassword.gif" width="25%"/><img src="https://github.com/5j54d93/Quoridor-iOS-Game/blob/main/.github/assets/Settings/security.png" width="25%"/><img src="https://github.com/5j54d93/Quoridor-iOS-Game/blob/main/.github/assets/Settings/changePassword.png" width="25%"/><img src="https://github.com/5j54d93/Quoridor-iOS-Game/blob/main/.github/assets/Settings/changePasswordError.png" width="25%"/>

### Link Multiple Auth Providers

- User could sign in Quoridor and access the same account using different social media accounts that they had connected.
- User could also disconnect accounts that have connected to Quoridor, but must remain at least one sign in method, other wise, when they log out, they won't have any method to access their account.

<img src="https://github.com/5j54d93/Quoridor-iOS-Game/blob/main/.github/assets/Settings/connects.gif" width="25%"/><img src="https://github.com/5j54d93/Quoridor-iOS-Game/blob/main/.github/assets/Settings/connectUnexpandEmail.png" width="25%"/><img src="https://github.com/5j54d93/Quoridor-iOS-Game/blob/main/.github/assets/Settings/connects.png" width="25%"/><img src="https://github.com/5j54d93/Quoridor-iOS-Game/blob/main/.github/assets/Settings/connectError.png" width="25%"/>

### Delete Account

Users could delete their Quoridor account if they want. We'll delete their data on Firestore, Firestorage and Firebase Authentication.

<img src="https://github.com/5j54d93/Quoridor-iOS-Game/blob/main/.github/assets/Settings/deleteAccount.gif" width="33.33%"/><img src="https://github.com/5j54d93/Quoridor-iOS-Game/blob/main/.github/assets/Settings/deleteAccount.png" width="33.33%"/><img src="https://github.com/5j54d93/Quoridor-iOS-Game/blob/main/.github/assets/Settings/confirmDeleteAccount.png" width="33.33%"/>

## Custom Launch Screen

- After user login successfully or just opened Quoridor app, will show custom launch screen
- We add a snapshot listener on player's data when user touch the screen

<img src="https://github.com/5j54d93/Quoridor-iOS-Game/blob/main/.github/assets/launchScreen.gif" width="25%"/> <img src="https://github.com/5j54d93/Quoridor-iOS-Game/blob/main/.github/assets/launchScreen.png" width="25%"/>

## Player's Profile

<img src="https://github.com/5j54d93/Quoridor-iOS-Game/blob/main/.github/assets/Profile/CloudFirestore.png"/>

If user sign up with Facebook, Google or Twitter, we'll use their name and photo to initialize thier profile. User could edit their info, remove photo and create their avatar later.

<img src="https://github.com/5j54d93/Quoridor-iOS-Game/blob/main/.github/assets/Profile/profile.png" width="25%"/><img src="https://github.com/5j54d93/Quoridor-iOS-Game/blob/main/.github/assets/Profile/editProfile.png" width="25%"/><img src="https://github.com/5j54d93/Quoridor-iOS-Game/blob/main/.github/assets/Profile/changePhotoMethods.png" width="25%"/><img src="https://github.com/5j54d93/Quoridor-iOS-Game/blob/main/.github/assets/Profile/designAvatar.png" width="25%"/>

## Game

### Game Reward

User can get random money from $1 to $200 every 4 games.

<img src="https://github.com/5j54d93/Quoridor-iOS-Game/blob/main/.github/assets/Game/gameRewardHint.png" width="25%"/><img src="https://github.com/5j54d93/Quoridor-iOS-Game/blob/main/.github/assets/Game/gameReward2.png" width="25%"/><img src="https://github.com/5j54d93/Quoridor-iOS-Game/blob/main/.github/assets/Game/gameReward4.png" width="25%"/><img src="https://github.com/5j54d93/Quoridor-iOS-Game/blob/main/.github/assets/Game/getGameReward.png" width="25%"/>

### Game Type：Rank、Casual

- We use different colors to separate rank and casual.
- Each room could have 2 players at most

|         |       Rank       |  Casual   |
|   :-:   |       :-:        |    :-:    |
|**Color**|    rose gold     |earthy gold|
|**Cost** |       $200       |   free    |
| **Win** |get $400 & 1 star |  nothing  |
|**Lose** |lose $200 & 1 star|  nothing  |

- Player could use room id to join room created by other player
- If user's money is less than $200, we won't let he/she to create a rank room or join a rank room

<img src="https://github.com/5j54d93/Quoridor-iOS-Game/blob/main/.github/assets/Game/gameReward2.png" width="25%"/><img src="https://github.com/5j54d93/Quoridor-iOS-Game/blob/main/.github/assets/Game/rankRoom.png" width="25%"/><img src="https://github.com/5j54d93/Quoridor-iOS-Game/blob/main/.github/assets/Game/casualRoom.png" width="25%"/><img src="https://github.com/5j54d93/Quoridor-iOS-Game/blob/main/.github/assets/Game/inputRoomId.png" width="25%"/>

### Start the Game！

- Players in a room could be a「**room owner**」or「**joined player**」
- After the game be started, any player in the room could leave by tap the button on top left
  - If there are 1 player in the room：
    - We'll delete the room on Firestore
  - If there are 2 players in the room：
    - If user is a room owner, the other player will become the room owner
    - If user is a joined player, just leave the room
- Start the Game：
  - If there are 1 player in the room：
    - User could click「Start the Game」, we'll match a player for he/she
  - If there are 2 players in the room：
    - Room Owner：have permission to start the game but need the other player to had clicked「Ready to Play」to be in ready state
    - Joined Player：can't start the game, could only click on「Ready to Play」when they're ready for playing
- Players could read other player's info simply by click on their block

<img src="https://github.com/5j54d93/Quoridor-iOS-Game/blob/main/.github/assets/Game/roomOwner.png" width="25%"/><img src="https://github.com/5j54d93/Quoridor-iOS-Game/blob/main/.github/assets/Game/joinPlayer.png" width="25%"/><img src="https://github.com/5j54d93/Quoridor-iOS-Game/blob/main/.github/assets/playerInfo.png" width="25%"/><img src="https://github.com/5j54d93/Quoridor-iOS-Game/blob/main/.github/assets/Game/matching.png" width="25%"/>

### Playing Quoridor！

- Each turn player could build wall or move chessman.
- Every player only have 10 wall to build.
- We'll show available position that chessman could move.
- Players only have 40 seconds each turn, if player doesn't do anything, next turn player will only have 8 seconds.
- If player do nothing 5 turns will lose this game.
- Player could give up the game any time.

<img src="https://github.com/5j54d93/Quoridor-iOS-Game/blob/main/.github/assets/Game/nextMove.png" width="25%"/><img src="https://github.com/5j54d93/Quoridor-iOS-Game/blob/main/.github/assets/Game/playing.png" width="25%"/><img src="https://github.com/5j54d93/Quoridor-iOS-Game/blob/main/.github/assets/Game/gameSettings.png" width="25%"/><img src="https://github.com/5j54d93/Quoridor-iOS-Game/blob/main/.github/assets/Game/endGame.png" width="25%"/>

## Google AdMod：Watch Video to get money $200！

Every day player could watch video one time to get $200！

<img src="https://github.com/5j54d93/Quoridor-iOS-Game/blob/main/.github/assets/Game/haven'tWatchedAdMod.png" width="25%"/><img src="https://github.com/5j54d93/Quoridor-iOS-Game/blob/main/.github/assets/Game/watchingAdMod.png" width="25%"/><img src="https://github.com/5j54d93/Quoridor-iOS-Game/blob/main/.github/assets/Game/get$200.png" width="25%"/><img src="https://github.com/5j54d93/Quoridor-iOS-Game/blob/main/.github/assets/Game/haveWatchedAdMod.png" width="25%"/>

## Leader Board

Could sort by：Star、Win Rate、Money

<img src="https://github.com/5j54d93/Quoridor-iOS-Game/blob/main/.github/assets/Leader%20Board/sortByStar.png" width="33.33%"/><img src="https://github.com/5j54d93/Quoridor-iOS-Game/blob/main/.github/assets/Leader%20Board/sortByWinRate.png" width="33.33%"/><img src="https://github.com/5j54d93/Quoridor-iOS-Game/blob/main/.github/assets/Leader%20Board/sortByMoney.png" width="33.33%"/>

## License：MIT

This package is [MIT licensed](https://github.com/5j54d93/Quoridor-iOS-Game/blob/main/LICENSE).
