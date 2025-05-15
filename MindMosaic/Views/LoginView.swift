import SwiftUI

// login main view
struct LoginView: View {
    @EnvironmentObject var userManager: UserManager
    @State private var username = ""
    @State private var password = ""
    @State private var showRegister = false
    @State private var loginFailed = false

    var body: some View {
        ZStack {
            LinearGradient(
                gradient: Gradient(colors: [Color.white, Color.cyan.opacity(0.3)]),
                startPoint: .top,
                endPoint: .bottom
            )
            .ignoresSafeArea()

            VStack(spacing: 30) {
                Spacer().frame(height: 20)

                //app logo
                Image("mmlogo")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 220, height: 220)
                    .cornerRadius(30)


                Text("\"MindMosaic, Your Pocket Companion to Wellness\"")
                    .font(.headline)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal)
                    .foregroundColor(.black)

                
                //login section
                VStack(spacing: 16) {
                    styledInputField(icon: "person.fill", placeholder: "Username", text: $username)
                    styledInputField(icon: "lock.fill", placeholder: "Password", text: $password, isSecure: true)

                    if loginFailed {
                        Text("Invalid credentials")
                            .foregroundColor(.red)
                            .font(.caption)
                    }

                    Button(action: {
                        loginFailed = !userManager.login(username: username, password: password)
                    }) {
                        Text("Login")
                            .fontWeight(.semibold)
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(Color.cyan.opacity(0.6))
                            .foregroundColor(.white)
                            .cornerRadius(25)
                    }

                    Button(action: {
                        showRegister = true
                    }) {
                        Text("Sign Up")
                            .fontWeight(.semibold)
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(Color.black)
                            .foregroundColor(.white)
                            .cornerRadius(25)
                    }
                    .sheet(isPresented: $showRegister) {
                        RegisterView()
                    }
                }
                .padding(.horizontal)

                Spacer()

                Text("www.mindmosaic.com")
                    .font(.caption2)
                    .foregroundColor(.gray)
                    .padding(.bottom, 10)
            }
        }
    }
}

//input view, also secure 
@ViewBuilder
func styledInputField(
    icon: String,
    placeholder: String,
    text: Binding<String>,
    isSecure: Bool = false
) -> some View {
    HStack {
        Image(systemName: icon)
            .foregroundColor(.gray)

        ZStack(alignment: .leading) {
            if text.wrappedValue.isEmpty {
                Text(placeholder)
                    .foregroundColor(.gray)
                    .padding(.leading, 2)
            }

            if isSecure {
                SecureField("", text: text)
                    .autocapitalization(.none)
                    .foregroundColor(.black)
            } else {
                TextField("", text: text)
                    .autocapitalization(.none)
                    .foregroundColor(.black)
            }
        }
    }
    .padding()
    .background(Color.white)
    .cornerRadius(15)
    .shadow(color: .gray.opacity(0.2), radius: 4, x: 0, y: 2)
}
