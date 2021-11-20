//
//  Example.swift
//  EasyFocus
//
//  Created by Andrew Cowley on 19/11/2021.
//
/*
import SwiftUI

struct EasyFocusExample: View {
   @StateObject var vm = EasyFocusViewModel()
   @Focus private var focusedRow: FocusDataModelExample?
   var body: some View {
      VStack {
         List {
            ForEach($vm.data) { $row in
               TextField("row text", text: $row.text)
                  .enableFocus(on: row, with: _focusedRow)
                  .onSubmit { vm.newRow() }
            }
         }
         .animation(.easeInOut, value: vm.data)
         .sync( $vm.focusedRow, _focusedRow )

         Button("Print current row text, then goto row \(vm.randomRow+1)") {
            vm.buttonPress()
         }
         .buttonStyle(.borderedProminent)
      }
   }
}

class EasyFocusViewModel: ObservableObject {
   @Published var data = FocusDataModelExample.examples
   @Published var focusedRow: FocusDataModelExample?
   @Published var randomRow: Int = 0  // For settng focus to random rows

   func indexAfter(_ id: String) -> Int {
      let currentIndex = data.firstIndex(where: {$0.id == id}) ?? data.endIndex
      return data.index(after: currentIndex )
   }
   /// Add a new row to the collection immediate after the currently focused row,
   /// and then set the focus to the new row
   func newRow() {
      let newRow = FocusDataModelExample()
      if let id = focusedRow?.id,
         let ind = data.firstIndex(where: {$0.id == id}) {
         data.insert(newRow, at: data.index(after: ind))
      } else {
         data.append(newRow)
      }
      focusedRow = newRow
   }
   /// Prints the text on the currently focused row, moves the focus
   /// to a new row indicated on the button, then sets a new random(*) row
   /// for the next button press. (*): excludes currrent row.
   func buttonPress() {
      print(focusedRow?.text ?? "") // uses the get
      focusedRow = data[randomRow]
      randomRow = (0..<data.count)
         .filter({ $0 != randomRow})
         .randomElement()!
   }
   init() {
      randomRow = Int.random(in: 0..<data.count)
   }
}

struct FocusDataModelExample: FocusableListRow {
   // N.B. We could have picked any datatype for our id, as long as it inherits Identifiable & Equatable
   var id = UUID().uuidString
   var text: String = ""

   static var examples = [ FocusDataModelExample(id: "1", text: "one"),
                           FocusDataModelExample(id: "2", text: "two"),
                           FocusDataModelExample(id: "3", text: "three") ]
}

// Previews of this view currently crashes in Xcode 13.2 beta 2
struct EasyFocusExample_Previews: PreviewProvider {
   static var previews: some View {
      EasyFocusExample()
   }
}
*/
