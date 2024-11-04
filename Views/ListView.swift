import SwiftUI

struct ListView: View {
    
    @ObservedObject private var viewModel: ListViewModel
    
    init(categories: [GroceryCategory]) {
        self.viewModel = ListViewModel(categories: categories)
    }
    
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
                        Button(action: {}) { Label("Edit", systemImage: "pencil") }
                        Button(action: {}) { Label("Share", systemImage: "square.and.arrow.up") }
                        Button(action: {}) { Label("Favorite", systemImage: "heart") }
                        Button(action: {}) { Label("Delete", systemImage: "trash") }
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
                    ForEach(viewModel.categories.indices, id: \.self) { categoryIndex in
                        let category = viewModel.categories[categoryIndex]
                        VStack(alignment: .leading, spacing: 16) {
                            HStack {
                                Text(viewModel.formattedCategoryName(category.name))
                                    .font(.system(size: 22, weight: .bold))
                                    .foregroundColor(Color("GreenDark"))
                                Spacer()
                            }
                            .padding(.leading)
                            
                            VStack(spacing: 0) {
                                ForEach(category.items.indices, id: \.self) { itemIndex in
                                    let item = category.items[itemIndex]
                                    
                                    HStack {
                                        Circle()
                                            .stroke(Color("MainColor"), lineWidth: 2)
                                            .frame(width: 30, height: 30)
                                            .background(Circle().fill(Color("LightGreen")))

                                        Text(item.name)
                                            .font(.system(size: 18))
                                            .fontWeight(.medium)

                                        Spacer()

                                        HStack(spacing: 0) {
                                            Button(action: {
                                                viewModel.decreaseQuantity(for: categoryIndex, itemIndex: itemIndex)
                                            }) {
                                                Image(systemName: "minus.circle.fill")
                                                    .foregroundColor(Color("gray1"))
                                                    .font(.system(size: 30))
                                            }
                                            
                                            Text("\(category.items[itemIndex].quantity)")
                                                .font(.title3)
                                                .frame(width: 30)
                                            
                                            Button(action: {
                                                viewModel.increaseQuantity(for: categoryIndex, itemIndex: itemIndex)
                                            }) {
                                                Image(systemName: "plus.circle.fill")
                                                    .foregroundColor(Color("MainColor"))
                                                    .font(.system(size: 30))
                                            }
                                        }
                                        
                                    }
                                    .frame(width: 350, height: 70)
                                    .padding(.vertical, 10)
                                    .padding(.horizontal)
                                    .background(Color("bakgroundTap"))
                                    
                                    if itemIndex != category.items.count - 1 {
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
        .navigationBarBackButtonHidden(true)
    }
}

struct ListView_Previews: PreviewProvider {
    static var previews: some View {
        ListView(categories: [
            GroceryCategory(name: "bakery", items: [
                GroceryItem(name: "Bread", quantity: 2),
                GroceryItem(name: "Croissant", quantity: 5)
            ]),
            GroceryCategory(name: "fruits & vegetables", items: [
                GroceryItem(name: "Apple", quantity: 4),
                GroceryItem(name: "Banana", quantity: 3)
            ])
        ])
    }
}
