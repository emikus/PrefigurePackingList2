//
//  Grid.swift
//  PPL
//
//  Created by Macbook Pro on 14/10/2020.
//

import Foundation
import SwiftUI
import CoreGraphics




/// A view that arranges its children in a grid.
public struct Grid<Content>: View where Content: View {
    @Environment(\.gridStyle) private var style
    @State var preferences: GridPreferences = GridPreferences(size: .zero, items: [])
    let items: [GridItemFromLibrary]
    
    public var body: some View {
        GeometryReader { geometry in
            ZStack(alignment: .topLeading) {
                ForEach(self.items) { item in
                    item.view
                        .frame(
                            width: self.style.autoWidth ? self.preferences[item.id]?.bounds.width : nil,
                            height: self.style.autoHeight ? self.preferences[item.id]?.bounds.height : nil
                        )
                        .alignmentGuide(.leading, computeValue: { _ in geometry.size.width - (self.preferences[item.id]?.bounds.origin.x ?? 0) })
                        .alignmentGuide(.top, computeValue: { _ in geometry.size.height - (self.preferences[item.id]?.bounds.origin.y ?? 0) })
                        .background(GridPreferencesModifier(id: item.id, bounds: self.preferences[item.id]?.bounds ?? .zero))
                        .anchorPreference(key: GridItemBoundsPreferencesKey.self, value: .bounds) { [geometry[$0]] }
                }
            }
            .transformPreference(GridPreferencesKey.self) {
                self.style.transform(preferences: &$0, in: geometry.size)
            }
        }
        .frame(
            minWidth: self.style.axis == .horizontal ? self.preferences.size.width : nil,
            minHeight: self.style.axis == .vertical ? self.preferences.size.height : nil,
            alignment: .topLeading
        )
        .onPreferenceChange(GridPreferencesKey.self) { preferences in
            self.preferences = preferences
        }
    }
}

#if DEBUG
@available(iOS 13.0, OSX 10.15, tvOS 13.0, watchOS 6.0, *)
struct Grid_Previews: PreviewProvider {
    static var previews: some View {
        Grid(0...100, id: \.self) {
            Text("\($0)")
        }
    }
}
#endif


extension Grid {
    public init<Data, Item>(_ data: Data, @ViewBuilder item: @escaping (Data.Element) -> Item) where Content == ForEach<Data, Data.Element.ID, Item>, Data : RandomAccessCollection, Item : View, Data.Element : Identifiable {
        self.items = data.map { GridItemFromLibrary(view: AnyView(item($0)), id: AnyHashable(UUID())) }
    }

    public init<Data, ID, Item>(_ data: Data, id: KeyPath<Data.Element, ID>, @ViewBuilder item: @escaping (Data.Element) -> Item) where Content == ForEach<Data, ID, Item>, Data : RandomAccessCollection, ID : Hashable, Item : View {
        self.items = data.map { GridItemFromLibrary(view: AnyView(item($0)), id: AnyHashable($0[keyPath: id])) }
    }

    public init<Item>(_ data: Range<Int>, @ViewBuilder item: @escaping (Int) -> Item) where Content == ForEach<Range<Int>, Int, Item>, Item : View {
        self.items = data.map { GridItemFromLibrary(view: AnyView(item($0)), id: AnyHashable($0)) }
    }
}

extension Grid {
    public init<C0: View, C1: View>(@ViewBuilder content: () -> Content) where Content == TupleView<(C0, C1)> {
        self.items = [GridItemFromLibrary(view: AnyView(content().value.0), id: AnyHashable(0)),
                      GridItemFromLibrary(view: AnyView(content().value.1), id: AnyHashable(1))]
    }

    public init<C0: View, C1: View, C2: View>(@ViewBuilder content: () -> Content) where Content == TupleView<(C0, C1, C2)> {
        self.items = [GridItemFromLibrary(view: AnyView(content().value.0), id: AnyHashable(0)),
                      GridItemFromLibrary(view: AnyView(content().value.1), id: AnyHashable(1)),
                      GridItemFromLibrary(view: AnyView(content().value.2), id: AnyHashable(2))]
    }

    public init<C0: View, C1: View, C2: View, C3: View>(@ViewBuilder content: () -> Content) where Content == TupleView<(C0, C1, C2, C3)> {
        self.items = [GridItemFromLibrary(view: AnyView(content().value.0), id: AnyHashable(0)),
                      GridItemFromLibrary(view: AnyView(content().value.1), id: AnyHashable(1)),
                      GridItemFromLibrary(view: AnyView(content().value.2), id: AnyHashable(2)),
                      GridItemFromLibrary(view: AnyView(content().value.3), id: AnyHashable(3))]
    }

    public init<C0: View, C1: View, C2: View, C3: View, C4: View>(@ViewBuilder content: () -> Content) where Content == TupleView<(C0, C1, C2, C3, C4)> {
        self.items = [GridItemFromLibrary(view: AnyView(content().value.0), id: AnyHashable(0)),
                      GridItemFromLibrary(view: AnyView(content().value.1), id: AnyHashable(1)),
                      GridItemFromLibrary(view: AnyView(content().value.2), id: AnyHashable(2)),
                      GridItemFromLibrary(view: AnyView(content().value.3), id: AnyHashable(3)),
                      GridItemFromLibrary(view: AnyView(content().value.4), id: AnyHashable(4))]
    }

