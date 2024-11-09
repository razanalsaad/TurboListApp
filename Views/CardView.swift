import SwiftUI

//struct CollaborativeGroceryListView: View {
//    @State private var isHeartSelected: Bool = false
//    var body: some View {
//        VStack(spacing: 16) {
//            VStack(alignment: .leading, spacing: 8) {
//                Text("Collaborative list")
//                    .font(.system(size: 20, weight: .bold))
//                    .foregroundColor(.white)
//                    .frame(width: 200, alignment: .leading)
//                
//                HStack {
//                    Image(systemName: "person.2.circle")
//                        .foregroundColor(Color("Color44"))
//                        .font(.system(size: 30))
//                    
//                    Button(action: {
//                        isHeartSelected.toggle()
//                    }) {
//                        ZStack {
//                            if isHeartSelected {
//                                Circle()
//                                    .fill(Color.white)
//                                    .frame(width: 30, height: 30)
//                                
//                                Image(systemName: "heart.fill")
//                                    .foregroundColor(.red)
//                                    .font(.system(size: 17))
//                            } else {
//                                Image(systemName: "heart.circle.fill")
//                                    .foregroundColor(.white)
//                                    .font(.system(size: 30))
//                            }
//                        }
//                        .frame(width: 30, height: 30)
//                    }
//                }
//            }
//            .offset(x: -40)
//            .frame(width: 350, height: 100)
//            .background(
//                LinearGradient(
//                    gradient: Gradient(stops: [
//                        .init(color: Color(hex: "051937"), location: 0.0),
//                        .init(color: Color(hex: "004D7A"), location: 0.25),
//                        .init(color: Color(hex: "008793"), location: 0.70),
//                        .init(color: Color(hex: "00BF72"), location: 1.3)
//                    ]),
//                    startPoint: .leading,
//                    endPoint: .trailing
//                )
//            )
//            .cornerRadius(20)
//            .shadow(radius: 5)
//        }
//    }
//}

struct GroceryListView: View {
//    @State private var isHeartSelected: Bool = false
//
    var listName: String  // Accept the list name as a parameter
        @Binding var isHeartSelected: Bool  // Binding for heart icon selection
        var onCardTapped: () -> Void  // Action when the card is tapped
    var body: some View {
        VStack(spacing: 16) {
            VStack(alignment: .leading, spacing: 8) {
                Text(listName)  // Display the actual list name
                    .font(.system(size: 20, weight: .bold))
                    .foregroundColor(.white)
                    .frame(width: 200, alignment: .leading)
                
                HStack {
                    Image(systemName: "person.circle.fill")
                        .foregroundColor(.white)
                        .font(.system(size: 30))
                    
                    Button(action: {
                        isHeartSelected.toggle()
                    }) {
                        ZStack {
                            if isHeartSelected {
                                Circle()
                                    .fill(Color.white)
                                    .frame(width: 30, height: 30)
                                
                                Image(systemName: "heart.fill")
                                    .foregroundColor(.red)
                                    .font(.system(size: 17))
                            } else {
                                Image(systemName: "heart.circle.fill")
                                    .foregroundColor(.white)
                                    .font(.system(size: 30))
                            }
                        }
                        .frame(width: 30, height: 30)
                    }
                }
            }
            .offset(x: -40)
            .frame(width: 350, height: 100)
            .background(
                LinearGradient(
                    gradient: Gradient(stops: [
                        .init(color: Color(hex: "053716"), location: 0.0),
                        .init(color: Color(hex: "007A59"), location: 0.25),
                        .init(color: Color(hex: "009387"), location: 0.70),
                        .init(color: Color(hex: "00BF72"), location: 1.3)
                    ]),
                    startPoint: .leading,
                    endPoint: .trailing
                )
            )
            .cornerRadius(20)
            .shadow(radius: 5)
        }
    }
}

extension Color {
    init(hex: String) {
        let hex = hex.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
        var int: UInt64 = 0
        Scanner(string: hex).scanHexInt64(&int)
        let r, g, b: UInt64
        switch hex.count {
        case 6: // RGB (24-bit)
            (r, g, b) = ((int >> 16) & 0xFF, (int >> 8) & 0xFF, int & 0xFF)
            self.init(
                red: Double(r) / 255,
                green: Double(g) / 255,
                blue: Double(b) / 255
            )
        default:
            self.init(red: 0, green: 0, blue: 0, opacity: 1)
        }
    }
}

#Preview {
    @State var isHeartSelectedPreview = false  // Create a state variable for preview

    return VStack {
        GroceryListView(
            listName: "Sample List 1",
            isHeartSelected: $isHeartSelectedPreview,
            onCardTapped: { print("Tapped on Sample List 1") }
        )
        
        GroceryListView(
            listName: "Sample List 2",
            isHeartSelected: $isHeartSelectedPreview,
            onCardTapped: { print("Tapped on Sample List 2") }
        )
    }
}
