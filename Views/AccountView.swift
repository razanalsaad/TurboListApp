import SwiftUI
import CloudKit
import Combine
import PhotosUI
import AuthenticationServices

class CloudKitUserBootcampViewModel: ObservableObject {
    @EnvironmentObject var userSession: UserSession
    @Published var permissionStatus: Bool = false
    @Published var isSignedInToiCloud: Bool = false
    @Published var error: String = ""
    @Published var userName: String = ""
    @Published var profileImage: UIImage? = nil
    @Published var isLoggedIn: Bool = true // Managing login state here
    
    let container = CKContainer.default()
    var cancellables = Set<AnyCancellable>()
    
    init() {
        getiCloudStatus()
        requestPermission()
        getCurrentUserName()
    }
    
    private func getiCloudStatus() {
        CloudKitUtility.getiCloudStatus()
            .receive(on: DispatchQueue.main)
            .sink { [weak self] completion in
                switch completion {
                case .finished:
                    break
                case .failure(let error):
                    self?.error = error.localizedDescription
                }
            } receiveValue: { [weak self] success in
                self?.isSignedInToiCloud = success
            }
            .store(in: &cancellables)
    }
    
    func requestPermission() {
        CloudKitUtility.requestApplicationPermission()
            .receive(on: DispatchQueue.main)
            .sink { _ in } receiveValue: { [weak self] success in
                self?.permissionStatus = success
            }
            .store(in: &cancellables)
    }
    
    func getCurrentUserName() {
        CloudKitUtility.discoverUserIdentity()
            .receive(on: DispatchQueue.main)
            .sink { _ in } receiveValue: { [weak self] returnedName in
                self?.userName = returnedName
            }
            .store(in: &cancellables)
    }
    
    func fetchUserProfileImage() {
        container.fetchUserRecordID { [weak self] recordID, error in
            guard let recordID = recordID, error == nil else {
                print("Error fetching user record ID: \(error?.localizedDescription ?? "Unknown error")")
                return
            }
            
            let predicate = NSPredicate(format: "user_id == %@", recordID)
            let query = CKQuery(recordType: "User", predicate: predicate)
            let queryOperation = CKQueryOperation(query: query)
            
            queryOperation.recordFetchedBlock = { record in
                DispatchQueue.main.async {
                    if let imageAsset = record["profileImage"] as? CKAsset, let fileURL = imageAsset.fileURL {
                        if let data = try? Data(contentsOf: fileURL), let image = UIImage(data: data) {
                            self?.profileImage = image
                        } else {
                            print("Failed to load image data")
                        }
                    } else {
                        print("No profile image found")
                    }
                }
            }
            
            self?.container.publicCloudDatabase.add(queryOperation)
        }
    }
    
    func logoutUser() {
        print("Logging out...")
        userName = ""
        profileImage = nil
        isLoggedIn = false
    }
}

struct AccountView: View {
    @Environment(\.colorScheme) var colorScheme
    @State private var isDarkMode: Bool = false
    @StateObject private var vm = CloudKitUserBootcampViewModel()
    @State private var selectedImage: UIImage?
    @State private var isPickerPresented = false
    