    public init<C0: View, C1: View, C2: View, C3: View, C4: View, C5: View>(@ViewBuilder content: () -> Content) where Content == TupleView<(C0, C1, C2, C3, C4, C5)> {
        self.items = [GridItemFromLibrary(view: AnyView(content().value.0), id: AnyHashable(0)),
                      GridItemFromLibrary(view: AnyView(content().value.1), id: AnyHashable(1)),
                      GridItemFromLibrary(view: AnyView(content().value.2), id: AnyHashable(2)),
                      GridItemFromLibrary(view: AnyView(content().value.3), id: AnyHashable(3)),
                      GridItemFromLibrary(view: AnyView(content().value.4), id: AnyHashable(4)),
                      GridItemFromLibrary(view: AnyView(content().value.5), id: AnyHashable(5))]
    }

    public init<C0: View, C1: View, C2: View, C3: View, C4: View, C5: View, C6: View>(@ViewBuilder content: () -> Content) where Content == TupleView<(C0, C1, C2, C3, C4, C5, C6)> {
        self.items = [GridItemFromLibrary(view: AnyView(content().value.0), id: AnyHashable(0)),
                      GridItemFromLibrary(view: AnyView(content().value.1), id: AnyHashable(1)),
                      GridItemFromLibrary(view: AnyView(content().value.2), id: AnyHashable(2)),
                      GridItemFromLibrary(view: AnyView(content().value.3), id: AnyHashable(3)),
                      GridItemFromLibrary(view: AnyView(content().value.4), id: AnyHashable(4)),
                      GridItemFromLibrary(view: AnyView(content().value.5), id: AnyHashable(5)),
                      GridItemFromLibrary(view: AnyView(content().value.6), id: AnyHashable(6))]
    }

    public init<C0: View, C1: View, C2: View, C3: View, C4: View, C5: View, C6: View, C7: View>(@ViewBuilder content: () -> Content) where Content == TupleView<(C0, C1, C2, C3, C4, C5, C6, C7)> {
        self.items = [GridItemFromLibrary(view: AnyView(content().value.0), id: AnyHashable(0)),
                      GridItemFromLibrary(view: AnyView(content().value.1), id: AnyHashable(1)),
                      GridItemFromLibrary(view: AnyView(content().value.2), id: AnyHashable(2)),
                      GridItemFromLibrary(view: AnyView(content().value.3), id: AnyHashable(3)),
                      GridItemFromLibrary(view: AnyView(content().value.4), id: AnyHashable(4)),
                      GridItemFromLibrary(view: AnyView(content().value.5), id: AnyHashable(5)),
                      GridItemFromLibrary(view: AnyView(content().value.6), id: AnyHashable(6)),
                      GridItemFromLibrary(view: AnyView(content().value.7), id: AnyHashable(7))]
    }

    public init<C0: View, C1: View, C2: View, C3: View, C4: View, C5: View, C6: View, C7: View, C8: View>(@ViewBuilder content: () -> Content) where Content == TupleView<(C0, C1, C2, C3, C4, C5, C6, C7, C8)> {
        self.items = [GridItemFromLibrary(view: AnyView(content().value.0), id: AnyHashable(0)),
                      GridItemFromLibrary(view: AnyView(content().value.1), id: AnyHashable(1)),
                      GridItemFromLibrary(view: AnyView(content().value.2), id: AnyHashable(2)),
                      GridItemFromLibrary(view: AnyView(content().value.3), id: AnyHashable(3)),
                      GridItemFromLibrary(view: AnyView(content().value.4), id: AnyHashable(4)),
                      GridItemFromLibrary(view: AnyView(content().value.5), id: AnyHashable(5)),
                      GridItemFromLibrary(view: AnyView(content().value.6), id: AnyHashable(6)),
                      GridItemFromLibrary(view: AnyView(content().value.7), id: AnyHashable(7)),
                      GridItemFromLibrary(view: AnyView(content().value.8), id: AnyHashable(8))]
    }

    public init<C0: View, C1: View, C2: View, C3: View, C4: View, C5: View, C6: View, C7: View, C8: View, C9: View>(@ViewBuilder content: () -> Content) where Content == TupleView<(C0, C1, C2, C3, C4, C5, C6, C7, C8, C9)> {
        self.items = [GridItemFromLibrary(view: AnyView(content().value.0), id: AnyHashable(0)),
                      GridItemFromLibrary(view: AnyView(content().value.1), id: AnyHashable(1)),
                      GridItemFromLibrary(view: AnyView(content().value.2), id: AnyHashable(2)),
                      GridItemFromLibrary(view: AnyView(content().value.3), id: AnyHashable(3)),
                      GridItemFromLibrary(view: AnyView(content().value.4), id: AnyHashable(4)),
                      GridItemFromLibrary(view: AnyView(content().value.5), id: AnyHashable(5)),
                      GridItemFromLibrary(view: AnyView(content().value.6), id: AnyHashable(6)),
                      GridItemFromLibrary(view: AnyView(content().value.7), id: AnyHashable(7)),
                      GridItemFromLibrary(view: AnyView(content().value.8), id: AnyHashable(8)),
                      GridItemFromLibrary(view: AnyView(content().value.9), id: AnyHashable(9))]
    }
}


struct GridItemFromLibrary: Identifiable {
    let view: AnyView
    let id: AnyHashable
}
