import SwiftUI

struct ReusableTabs: View {
	 let tabs: [String]
	 @Binding var selectedTab: String

	 var body: some View {
			HStack(spacing: 0) {
				 ForEach(tabs, id: \.self) { tab in
						Text(tab)
							 .frame(maxWidth: .infinity)
							 .overlay(
									Rectangle()
										 .frame(height: 2)
										 .foregroundColor(selectedTab == tab ? .purple : .clear)
										 .offset(y: 20)
										 .animation(.easeInOut(duration: 0.3), value: selectedTab),
									alignment: .bottom
							 )
							 .onTapGesture {
									withAnimation(.easeInOut(duration: 0.4)) {
										 selectedTab = tab
									}
							 }
				 }
			}
			.padding(.vertical, 10)
	 }
}

#Preview {
	 @Previewable @State var selectedTab = ["Posts", "Comments", "Saved"][0]
	 ReusableTabs(tabs: ["Posts", "Comments", "Saved"], selectedTab: $selectedTab)
}
