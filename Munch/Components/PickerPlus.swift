import SwiftUI

struct PickerPlus: View {
    @Binding var selection: String
    let segments: [String]

    @State private var font: Font = .system(size: 14, weight: .regular)
    @State private var selectedFont: Font = .system(size: 14, weight: .bold)

    private var selectedIndex: Int {
        segments.firstIndex(of: selection) ?? 0
    }

    var body: some View {
        GeometryReader { geometry in
            let segmentWidth = geometry.size.width / CGFloat(segments.count)
            let segmentHeight = geometry.size.height

            ZStack(alignment: .leading) {
                RoundedRectangle(cornerRadius: 8)
                    .fill(Color.white)
                    .frame(width: segmentWidth - 10, height: segmentHeight - 10)
                    .offset(x: CGFloat(selectedIndex) * segmentWidth + 5)
                    .animation(.easeInOut(duration: 0.3), value: selectedIndex)
                
                HStack(spacing: 0) {
                    ForEach(0..<segments.count, id: \.self) { index in
                        Text(segments[index])
                            .font(selectedIndex == index ? selectedFont : font)
                            .frame(width: segmentWidth, height: segmentHeight)
                            .onTapGesture {
                                withAnimation {
                                    selection = segments[index]
                                }
                            }
                    }
                }
            }
            .frame(height: segmentHeight)
            .background(Color.gray.opacity(0.2))
            .cornerRadius(8)
        }
        .padding()
    }

    func font(_ font: Font) -> Self {
        var view = self
        view._font = State(initialValue: font)
        return view
    }

    func selectedFont(_ selectedFont: Font) -> Self {
        var view = self
        view._selectedFont = State(initialValue: selectedFont)
        return view
    }
}

struct PickerPlusPreview: View {
    @State private var selection = "Option 2"
    
    var body: some View {
        VStack {
            PickerPlus(
                selection: $selection,
                segments: ["Option 1", "Option 2", "Option 3"]
            )
            .font(.system(size: 16, weight: .regular))
            .selectedFont(.system(size: 18, weight: .bold))
            .frame(height: 80)  // Adjust height as needed
            .padding()
            
            Text("Selected segment: \(selection)")
                .padding()
        }
    }
}

struct ResizableSegmentedPicker_Previews: PreviewProvider {
    static var previews: some View {
        PickerPlusPreview()
    }
}
