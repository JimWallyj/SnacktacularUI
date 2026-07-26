//
//  LoginView.swift
//  SnacktacularUI
//
//  Created by JIM WALEJKO on 6/8/26.
//  JimW@me.com login; Awesome1 password

import SwiftUI
import Firebase
import FirebaseAuth

struct LoginView: View {
    enum Field{
        case email, password
    }
    
    @State private var email = ""
    @State private var password = ""
    @State private var showingAlert = false
    @State private var alertMessage = ""
    @State private var buttonDisabled = true
    @State private var presentSheet = false
    @FocusState private var focusedField: Field?
    
    
    var body: some View {
        VStack {
            Image("logo")
                .resizable()
                .scaledToFit()
                .padding()
            
            Group {
                TextField("E-mail", text: $email)
                    .keyboardType(.emailAddress)
                    .autocorrectionDisabled()
                    .textInputAutocapitalization(.never)
                    .submitLabel(.next)
                    .focused($focusedField, equals: .email)  //this field is bound to the .email case
                    .onSubmit {
                        focusedField = .password
                    }
                    .onChange(of: email){ _ in
                        enableButtons()
                    }
                
                SecureField("password", text: $password)
                    .textInputAutocapitalization(.never)
                    .submitLabel(.done)
                    .focused($focusedField, equals: .password)  //  this field is bound to the .password case
                    .onSubmit {
                        focusedField = nil  //  nil will dismiss the keyboard
                    }
                    .onChange(of: password){ _ in
                        enableButtons()
                    }
            }
            .textFieldStyle(.roundedBorder)
            .overlay{
                RoundedRectangle(cornerRadius: 5)
                    .stroke(.gray.opacity(0.5), lineWidth: 2)
            }
            .padding(.horizontal)
            
            HStack{
                Button{
                    register()
                } label: {
                    Text("Sign Up")
                }
                .padding(.trailing)
                
                Button{
                    login()
                }label:{
                    Text("Log In")
                }
                
                .padding(.leading)
            }
            .buttonStyle(.borderedProminent)
            .tint(.snack)
            .font(.title2)
            .padding(.top)
            .disabled(buttonDisabled)
        }
        
        .alert(alertMessage, isPresented: $showingAlert) {
            Button("OK", role: .cancel){ }
        }
        .onAppear(){
            //  if logged in when app runs, navigate to the new screen & skip login screen
            if Auth.auth().currentUser != nil{  //  If we're logged in ...
                print("🪵 Log in successful!")
                presentSheet = true
            }
        }
        .fullScreenCover(isPresented: $presentSheet) {
            ListView()
        }
    }
    
    func enableButtons(){
        let emailIsGood = email.count >= 6 && email.contains("@")
        let passwordIsGood = password.count >= 6
        buttonDisabled = !(emailIsGood && passwordIsGood)
    }
    
    func register() {
        Auth.auth().createUser(withEmail: email, password: password) { result, error in
            if let error = error{  //login error occurred
                print("😡 SIGNUP ERROR: \(error.localizedDescription)")
                alertMessage = "😡 LOGIN ERROR: \(error.localizedDescription)"
                showingAlert = true
            }else{
                print("😎 Registration success!")
                presentSheet = true
            }
        }
    }
    
    func login(){
        Auth.auth().signIn(withEmail: email, password: password) { result, error in
            if let error = error{  //  login error occurred
                print("😡 LOGIN ERROR: \(error.localizedDescription)")
                alertMessage = "😡 LOGIN ERROR: \(error.localizedDescription)"
                showingAlert = true
            }else{
                print("🪵 Login success!")
                presentSheet = true
            }
        }
    }
}

struct LoginView_Previews: PreviewProvider{
    static var previews: some View{
        LoginView()
    }
}
