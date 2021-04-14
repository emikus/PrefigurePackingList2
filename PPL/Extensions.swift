//
//  Extensions.swift
//  PPL
//
//  Created by Macbook Pro on 11/10/2020.
//

import Foundation
import SwiftUI


extension StringProtocol { // for Swift 4 you need to add the constrain `where Index == String.Index`
    var byWords: [SubSequence] {
        var byWords: [SubSequence] = []
        enumerateSubstrings(in: startIndex..., options: .byWords) { _, range, _, _ in
            byWords.append(self[range])
        }
        return byWords
    }
}

extension String
{
    func replacingLastOccurrenceOfString(_ searchString: String,
            with replacementString: String,
            caseInsensitive: Bool = true) -> String
    {
        let options: String.CompareOptions
        if caseInsensitive {
            options = [.backwards, .caseInsensitive]
        } else {
            options = [.backwards]
        }

        if let range = self.range(of: searchString,
                options: options,
                range: nil,
                locale: nil) {

            return self.replacingCharacters(in: range, with: replacementString)
        }
        return self
    }
}

extension View {

      func flipRotate(_ degrees : Double) -> some View {
            return rotation3DEffect(Angle(degrees: degrees), axis: (x: 0.0, y: 1.0, z: 0.0))
      }

}

extension String {
    func capitalizingFirstLetter() -> String {
        return prefix(1).capitalized + dropFirst()
    }

    mutating func capitalizeFirstLetter() {
        self = self.capitalizingFirstLetter()
    }
}


struct TagCloudView: View {
    @Binding var itemTagsString: String
    @Environment(\.managedObjectContext) private var viewContext
    @FetchRequest(
        sortDescriptors: [NSSortDescriptor(keyPath: \Tag.name, ascending: true)],
        animation: .default)
    private var tags: FetchedResults<Tag>
    

    @State private var totalHeight
//          = CGFloat.zero       // << variant for ScrollView/List
        = CGFloat.infinity   // << variant for VStack

    var body: some View {
        VStack {
            GeometryReader { geometry in
                self.generateContent(in: geometry)
            }
        }
        .frame(height: totalHeight)// << variant for ScrollView/List
        //.frame(maxHeight: totalHeight) // << variant for VStack
    }

    private func generateContent(in g: GeometryProxy) -> some View {
        var width = CGFloat.zero
        var height = CGFloat.zero

        return ZStack(alignment: .topLeading) {
            ForEach(self.tags, id: \.self) { tag in
                self.item(for: tag)
                    .padding([.horizontal, .vertical], 4)
                    .alignmentGuide(.leading, computeValue: { d in
                        if (abs(width - d.width) > g.size.width)
                        {
                            width = 0
                            height -= d.height
                        }
                        let result = width
                        if tag == self.tags.last! {
                            width = 0 //last item
                        } else {
                            width -= d.width
                        }
                        return result
                    })
                    .alignmentGuide(.top, computeValue: {d in
                        let result = height
                        if tag == self.tags.last! {
                            height = 0 // last item
                        }
                        return result
                    })
            }
        }
        
//        .frame(height: 10)
//        .border(Color.red, width: /*@START_MENU_TOKEN@*/1/*@END_MENU_TOKEN@*/)
        .background(viewHeightReader($totalHeight))
    }

    private func item(for tag: Tag) -> some View {
        HStack {
            Text(tag.wrappedName)

            Image(systemName: ("xmark"))
            .foregroundColor(themes[0].themeColours.buttonMainColour)
            .padding(.trailing, 5)
            .onTapGesture {
                print(tag.wrappedName)
                viewContext.delete(tag)
                do {
                    print("udało się!!!!")
                    try viewContext.save()
                    itemTagsString = itemTagsString.replacingOccurrences(of: tag.wrappedName, with: "")
                } catch {
                    print("ni udało się!!!!")
                }
            }
        }
        .padding(.all, 5)
        .font(.body)
        .background(themes[0].themeColours.fontSecondaryColour)
        .foregroundColor(themes[0].themeColours.bgMainColour)
        .cornerRadius(5)
        
    }

    private func viewHeightReader(_ binding: Binding<CGFloat>) -> some View {
        return GeometryReader { geometry -> Color in
            let rect = geometry.frame(in: .local)
            DispatchQueue.main.async {
                binding.wrappedValue = rect.size.height
            }
            return .clear
        }
    }
}









extension View {

    public func popup<PopupContent: View>(
        isPresented: Binding<Bool>,
        type: Popup<PopupContent>.PopupType = .`default`,
        position: Popup<PopupContent>.Position = .bottom,
        animation: Animation = Animation.easeOut(duration: 0.3),
        autohideIn: Double? = nil,
        closeOnTap: Bool = true,
        closeOnTapOutside: Bool = false,
        view: @escaping () -> PopupContent) -> some View {
        self.modifier(
            Popup(
                isPresented: isPresented,
                type: type,
                position: position,
                animation: animation,
                autohideIn: autohideIn,
                closeOnTap: closeOnTap,
                closeOnTapOutside: closeOnTapOutside,
                view: view)
        )
    }

