import SwiftUI

struct FavouriteView: View {
    @State private var isBellTapped = false

    var body: some View {

        ZStack {
            Color("backgroundAppColor")
                .ignoresSafeArea()

            Image("Background")
                .resizable()
                .ignoresSafeArea()
            
            VStack {
                
                HStack {
                    ZStack {
                        Circle()
                            .stroke(Color("buttonColor"), lineWidth: 2)
                            .frame(width: 50, height: 50)

                        Image(systemName: "person")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 25, height: 25)
                            .foregroundColor(Color("GreenDark"))
                    }
                    .padding(.leading)

                    VStack(alignment: .leading) {
                        Text("Welcome")
                            .font(.subheadline)
                            .foregroundColor(Color("buttonColor"))
                        Text("Ahad!")
                            .font(.title2)
                            .foregroundColor(Color("GreenDark"))
                            .fontWeight(.bold)
                    }
                    Spacer()
                    
                    Button(action: {
                        isBellTapped.toggle()
                    }) {
                        ZStack {
                            Circle()
                                .fill(isBellTapped ? Color("MainColor") : Color("GreenLight"))
                                .frame(width: 40, height: 40)
                            
                            Image(systemName: "bell")
                                .resizable()
                                .frame(width: 18, height: 22)
                                .foregroundColor(isBellTapped ? .white : Color("MainColor"))
                        }
                    }
                    .padding(.trailing)
                }
                .padding(.top)
                
                Spacer()
            }
            
        }
        
    }
}

#Preview {
    FavouriteView()
}
