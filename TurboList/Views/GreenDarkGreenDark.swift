import SwiftUI

struct ListsView: View {
    var body: some View {
        VStack {
            HStack {
                Image(systemName: "person.circle.fill")
                    .resizable()
                    .frame(width: 50, height: 50)
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
                }) {
                    Image(systemName: "bell.circle.fill")
                        .resizable()
                        .frame(width: 40, height: 40)
                        .foregroundColor(.green)
                        .padding(.trailing)
                }
            }
            .padding(.top)

            // Search bar
            HStack {
                TextField("Search lists", text: .constant(""))
                    .padding(.all, 12)
                    .background(Color(.systemGray6))
                    .cornerRadius(10)
                    .padding(.horizontal)
            }
            .padding(.vertical)

            Spacer()

            // Plus button and arrow illustration
            VStack {
                // Plus Button
                Button(action: {
                    // Action to create a new list
                }) {
                    Image(systemName: "plus.circle.fill")
                        .resizable()
                        .frame(width: 50, height: 50)
                        .foregroundColor(.green)
                }
                .padding(.bottom, 30)

                // Arrow illustration and text
                Image(systemName: "arrow.up.right.circle.fill")
                    .resizable()
                    .frame(width: 100, height: 100)
                    .foregroundColor(.green)
                    .rotationEffect(.degrees(-45))

                Text("Create first list")
                    .foregroundColor(.green)
                    .font(.title3)
                    .fontWeight(.medium)
            }

            Spacer()
        }
        .background(Color(.systemGray6).opacity(0.1))
    }
}

#Preview {
    ListsView()
}
