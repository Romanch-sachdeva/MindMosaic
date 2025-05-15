import SwiftUI

//rego view other than login
struct RegisterView: View {
    @EnvironmentObject var userManager: UserManager
    @Environment(\.dismiss) var dismiss

    @State private var username = ""
    @State private var password = ""
    @State private var error = ""

    var body: some View {
        ZStack {
            LinearGradient(
                gradient: Gradient(colors: [Color.white, Color.cyan.opacity(0.3)]),
                startPoint: .top,
                endPoint: .bottom
            )
            .ignoresSafeArea()

            VStack(spacing: 25) {
                Spacer().frame(height: 20)

                Image(systemName: "person.crop.circle.badge.plus")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 100, height: 100)
                    .foregroundColor(.cyan.opacity(0.7))

                Text("Create Your Account")
                    .font(.title2)
                    .fontWeight(.semibold)
                    .multilineTextAlignment(.center)
                    .foregroundColor(.black)

                //get user and pass
                styledInputField(icon: "person.fill", placeholder: "Username", text: $username)
                styledInputField(icon: "lock.fill", placeholder: "Password", text: $password, isSecure: true)

                if !error.isEmpty {
                    Text(error)
                        .foregroundColor(.red)
                        .font(.caption)
                        .multilineTextAlignment(.center)
                        .padding(.horizontal)
                }

                Button(action: {
                    if !isPasswordStrong(password) {
                        error = "Password must be 8+ chars with uppercase, lowercase, and number."
                    } else if userManager.register(username: username, password: password) {
                        dismiss()
                    } else {
                        error = "Username already exists"
                    }
                }) {
                    Text("Create Account")
                        .fontWeight(.semibold)
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.black)
                        .foregroundColor(.white)
                        .cornerRadius(25)
                }

                Spacer()
            }
            .padding()
        }
    }
}

//password regex
func isPasswordStrong(_ password: String) -> Bool {
    let regex = "^(?=.*[a-z])(?=.*[A-Z])(?=.*\\d).{8,}$"
    return NSPredicate(format: "SELF MATCHES %@", regex).evaluate(with: password)
}