    var body: some View {
        Group {
            if vm.isLoggedIn {
                ZStack {
                    Color("backgroundAppColor")
                        .ignoresSafeArea()

                    Image("Background")
                        .resizable()
                        .ignoresSafeArea()
                    
                    VStack {
                        VStack(spacing: 8) {
                            ZStack {
                                Circle()
                                    .stroke(Color("GreenLight"), lineWidth: 8)
                                    .frame(width: 120, height: 120)
                                    .onTapGesture {
                                        isPickerPresented = true
                                    }
                                
                                if let selectedImage = selectedImage {
                                    Image(uiImage: selectedImage)
                                        .resizable()
                                        .scaledToFill()
                                        .frame(width: 100, height: 100)
                                        .clipShape(Circle())
                                } else {
                                    Image(systemName: "person.fill")
                                        .resizable()
                                        .scaledToFit()
                                        .frame(width: 60, height: 60)
                                        .foregroundColor(Color("buttonColor"))
                                }
                            }
                            .sheet(isPresented: $isPickerPresented) {
                                ImagePicker(selectedImage: $selectedImage)
                            }
        
                            TextField("Username", text: $vm.userName)
                                .font(.largeTitle)
                                .fontWeight(.bold)
                                .foregroundColor(Color("GreenDark"))
                                .multilineTextAlignment(.center)
                              
                            Text("@\(vm.userName)")
                                .foregroundColor(Color.gray)
                                .font(.subheadline)
                        }
                        .padding(.top, 40)
                        
                        Spacer().frame(height: 40)
                        
                        VStack(spacing: 0) {
                                                 SettingRow(icon: "globe", title: NSLocalizedString("Language", comment: ""), iconColor: Color("MainColor"), textColor: Color("GreenDark")) {
                                                     openAppSettings()
                                                 }
                                                 Divider()
                                                 
                                                 SettingRow(icon: "bell", title: NSLocalizedString("Notification", comment: ""), iconColor: Color("MainColor"), textColor: Color("GreenDark")) {
                                                     print("Notification tapped")
                                                 }
                                                 Divider()
                                                 
                                                 SettingRow(icon: colorScheme == .dark ? "sun.max" : "moon",
                                                            title: colorScheme == .dark ? NSLocalizedString("Light Mode", comment: "") : NSLocalizedString("Dark Mode", comment: ""),
                                                            iconColor: Color("MainColor"), textColor: Color("GreenDark")) {
                                                     isDarkMode.toggle()
                                                     UIApplication.shared.windows.first?.overrideUserInterfaceStyle = isDarkMode ? .dark : .light
                                                 }
                                                 Divider()
                             
                                                 SettingRow(icon: "rectangle.portrait.and.arrow.right", title: NSLocalizedString("Log out", comment: ""), iconColor: Color("red22"), textColor: Color("red22")) {
                                                     vm.logoutUser()
                                                     
                                                 }
                                             }
                        
                        Spacer()
                    }
                }
                .onAppear {
                    vm.fetchUserProfileImage()
                }
            } else {
                loggedOutView
            }
        }
    }
    var loggedOutView: some View {
        
        ZStack {
            Color("backgroundAppColor")
                .ignoresSafeArea()
            
            Image("Background")
                .resizable()
                .ignoresSafeArea()
            
            VStack(spacing: 8) {
                
                
                ZStack {
                    Circle()
                        .stroke(Color("GreenLight"), lineWidth: 4)
                        .frame(width: 120, height: 120)
                    
                    Image(systemName: "person.fill.questionmark")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 70, height: 70)
                        .foregroundColor(Color("buttonColor"))
                }
                .padding(.top, 40)
                
                Text("You do not have an account yet")
                    .font(.system(size: 18))
                    .fontWeight(.bold)
                    .foregroundColor(Color("GreenDark"))
                    .padding(.top, 20)
                
                Text("Create new account now")
                    .foregroundColor(Color("buttonColor"))
                    .fontWeight(.bold)
                    .font(.subheadline)
                    .padding(.top, 20)
                
                SignInWithAppleButton(
                    onRequest: { request in
                        request.requestedScopes = [.fullName, .email]
                    },
                    onCompletion: { result in
                        switch result {
                        case .success(let authorization):
                            handleAuthorization(authorization)
                        case .failure(let error):
                            print("Sign in with Apple failed: \(error.localizedDescription)")
                        }
                    }
                )
                .frame(width: 342, height: 54)
                .cornerRadius(14)
                .padding(.top, 20)
                .signInWithAppleButtonStyle(colorScheme == .dark ? .white : .black)
                .accessibilityLabel("Sign in with Apple")
                .accessibilityHint("Use your Apple ID to sign in")
            }.padding(.bottom,250)
        }}
    
    
    func handleAuthorization(_ authorization: ASAuthorization) {
        if let appleIDCredential = authorization.credential as? ASAuthorizationAppleIDCredential {
            let userIdentifier = appleIDCredential.user
            let fullName = appleIDCredential.fullName
            let email = appleIDCredential.email
            
            print("User ID: \(userIdentifier)")
            if let name = fullName {
                print("User Name: \(name.givenName ?? "") \(name.familyName ?? "")")
            }
            if let email = email {
                print("User Email: \(email)")
            }
            
            vm.isLoggedIn = true
        }
    }

    func openAppSettings() {
        if let appSettings = URL(string: UIApplication.openSettingsURLString) {
            if UIApplication.shared.canOpenURL(appSettings) {
                UIApplication.shared.open(appSettings, options: [:], completionHandler: nil)
            }
        }
    }
}

struct SettingRow: View {
    var icon: String
    var title: String
    var iconColor: Color = .black
    var textColor: Color = .black
    var action: () -> Void
    
    var body: some View {
        HStack {
            Image(systemName: icon)
                .foregroundColor(iconColor)
                .frame(width: 24, height: 24)

            Text(title)
                .foregroundColor(textColor)
                .fontWeight(.medium)
            
            Spacer()
        }
        .padding()
        .onTapGesture {
            action()
        }
    }
}

struct ImagePicker: UIViewControllerRepresentable {
    @Binding var selectedImage: UIImage?

    func makeUIViewController(context: Context) -> PHPickerViewController {
        var config = PHPickerConfiguration()
        config.filter = .images
        let picker = PHPickerViewController(configuration: config)
        picker.delegate = context.coordinator
        return picker
    }

    func updateUIViewController(_ uiViewController: PHPickerViewController, context: Context) {}

    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }

    class Coordinator: NSObject, PHPickerViewControllerDelegate {
        let parent: ImagePicker

        init(_ parent: ImagePicker) {
            self.parent = parent
        }

        func picker(_ picker: PHPickerViewController, didFinishPicking results: [PHPickerResult]) {
            picker.dismiss(animated: true)
            
            if let provider = results.first?.itemProvider, provider.canLoadObject(ofClass: UIImage.self) {
                provider.loadObject(ofClass: UIImage.self) { image, _ in
                    DispatchQueue.main.async {
                        self.parent.selectedImage = image as? UIImage
                    }
                }
            }
        }
    }
}
#Preview {
    AccountView()
}
