import SwiftUI

struct GroceryItem: Identifiable {
    let id = UUID()
    let name: String
    var quantity: Int
}

struct GroceryCategory: Identifiable {
    let id = UUID()
    let name: String
    var items: [GroceryItem]
}

struct ListView: View {
    
    @State private var categories: [GroceryCategory] = [
        GroceryCategory(name: "Fruit 🍎", items: [
            GroceryItem(name: "Apple", quantity: 4),
            GroceryItem(name: "Banana", quantity: 2)
        ]),
        GroceryCategory(name: "Vegetables 🥬 ", items: [
            GroceryItem(name: "Carrot", quantity: 5),
            GroceryItem(name: "Potato", quantity: 3)
        ]),
        GroceryCategory(name: " Drinks 🥤  ", items: [
            GroceryItem(name: "Orange juice", quantity: 3)
        ])
        
    ]
    
    var body: some View {
        ZStack {
            Color("backgroundAppColor")
                .ignoresSafeArea()

            Image("Background")
                .resizable()
                .ignoresSafeArea()
            
            VStack {
                
                
                HStack {
                    Button(action: {
                    }) {
                        ZStack {
                            Circle()
                                .fill(Color("GreenLight"))
                                .frame(width: 40, height: 40)
                            Image(systemName: "chevron.left")
                                .resizable()
                                .frame(width: 7, height: 12)
                                .foregroundColor(Color.green)
                        }
                    }
                    
                    Spacer()

                    Text("My grocery list")
                        .font(.system(size: 22, weight: .bold))
                        .multilineTextAlignment(.center)
                    
                    Spacer()

                    Menu {
                        Button(action: {
                        }) {
                            Label("Edit", systemImage: "pencil")
                        }
                        
                        Button(action: {
                        }) {
                            Label("Share", systemImage: "square.and.arrow.up")
                        }
                        
                        Button(action: {
                        }) {
                            Label("Favorite", systemImage: "heart")
                        }
                        
                        Button(action: {
                        }) {
                            Label("Delete", systemImage: "trash")
                                
                        }
                    } label: {
                        ZStack {
                            Circle()
                                .fill(Color("GreenLight"))
                                .frame(width: 40, height: 40)
                            Image(systemName: "ellipsis")
                                .resizable()
                                .frame(width: 20, height: 4)
                                .foregroundColor(Color.green)
                        }
                    }
                }
                .padding(.horizontal)
                .padding(.top, 10)
                
                HStack {
                    Text("Items 🛒")
                        .font(.title3)
                        .fontWeight(.bold)
                        .foregroundColor(Color("GreenC"))
                        .padding(.leading)
                    Spacer()
                }

                ScrollView {
                    ForEach(categories) { category in
                        VStack(alignment: .leading, spacing: 16) {
                            HStack {
                                Text(category.name)
                                    .font(.system(size: 22, weight: .bold))
                                    .foregroundColor(Color("GreenDark"))
                                Spacer()
                            }
                            .padding(.leading)
                            
                            VStack(spacing: 0) {
                                ForEach(category.items.indices, id: \.self) { index in
                                    HStack {
                                        Circle()
                                            .stroke(Color("MainColor"), lineWidth: 2)
                                            .frame(width: 30, height: 30)
                                            .background(Circle().fill(Color("LightGreen")))

                                        Text(category.items[index].name)
                                            .font(.system(size: 18))
                                            .fontWeight(.medium)

                                        Spacer()

                                        HStack(spacing: 0) {
                                            Button(action: {
                                                if category.items[index].quantity > 0 {
                                                    categories[categories.firstIndex(where: { $0.id == category.id })!]
                                                        .items[index].quantity -= 1
                                                }
                                            }) {
                                                Image(systemName: "minus.circle.fill")
                                                    .foregroundColor(Color("gray1"))
                                                    .font(.system(size: 30))
                                            }
                                            
                                            Text("\(category.items[index].quantity)")
                                                .font(.title3)
                                                .frame(width: 30)
                                            
                                            Button(action: {
                                                categories[categories.firstIndex(where: { $0.id == category.id })!]
                                                    .items[index].quantity += 1
                                            }) {
                                                Image(systemName: "plus.circle.fill")
                                                    .foregroundColor(Color("MainColor"))
                                                    .font(.system(size: 30))
                                            }
                                        }
                                        
                                        
                                        
                                    }
                                    .frame(width: 320, height: 70)
                                    .padding(.vertical, 10)
                                    .padding(.horizontal)
                                    .background(Color("bakgroundTap"))
                                    
                                    if index != category.items.count - 1 {
                                        Divider()
                                            .padding(.horizontal)
                                    }
                                }
                            }
                            .background(Color("bakgroundTap"))
                            .cornerRadius(15)
                            .shadow(radius: 1)
                            .padding(.horizontal)
                        }
                        .padding(.top)
                    }
                }

                Spacer()
            }
        }
    }
}

#Preview {
    ListView()
}
