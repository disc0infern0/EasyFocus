//
//  Focus
//
// MIT License (c) 2021 Andrew Cowley
// see attached License.md
//
import SwiftUI
import Combine

public struct EasyFocus {
   
}
/// Generic implementation of the enum used by @FocusState.
/// If the datamodel complies with FocusableListRow, then  we can rely on the
/// underlying type of the id field instead of hardcoding it to String, or Int,  which is common.
/// Conformance to Hashable is required by @FocusState
/// Conformance to Equatable is required to match id's
///
public enum FocusID <T: Identifiable & Equatable> : Hashable {
   case row(id: T.ID)
}

/// Protocol that the datamodel for each row used in a List must satisfy.
public protocol FocusableListRow: Identifiable & Hashable {
   //  var id: Self.ID { get }
}

/// The wrapped value of the @Focus variable can be used to get the row that
/// is currently focused, or to set the focus to the row specified.
/// The setter of the wrapped value allows you to programmatically set the focus to the
/// desired row.
/// The project value returns a different datatype, and is a binding to the underlying @FocusState field
/// that makes the magic happen, and is used in the view modification .enableFocus
@propertyWrapper
public struct Focus<Row: FocusableListRow>: DynamicProperty {
   public init() {}
   @FocusState private var focusedField: FocusID<Row>?

   /* Simply returning currentRow in the getter of the wrappedValue is a cludge,
    * since we then have to rely on a tapGesture to actually set the focus, when
    * it is set by the UI rather than programmatically.
    * In order to build the tap gesture in the package candidate view modifier, we need
    * to access both the wrapped and the projected value of the Focus<Row> variable.
    * To do that, we pass in the variable with an _ prefix to our enableFocus() modifier,
    * which is unintuitive.
    *
    * Ideally we would pass a Binding to the [Row] that the ForEach is using
    * into this propery wrapper, which would eliminate the need for a tapGesture,
    * and mean that the $ prefixed variable could be passed into enableFocus().
    * e.g.
    */
   // @Binding var rows: [Row]
   // public init (rows: <[Row]>.Binding {
   //    self.rows = rows
   // }
   /* then the call site would be
    * @Focus(rows: $viewmodel.rows) var focusedRow: DataItem?
    * That would enable us to get the row directly from the focusedField by
    * querying the array and matching on the id
    * e.g.
    */
   // get {
   //    guard case .row(let id) = focusedField else { return nil }
   //    return rows.firstIndex( where { $0.id = id } )
   // }
   /* I could find no way to pass in such a binding without triggering an error.
    * The biggest hurdle is needing to reference self when instantiating the @Focus variable,
    * in order to pass in a variable reference for the viewmodel or its data.
    */
   @State
   private var currentRow: Row? // cludge that will require setting in the call site via .tapGesture
   public var wrappedValue: Row? {
      get {
         return currentRow
      }
      nonmutating set {
         currentRow = newValue
         if let row = newValue {
            focusedField = .row(id: row.id)
         }
      }
   }

   public var projectedValue: FocusState<FocusID<Row>?>.Binding { $focusedField }
}

public extension View {
   /// Mark the row with a condition so that focus can be set/get to/from it.
   /// Also add a tap gesture to the row to recognise user moving focus.
   func enableFocus<Row: FocusableListRow> (
      on row: Row, with focus: Focus<Row>) -> some View {
         modifier(FocusModifier(row: row, focus: focus))
      }

   /// Mirror changes between an @Published variable (typically in your View Model)
   /// and an @Focus variable in a view
   func sync<Row: FocusableListRow>(_ publisher: Binding<Row?>, _ focusRow: Focus<Row> ) -> some View {
		modifier(FocusSync(vmPublisher: publisher, focusRow: focusRow))
      /* For XCode 13.2 beta no delay is necessary and the above modifier is not needed */
//      return self
//         .onChange(of: publisher.wrappedValue) { focusRow.wrappedValue = $0 }
//         .onChange(of: focusRow.wrappedValue ) { publisher.wrappedValue = $0 }
   }
}

/// Mark the view with the @FocusState equality condition to allow focus tracking
/// Also add a tap gesture to track focus changes made in the UI
public struct FocusModifier<Row: FocusableListRow>: ViewModifier {
   var row: Row
   var focus: Focus<Row>
   public func body(content: Content) -> some View {
      return content
         .focused(focus.projectedValue, equals: .row(id: row.id))
         .onTapGesture { focus.wrappedValue = row }
   }
}
/// push changes to viewmodel publisher on to view after a small delay
/// but sync changes on the view(via the UI)  to the viewmodel instantly
public struct FocusSync<Row: FocusableListRow>: ViewModifier {
	var vmPublisher: Binding<Row?>
	var focusRow: Focus<Row>

   init( vmPublisher: Binding<Row?>, focusRow: Focus<Row>) {
      self.vmPublisher = vmPublisher
      self.focusRow = focusRow
   }

   func delay(update: @escaping ()-> Void ) {
      DispatchQueue.main.asyncAfter(deadline: .now() + 0.01, execute: update )
   }
   public func body(content: Content) -> some View {
      return content
         .onChange(of: vmPublisher.wrappedValue) { newValue in
            delay {
               self.focusRow.wrappedValue = newValue
            }
         }
         .onChange(of: focusRow.wrappedValue ) { newValue in
            self.vmPublisher.wrappedValue = newValue
         }
   }
}
