import SwiftUI

struct PresetView: View {
    @State private var selectedCategory: String = "#Morning"
    @State private var showSelectedTitle: Bool = false  // Flag to show/hide selected title
    @Environment(\.dismiss) var dismiss
    @StateObject var viewModel = NewItemViewViewModel()
    @StateObject var presetViewModel = PresetViewModel()
   
    var body: some View {
        VStack(alignment: .leading) {
            // Header
            Text("Habit List")
                .font(.headline)
                .foregroundColor(.brown)
                .padding([.leading, .top])

            // Category Tabs
            HStack {
                ForEach(presetViewModel.categories.keys.sorted(), id: \.self) { category in
                    Button(action: {
                        selectedCategory = category
                    }) {
                        Text(category)
                            .font(.subheadline)
                            .padding(.horizontal)
                            .padding(.vertical, 6)
                            .background(selectedCategory == category ? Color.brown.opacity(0.2) : Color.clear)
                            .cornerRadius(8)
                    }
                }
            }
            .padding(.horizontal)

            // List of items
            List {
                if let items = presetViewModel.categories[selectedCategory] {
                    ForEach(items) { item in
                        HStack {
                            VStack(alignment: .leading) {
                                Text(item.name)
                                    .font(.headline)
                                Text(item.description)
                                    .font(.subheadline)
                                    .foregroundColor(.gray)
                            }
                            Spacer()
                            Button(action: {
                                // Play the click sound
                                AudioHandler.shared.playSound(named: "click", withExtension: "wav")
                                
                                viewModel.setTitle(item.name) // Now set the title using setTitle method
                                dismiss() // Dismiss the PresetView
                            }) {
                                Image(systemName: "plus.circle")
                                    .font(.title2)
                                    .foregroundColor(.pink)
                            }

                        }
                        .padding(.vertical, 4)
                    }
                }
            }
            .listStyle(PlainListStyle())
        }
        .padding()
    }
}

#Preview {
    PresetView()
}