    func applyIf<T: View>(_ condition: @autoclosure () -> Bool, apply: (Self) -> T) -> AnyView {
        if condition() {
            return AnyView(apply(self))
        } else {
            return AnyView(self)
        }
    }
}

public struct Popup<PopupContent>: ViewModifier where PopupContent: View {

    public enum PopupType {

        case `default`
        case toast
        case floater(verticalPadding: CGFloat = 50)

        func shouldBeCentered() -> Bool {
            switch self {
            case .`default`:
                return true
            default:
                return false
            }
        }
    }

    public enum Position {

        case top
        case bottom
    }

    // MARK: - Public Properties

    /// Tells if the sheet should be presented or not
    @Binding var isPresented: Bool

    var type: PopupType
    var position: Position

    var animation: Animation

    /// If nil - niver hides on its own
    var autohideIn: Double?

    /// Should close on tap - default is `true`
    var closeOnTap: Bool

    /// Should close on tap outside - default is `true`
    var closeOnTapOutside: Bool

    var view: () -> PopupContent

    /// holder for autohiding dispatch work (to be able to cancel it when needed)
    var dispatchWorkHolder = DispatchWorkHolder()

    // MARK: - Private Properties

    /// The rect of the hosting controller
    @State private var presenterContentRect: CGRect = .zero

    /// The rect of popup content
    @State private var sheetContentRect: CGRect = .zero

    /// The offset when the popup is displayed
    private var displayedOffset: CGFloat {
        switch type {
        case .`default`:
            return  -presenterContentRect.midY + screenHeight/2
        case .toast:
            if position == .bottom {
                return CGFloat(200)
            } else {
                return -presenterContentRect.midY + sheetContentRect.height/2
            }
        case .floater(let verticalPadding):
            if position == .bottom {
                return CGFloat(200)
            } else {
                return -presenterContentRect.midY + sheetContentRect.height/2 + verticalPadding
            }
        }
    }

    /// The offset when the popup is hidden
    private var hiddenOffset: CGFloat {
        if position == .top {
            if presenterContentRect.isEmpty {
                return -1000
            }
            return -presenterContentRect.midY - sheetContentRect.height/2 - 5
        } else {
            if presenterContentRect.isEmpty {
                return 1000
            }
            return screenHeight - presenterContentRect.midY + sheetContentRect.height/2 + 5
        }
    }

    /// The current offset, based on the **presented** property
    private var currentOffset: CGFloat {
        return isPresented ? displayedOffset : hiddenOffset
    }

    private var screenHeight: CGFloat {
        UIScreen.main.bounds.height
    }

    // MARK: - Content Builders

    public func body(content: Content) -> some View {
        content
            .applyIf(closeOnTapOutside) {
                $0.simultaneousGesture(
                    TapGesture().onEnded {
                        self.isPresented = false
                    })
            }
            .background(
                GeometryReader { proxy -> AnyView in
                    let rect = proxy.frame(in: .global)
                    // This avoids an infinite layout loop
                    if rect.integral != self.presenterContentRect.integral {
                        DispatchQueue.main.async {
                            self.presenterContentRect = rect
                        }
                    }
                    return AnyView(EmptyView())
                }
            ).overlay(sheet())
    }

    /// This is the builder for the sheet content
    func sheet() -> some View {

        // if needed, dispatch autohide and cancel previous one
        if let autohideIn = autohideIn {
            dispatchWorkHolder.work?.cancel()
            dispatchWorkHolder.work = DispatchWorkItem(block: {
                self.isPresented = false
            })
            if isPresented, let work = dispatchWorkHolder.work {
                DispatchQueue.main.asyncAfter(deadline: .now() + autohideIn, execute: work)
            }
        }

        return ZStack {
            Group {
                VStack {
                    VStack {
                        self.view()
//                            .simultaneousGesture(TapGesture().onEnded {
//                                if self.closeOnTap {
//                                    self.isPresented = false
//                                }
//                            })
                            .background(
                                GeometryReader { proxy -> AnyView in
                                    let rect = proxy.frame(in: .global)
                                    // This avoids an infinite layout loop
                                    if rect.integral != self.sheetContentRect.integral {
                                        DispatchQueue.main.async {
                                            self.sheetContentRect = rect
                                        }
                                    }
                                    return AnyView(EmptyView())
                                }
                            )
                    }
                }
                .frame(width: UIScreen.main.bounds.width)
                .offset(x: 0, y: currentOffset)
                .animation(animation)
            }
        }
    }
}

class DispatchWorkHolder {
    var work: DispatchWorkItem?
}



