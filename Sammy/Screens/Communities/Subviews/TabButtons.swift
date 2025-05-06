import SwiftUI

// MARK: - CommunityButtons

struct CommunityButtonStyle: ButtonStyle {
	 var isSelected: Bool

	 func makeBody(configuration: Configuration) -> some View {
			configuration.label
				 .foregroundColor(isSelected ? .purple : .gray)
				 .bold(isSelected)
				 .overlay(
						Rectangle()
							 .frame(height: 2)
							 .foregroundColor(isSelected ? .purple : .clear)
							 .offset(y: 20)
							 .animation(.easeInOut(duration: 0.3), value: isSelected),
						alignment: .bottom
				 )
	 }
}


// MARK: - TabOptions
enum CommunityFilteringTabs {
    case myCommunities
    case discover
}
