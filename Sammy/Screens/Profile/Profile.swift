import SwiftUI

struct ProfileView: View {
	 var tabNames: [String] = ["Posts", "Comments", "Saved"]
	 @State private var selectedTab = "Posts"
	 var body: some View {
			VStack(alignment: .leading, spacing: .paddingExtraLarge) {
				 HStack(spacing: 0) {
						Text("Edit Profile")
							 .padding()
							 .frame(maxWidth: .infinity)

						Text("Share Profile")
							 .padding()
							 .frame(maxWidth: .infinity)
				 }
			

				 HStack {
						ForEach(tabNames, id: \.self) { tab in
							 VStack {
									Text(tab)
										 .foregroundColor(selectedTab == tab ? .purple : .gray)
										 .fontWeight(selectedTab == tab ? .semibold : .regular)
									Rectangle()
										 .fill(selectedTab == tab ? Color.purple : Color.clear)
										 .frame(height: 2)
							 }
							 .onTapGesture {
									withAnimation {
										 selectedTab = tab
									}
							 }
						}
				 }
				 .padding(.top)
				 .overlay(
						Rectangle()
							 .frame(height: 1)
							 .foregroundColor(Color.gray.opacity(0.3)),
						alignment: .bottom
				 )
				 .overlay(
						Rectangle()
							 .frame(height: 1)
							 .foregroundColor(Color.gray.opacity(0.3)),
						alignment: .top
				 )

				 VStack(alignment: .leading, spacing: .paddingExtraLarge) {
						ForEach(menuItems){ item in
							 HStack(spacing: .paddingMedium) {
									Image(systemName: item.icon)
										 .font(.system(size: 20))
									Text(item.title)
										 .foregroundStyle(.black.opacity(0.7))
										 .fontWeight(.medium)
							 }
							 Divider()
						}
				 }
				 .padding(.horizontal)

				 VStack() {
						Text(
							 "Lenny IOS Client v1.00")
						.foregroundStyle(.gray)
						.font(.footnote)
						.multilineTextAlignment(.center)
						.frame(maxWidth: .infinity)
				 }
				 Text(
						"© 2023 Lenny")
				 .foregroundStyle(.gray)
				 .font(.footnote)
				 .multilineTextAlignment(.center)
				 .frame(maxWidth: .infinity)
				 .padding(.top, -20)
			}
	 }
}

#Preview {
	 ProfileView()
}
