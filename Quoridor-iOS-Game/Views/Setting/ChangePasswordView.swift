//
//  ChangePasswordView.swift
//  Quoridor-iOS-Game
//
//  Created by 莊智凱 on 2022/7/4.
//

import SwiftUI

struct ChangePasswordView: View {
    
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    
    @AppStorage("currentPassword") var currentPassword = ""
    
    @ObservedObject var authViewModel: AuthViewModel
    
    @State private var inputCurrentPassword = ""
    @State private var currentPasswordOffect: CGFloat = 0
    @State private var inputNewPassword = ""
    @State private var newPasswordOffect: CGFloat = 0
    @State private var inputNewPasswordAgain = ""
    @State private var newPasswordAgainOffect: CGFloat = 0
    @State private var isPasswordMatch = true
    @State private var isShowAlert = false
    @State private var alertMessage = ""
    
    enum Field: Hashable { case currentPassword, newPassword, newPasswordAgain }
    
    @FocusState private var focusedField: Field?
    
    var body: some View {
        GeometryReader { geometry in
            VStack {
                HStack {
                    Button {
                        self.presentationMode.wrappedValue.dismiss()
                    } label: {
                        Text(Image(systemName: "chevron.backward"))
                            .font(.title3.bold())
                    }
                    
                    Spacer()
                    
                    Button {
                        changePassword()
                    } label: {
                        Text("Save")
                            .font(.title3.bold())
                            .foregroundColor([inputCurrentPassword, inputNewPassword, inputNewPasswordAgain].allSatisfy({ !$0.isEmpty }) && isPasswordMatch ? .lightBrown : .white.opacity(0.65))
                    }
                    .disabled(![inputCurrentPassword, inputNewPassword, inputNewPasswordAgain].allSatisfy({ !$0.isEmpty }) || !isPasswordMatch)
                }
                .overlay {
                    Text("Change password")
                        .font(.title2.bold())
                }
                .padding(.horizontal)
                
                Divider()
                    .frame(height: 1)
                    .overlay(Color.earthyGold)
                
                Text("Your password must be at least 6 characters and should include a combination of numbers and letters.")
                    .padding()
                
                Group {
                    SecureField("Current password", text: $inputCurrentPassword)
                        .padding(.vertical)
                        .border(width: 1, edges: [.bottom], color: .earthyGold)
                        .foregroundColor(.white)
                        .focused($focusedField, equals: .currentPassword)
                        .onSubmit {
                            focusedField = .newPassword
                            if inputCurrentPassword.isEmpty {
                                currentPasswordOffect = 0
                            }
                            newPasswordOffect = -20
                        }
                        .overlay {
                            HStack {
                                Text("Current password")
                                    .font(focusedField == .currentPassword || !inputCurrentPassword.isEmpty ? .body : .title2)
                                    .foregroundColor(.white.opacity(0.65))
                                    .offset(y: currentPasswordOffect)
                                    .onTapGesture {
                                        focusedField = .currentPassword
                                        withAnimation {
                                            currentPasswordOffect = -20
                                            if inputNewPassword.isEmpty {
                                                newPasswordOffect = 0
                                            }
                                            if inputNewPasswordAgain.isEmpty {
                                                newPasswordAgainOffect = 0
                                            }
                                        }
                                    }
                                
                                Spacer()
                                
                                if focusedField == .currentPassword {
                                    Button {
                                        inputCurrentPassword = ""
                                    } label: {
                                        Text(Image(systemName: "xmark.circle.fill"))
                                    }
                                }
                            }
                        }
                    
                    SecureField("New password", text: $inputNewPassword)
                        .padding(.vertical)
                        .border(width: 1, edges: [.bottom], color: .earthyGold)
                        .foregroundColor(.white)
                        .focused($focusedField, equals: .newPassword)
                        .onSubmit {
                            focusedField = .newPasswordAgain
                            if inputNewPassword.isEmpty {
                                newPasswordOffect = 0
                            }
                            newPasswordAgainOffect = -20
                        }
                        .overlay {
                            HStack {
                                Text("New password")
                                    .font(focusedField == .newPassword || !inputNewPassword.isEmpty ? .body : .title2)
                                    .foregroundColor(.white.opacity(0.65))
                                    .offset(y: newPasswordOffect)
                                    .onTapGesture {
                                        focusedField = .newPassword
                                        withAnimation {
                                            if inputCurrentPassword.isEmpty {
                                                currentPasswordOffect = 0
                                            }
                                            newPasswordOffect = -20
                                            if inputNewPasswordAgain.isEmpty {
                                                newPasswordAgainOffect = 0
                                            }
                                        }
                                    }
                                
                                Spacer()
                                
                                if focusedField == .newPassword {
                                    Button {
                                        inputNewPassword = ""
                                    } label: {
                                        Text(Image(systemName: "xmark.circle.fill"))
                                    }
                                }
                            }
                        }
                    
                    SecureField("New password, again", text: $inputNewPasswordAgain)
                        .padding(.vertical)
                        .border(width: 1, edges: [.bottom], color: .earthyGold)
                        .foregroundColor(.white)
                        .focused($focusedField, equals: .newPasswordAgain)
                        .onSubmit {
                            focusedField = .none
                            if inputNewPasswordAgain.isEmpty {
                                newPasswordAgainOffect = 0
                            }
                            changePassword()
                        }
                        .overlay {
                            HStack {
                                Text(isPasswordMatch ? "New password, again" : "Passwords doesn't match")
                                    .font(focusedField == .newPasswordAgain || !inputNewPasswordAgain.isEmpty ? .body : .title2)
                                    .foregroundColor(isPasswordMatch ? .white.opacity(0.65) : .red)
                                    .offset(y: newPasswordAgainOffect)
                                    .onTapGesture {
                                        focusedField = .newPasswordAgain
                                        withAnimation {
                                            if inputCurrentPassword.isEmpty {
                                                currentPasswordOffect = 0
                                            }
                                            if inputNewPassword.isEmpty {
                                                newPasswordOffect = 0
                                            }
                                            newPasswordAgainOffect = -20
                                        }
                                    }
                                
                                Spacer()
                                
                                if focusedField == .newPasswordAgain {
                                    Button {
                                        inputNewPasswordAgain = ""
                                    } label: {
                                        Text(Image(systemName: "xmark.circle.fill"))
                                    }
                                }
                            }
                        }
                        .onChange(of: inputNewPasswordAgain) { _ in
                            if inputNewPasswordAgain.isEmpty {
                                isPasswordMatch = true
                            } else {
                                isPasswordMatch = inputNewPasswordAgain == inputNewPassword
                            }
                        }
                }
                .padding(.horizontal, 25)
                .padding(.bottom, 1)
                
                Spacer()
            }
            .navigationBarHidden(true)
            .foregroundColor(.white)
            .background(Color.backgroundColor)
            .onTapGesture {
                focusedField = .none
                if inputCurrentPassword.isEmpty {
                    currentPasswordOffect = 0
                }
                if inputNewPassword.isEmpty {
                    newPasswordOffect = 0
                }
                if inputNewPasswordAgain.isEmpty {
                    newPasswordAgainOffect = 0
                }
            }
            .overlay {
                if isShowAlert {
                    Color.backgroundColor
                        .ignoresSafeArea()
                        .overlay {
                            VStack {
                                VStack(spacing: 20) {
                                    Text(alertMessage)
                                        .foregroundColor(.roseGold)
                                    
                                    Button {
                                        isShowAlert = false
                                        self.presentationMode.wrappedValue.dismiss()
                                    } label: {
                                        Capsule()
                                            .frame(width: geometry.size.width*4/7, height: 50)
                                            .foregroundColor(.roseGold)
                                            .overlay {
                                                Text("OK")
                                                    .font(.title3.bold())
                                                    .foregroundColor(.white)
                                            }
                                    }
                                }
                                .padding(.vertical, 20)
                                .frame(maxWidth: .infinity)
                                .background {
                                    RoundedRectangle(cornerRadius: 5)
                                        .foregroundColor(.white)
                                }
                            }
                            .padding(.horizontal)
                        }
                }
            }
        }
    }
    
    func changePassword() {
        if [inputCurrentPassword, inputNewPassword, inputNewPasswordAgain].allSatisfy({ !$0.isEmpty }), isPasswordMatch {
            if inputCurrentPassword != currentPassword {
                alertMessage = "Your current password doesn't correct."
                isShowAlert = true
            } else {
                authViewModel.updatePassword(password: inputNewPassword) { result in
                    switch result {
                    case .success():
                        currentPassword = inputNewPassword
                        alertMessage = "You've change password successfully."
                        isShowAlert = true
                    case .failure(let error):
                        alertMessage = error.localizedDescription
                        isShowAlert = true
                    }
                }
            }
        }
    }
}
