# EasyFocus
================

A generic way to implement focus on an Identifiable datamodel and makes it simple 
to get and set focus to records in an array, which is especially useful for Lists.

## Why does this package exist ?

Using the out of the box @FocusState propery wrapper over data arrays means using 
enums with associated values, and the code then becomes somewhat complex as we will
see in two trivial examples below.

### @FocusState example:
In order to print the text value from a record in yourDataArray, you would
need code such as that below. 
```
	public enum FocusID : Hashable {
   	case focusID(id: String)
	}
	...
	@FocusState private var focusedID: FocusID?
	...
	case .focusID(let id) = focusedID
	if let id = id,
		let index = yourDataArray.firstIndexOf( where { $0.id = id }) {
  		print(yourDataArray[index].text)
    } else {
    	print("no text")
    }  
``` 
Conversely, to set the focus to the row YourDataRow, you have to use syntax similar to 
```
	focusedID = .focusID(id: YourDataRow.id)
```
It's fine. It's okay. It is though a little tedious and non intuitive. It should be easier! 

## A Solution
This package aims to make it simpler to both set the focus, and get data from the 
record that is currently focused. 
Using the same examples as those above, this package eliminates the need to define an enum, and 
uses your data model as the target of an @Focus property wrapper;
### @Focus example:
```
	@Focus private var focusedRow: YourDataModel?
	...
	print(focusedRow?.text ?? "no text")
```
and to set the focus to a data record;
```
	focusedRow = YourDataRow
```

Now that's a lot less code!  ( I have omitted some code for brevity, but not much, and 
no more than is required for the out of the box SwiftUI solution.)
See the example.swift file for a full worked example, that syncs it's focused row in a List with a view model.


# Usage

First, ```import EasyFocus```.

Second, define your data model, and make it comply with ```FocusableListRow```
To do that, just add an id field, and make sure the struct is hashable.
e.g. 
```
	struct myDataModel : FocusableListRow {
		id: Int
		text: String
	}
```
Then, define your variable to hold focus;
```
	@Focus private var focusedRow: YourDataModel?
```
On the data items that you want to set focus, add a call to ``` .enableFocus``` 
e.g.
```
	.enableFocus(on: myDataItem, with: _focusedRow)
```
you can now set and get focus using the variable ```focusedRow```. 


# The End.

