//
//  test.swift
//  Sammy
//
//  Created by Khanh Nguyen on 5/7/25.
//

import SwiftUI

struct RoundedCorner: Shape {
	 var radius: CGFloat = 0
	 var corners: UIRectCorner = .allCorners

	 func path(in rect: CGRect) -> Path {
			let path = UIBezierPath(
				 roundedRect: rect,
				 byRoundingCorners: corners,
				 cornerRadii: CGSize(width: radius, height: radius)
			)
			return Path(path.cgPath)
	 }
}

struct ContentView: View {
	 var body: some View {
			HStack(spacing: 0) {
				 Text("Hello, World!")
						.frame(maxWidth: .infinity)
						.padding()
						.background(Color.black.opacity(0.1))
						.clipShape(RoundedCorner(radius: 10, corners: [.topLeft, .bottomLeft]))

				 Text("Hello, World!")
						.frame(maxWidth: .infinity)
						.padding()
						.background(Color.blue)
						.clipShape(RoundedCorner(radius: 10, corners: [.topRight, .bottomRight]))

			}
			.padding(.horizontal, 30)
	 }
}

struct ContentView_Previews: PreviewProvider {
	 static var previews: some View {
			ContentView()
	 }
}
