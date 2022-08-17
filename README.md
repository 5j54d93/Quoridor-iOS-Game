# Quoridor iOS Game

[![GitHub license](https://img.shields.io/github/license/5j54d93/Quoridor-iOS-Game)](https://github.com/5j54d93/Quoridor-iOS-Game/blob/main/LICENSE)
![GitHub Repo stars](https://img.shields.io/github/stars/5j54d93/Quoridor-iOS-Game)
![GitHub repo size](https://img.shields.io/github/repo-size/5j54d93/Quoridor-iOS-Game)
![Platform](https://img.shields.io/badge/platform-iOS｜iPadOS｜macOS-lightgrey)

An iOS game develop with SwiftUI & Firebase, that has many features.

<img src="https://repository-images.githubusercontent.com/524391031/4ae582a3-aa3f-49a8-a8ba-f51c5fae460f"/>

## Overview

## Introduction

### Authentication

User should choose form "RETURING PLAYER" or "NEW PLAYER" first, then we'll use this to decide to display "Sign in" or "Sign up". We provide 4 Sign-in method：Facebook、Google、Twitter、Email/Password

<img src="https://github.com/5j54d93/Quoridor-iOS-Game/blob/main/.github/assets/Sign%20In/choosePlayerType.png" width="33.33%"/><img src="https://github.com/5j54d93/Quoridor-iOS-Game/blob/main/.github/assets/Sign%20In/chooseSignInMethod.png" width="33.33%"/><img src="https://github.com/5j54d93/Quoridor-iOS-Game/blob/main/.github/assets/Sign%20In/chooseSignUpMethod.png" width="33.33%"/>

> **Demo GIF**：iPhone 13 Pro Max

<img src="https://github.com/5j54d93/Quoridor-iOS-Game/blob/main/.github/assets/Sign%20In/facebookLogin.gif" width="33.33%"/><img src="https://github.com/5j54d93/Quoridor-iOS-Game/blob/main/.github/assets/Sign%20In/googleSignIn.gif" width="33.33%"/><img src="https://github.com/5j54d93/Quoridor-iOS-Game/blob/main/.github/assets/Sign%20In/twitterSignIn.gif" width="33.33%"/>

We'll show forgot passwrod button only if user is "RETURING PLAYER", this will send a change password email to user.

<img src="https://github.com/5j54d93/Quoridor-iOS-Game/blob/main/.github/assets/Sign%20In/signInWithEmail.png" width="33.33%"/><img src="https://github.com/5j54d93/Quoridor-iOS-Game/blob/main/.github/assets/Sign%20In/signUpWithEmail.png" width="33.33%"/><img src="https://github.com/5j54d93/Quoridor-iOS-Game/blob/main/.github/assets/Sign%20In/forgotPassword.png" width="33.33%"/>

> **Demo GIF**：iPhone 13 Pro Max

<img src="https://github.com/5j54d93/Quoridor-iOS-Game/blob/main/.github/assets/Sign%20In/forgotPassword.gif" width="33.33%"/><img src="https://github.com/5j54d93/Quoridor-iOS-Game/blob/main/.github/assets/Sign%20In/emailSignIn.gif" width="33.33%"/><img src="https://github.com/5j54d93/Quoridor-iOS-Game/blob/main/.github/assets/Sign%20In/resetPassword.gif" width="33.33%"/>

#### Change Password

User could change password in settings but must have signed in recently.

<img src="https://github.com/5j54d93/Quoridor-iOS-Game/blob/main/.github/assets/Settings/security.png" width="33.33%"/><img src="https://github.com/5j54d93/Quoridor-iOS-Game/blob/main/.github/assets/Settings/changePassword.png" width="33.33%"/><img src="https://github.com/5j54d93/Quoridor-iOS-Game/blob/main/.github/assets/Settings/changePassword.gif" width="33.33%"/>

#### Link Multiple Auth Providers

## License：MIT

This package is [MIT licensed](https://github.com/5j54d93/Quoridor-iOS-Game/blob/main/LICENSE).
