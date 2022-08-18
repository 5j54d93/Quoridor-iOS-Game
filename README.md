# Quoridor iOS Game

[![GitHub license](https://img.shields.io/github/license/5j54d93/Quoridor-iOS-Game)](https://github.com/5j54d93/Quoridor-iOS-Game/blob/main/LICENSE)
![GitHub Repo stars](https://img.shields.io/github/stars/5j54d93/Quoridor-iOS-Game)
![GitHub repo size](https://img.shields.io/github/repo-size/5j54d93/Quoridor-iOS-Game)
![Platform](https://img.shields.io/badge/platform-iOS｜iPadOS｜macOS-lightgrey)

An iOS game develop with [**SwiftUI**](https://developer.apple.com/xcode/swiftui) & [**Firebase**](https://firebase.google.com) in MVVM with so many excellent features！UI refer to [**STARLUX**](https://www.starlux-airlines.com)、[**Pokémon GO**](https://pokemongolive.com) and [**Instagram**](https://www.instagram.com). User could login with many social media accounts and play Quoridor with others on Internet.

<img src="https://repository-images.githubusercontent.com/524391031/d73dd059-7e15-4adb-b99b-97d1fab9c4e1"/>

## Overview

## Authentication

### Sign In／Sign Up

User should choose form "RETURING PLAYER" or "NEW PLAYER" first, then we'll use this to decide to display "Sign in" or "Sign up". We provide 4 Sign-in method：Facebook、Google、Twitter、Email/Password

<img src="https://github.com/5j54d93/Quoridor-iOS-Game/blob/main/.github/assets/Sign%20In/choosePlayerType.png" width="33.33%"/><img src="https://github.com/5j54d93/Quoridor-iOS-Game/blob/main/.github/assets/Sign%20In/chooseSignInMethod.png" width="33.33%"/><img src="https://github.com/5j54d93/Quoridor-iOS-Game/blob/main/.github/assets/Sign%20In/chooseSignUpMethod.png" width="33.33%"/>

> **Demo GIF**：iPhone 13 Pro Max

<img src="https://github.com/5j54d93/Quoridor-iOS-Game/blob/main/.github/assets/Sign%20In/facebookLogin.gif" width="33.33%"/><img src="https://github.com/5j54d93/Quoridor-iOS-Game/blob/main/.github/assets/Sign%20In/googleSignIn.gif" width="33.33%"/><img src="https://github.com/5j54d93/Quoridor-iOS-Game/blob/main/.github/assets/Sign%20In/twitterSignIn.gif" width="33.33%"/>

### Forgot Password and Reset It

We'll show forgot passwrod button only if user is "RETURING PLAYER", this will send a change password email to user.

<img src="https://github.com/5j54d93/Quoridor-iOS-Game/blob/main/.github/assets/Sign%20In/forgotPassword.gif" width="33.33%"/><img src="https://github.com/5j54d93/Quoridor-iOS-Game/blob/main/.github/assets/Sign%20In/emailSignIn.gif" width="33.33%"/><img src="https://github.com/5j54d93/Quoridor-iOS-Game/blob/main/.github/assets/Sign%20In/resetPassword.gif" width="33.33%"/>

### Change Password

User could change password in settings but must have signed in recently. And if users haven't link an email account to Quoridor, they won't see change password in settings because sign in with Facebook, Google or Twitter didn't have to use password.

<img src="https://github.com/5j54d93/Quoridor-iOS-Game/blob/main/.github/assets/Settings/security.png" width="33.33%"/><img src="https://github.com/5j54d93/Quoridor-iOS-Game/blob/main/.github/assets/Settings/changePassword.png" width="33.33%"/><img src="https://github.com/5j54d93/Quoridor-iOS-Game/blob/main/.github/assets/Settings/changePassword.gif" width="33.33%"/>

### Link Multiple Auth Providers

User could connect their social medias' account to a sigle Quoridor account. This let user could sign in through multiple methods！

User could also disconnect account that have connected to Quoridor, but must remain at least one sign in method.

<img src="https://github.com/5j54d93/Quoridor-iOS-Game/blob/main/.github/assets/Settings/connects.gif" width="33.33%"/><img src="https://github.com/5j54d93/Quoridor-iOS-Game/blob/main/.github/assets/Settings/connects.png" width="33.33%"/><img src="https://github.com/5j54d93/Quoridor-iOS-Game/blob/main/.github/assets/Settings/connectError.png" width="33.33%"/>

### Delete Account

Users could delete their Quoridor account if they want. We'll delete their data on Firestore, Firestorage and Firebase Authentication.

<img src="https://github.com/5j54d93/Quoridor-iOS-Game/blob/main/.github/assets/Settings/deleteAccount.gif" width="33.33%"/><img src="https://github.com/5j54d93/Quoridor-iOS-Game/blob/main/.github/assets/Settings/deleteAccount.png" width="33.33%"/><img src="https://github.com/5j54d93/Quoridor-iOS-Game/blob/main/.github/assets/Settings/confirmDeleteAccount.png" width="33.33%"/>

## Player's Profile

If user sign up with Facebook, Google or Twitter, we'll use their name and photo to initialize thier profile. User could edit their info, remove photo and create their avatar later.

<img src="https://github.com/5j54d93/Quoridor-iOS-Game/blob/main/.github/assets/Profile/profile.png" width="25%"/><img src="https://github.com/5j54d93/Quoridor-iOS-Game/blob/main/.github/assets/Profile/editProfile.png" width="25%"/><img src="https://github.com/5j54d93/Quoridor-iOS-Game/blob/main/.github/assets/Profile/changePhotoMethods.png" width="25%"/><img src="https://github.com/5j54d93/Quoridor-iOS-Game/blob/main/.github/assets/Profile/designAvatar.png" width="25%"/>

## Game

### Game Reward

User can get random money from $1 to $200 every 4 games.

<img src="https://github.com/5j54d93/Quoridor-iOS-Game/blob/main/.github/assets/Game/gameRewardHint.png" width="25%"/><img src="https://github.com/5j54d93/Quoridor-iOS-Game/blob/main/.github/assets/Game/gameReward2.png" width="25%"/><img src="https://github.com/5j54d93/Quoridor-iOS-Game/blob/main/.github/assets/Game/gameReward4.png" width="25%"/><img src="https://github.com/5j54d93/Quoridor-iOS-Game/blob/main/.github/assets/Game/getGameReward.png" width="25%"/>

### Game Type：Rank、Casual

User could create a rank room or casual room, but rank room need to cost $200, and casual room for free. Other players could also use room id to join. We use different color to separate rank and casual.

<img src="https://github.com/5j54d93/Quoridor-iOS-Game/blob/main/.github/assets/Game/rankRoom.png" width="33.33%"/><img src="https://github.com/5j54d93/Quoridor-iOS-Game/blob/main/.github/assets/Game/casualRoom.png" width="33.33%"/><img src="https://github.com/5j54d93/Quoridor-iOS-Game/blob/main/.github/assets/Game/inputRoomId.png" width="33.33%"/>

### Start the Game！

If there are already 2 players in a room, only room owner could start the game but need the other player to click "Ready to Play". And if there are only 1 player in a room, user could also click the "Start the Game", we'll match player for user.

<img src="https://github.com/5j54d93/Quoridor-iOS-Game/blob/main/.github/assets/Game/roomOwner.png" width="33.33%"/><img src="https://github.com/5j54d93/Quoridor-iOS-Game/blob/main/.github/assets/Game/joinPlayer.png" width="33.33%"/><img src="https://github.com/5j54d93/Quoridor-iOS-Game/blob/main/.github/assets/Game/matching.png" width="33.33%"/>

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

This repository is [MIT licensed](https://github.com/5j54d93/Quoridor-iOS-Game/blob/main/LICENSE).
