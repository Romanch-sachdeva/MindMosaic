import SwiftUI

struct LoginView: View {
    @EnvironmentObject var userManager: UserManager
    @State private var username = ""
    @State private var password = ""
    @State private var showRegister = false
    @State private var loginFailed = false

    var body: some View {
        ZStack {
            // ✅ Fullscreen gradient background
            LinearGradient(
                gradient: Gradient(colors: [Color.blue.opacity(0.2), Color.purple.opacity(0.2)]),
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
            .ignoresSafeArea()

            VStack(spacing: 20) {
                // ✅ Logo
                Image("mmlogo")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 150, height: 150)
                    .padding(.top, 50)

                Text("MindMosaic")
                    .font(.largeTitle)
                    .bold()

                // ✅ Login fields
                styledInputField(icon: "person", placeholder: "Username", text: $username, placeholderColor: .white.opacity(0.6))

                styledInputField(icon: "lock", placeholder: "Password", text: $password, isSecure: true, placeholderColor: .white.opacity(0.6))


                if loginFailed {
                    Text("Invalid credentials").foregroundColor(.red)
                }

                // ✅ Buttons
                Button("Login") {
                    loginFailed = !userManager.login(username: username, password: password)
                }
                .buttonStyle(.borderedProminent)
                .padding(.top)

                Button("Register") {
                    showRegister = true
                }
                .sheet(isPresented: $showRegister) {
                    RegisterView()
                }

                Spacer()
            }
            .padding()
        }
    }
}

// MARK: - Reusable input style
/*func styledInputField(icon: String, placeholder: String, text: Binding<String>, isSecure: Bool = false) -> some View {
    HStack {
        Image(systemName: icon)
            .foregroundColor(.gray)
        if isSecure {
            SecureField(placeholder, text: text)
                .autocapitalization(.none)
        } else {
            TextField(placeholder, text: text)
                .autocapitalization(.none)
        }
    }
    .padding()
    .background(
        RoundedRectangle(cornerRadius: 10)
            .fill(Color.black.opacity(0.5))
            .shadow(color: .white.opacity(0.2), radius: 5, x: 0, y: 2)
    )
    .padding(.horizontal)
}*/

@ViewBuilder
func styledInputField(
    icon: String,
    placeholder: String,
    text: Binding<String>,
    isSecure: Bool = false,
    placeholderColor: Color = .gray
) -> some View {
    HStack {
        Image(systemName: icon)
            .foregroundColor(.gray)

        ZStack(alignment: .leading) {
            // Custom placeholder
            if text.wrappedValue.isEmpty {
                Text(placeholder)
                    .foregroundColor(placeholderColor)
                    .padding(.leading, 2)
            }

            if isSecure {
                SecureField("", text: text)
                    .autocapitalization(.none)
                    .foregroundColor(.white)
            } else {
                TextField("", text: text)
                    .autocapitalization(.none)
                    .foregroundColor(.white)
            }
        }
    }
    .padding()
    .background(
        RoundedRectangle(cornerRadius: 12)
            .fill(Color.black.opacity(0.15))
            .shadow(color: .white.opacity(0.1), radius: 5, x: 0, y: 2)
    )
    .padding(.horizontal)
}
