# Focus
==========

A generic way to implement focus on an Identifiable datamodel and makes it simple 
to get and set focus to records in an array, which is especially useful for Lists.

## Why does this package need to be ?

Using the out of the box @FocusState propery wrapper over data arrays means using 
enums with associated values, and the code then becomes somewhat complex as we will
see in two trivial examples below.

### @FocusState example:
In order to print the text value from a record in your data array, you would
need code such as that below. 
```
	case .focusData(let id) = focusField
	if let id = id,
		let index = yourDataArray.firstIndexOf( where { $0.id = id }) {
  		print(yourDataArray[index].text)
    } else {
    	print("no text")
    }  
``` where focusData is the enum case value.
Conversely, to set the focus, you have to use syntax similar to 
```
	focusField = .focusData(id: YourDataRow.id)
```
It's fine. It's okay. But it should be easier, right? 

## A Solution
I'm sure there are other ways to make it easier, but this package attempts to make it simple
to both set the focus, and get data from the record that is currently focused. 
Using the same examples as those above, 
### @Focus example:
```
	print(focusField?.text ?? "no text")
```
and to set the focus to a data record;
```
	focusField = YourDataRow
```

Now that's better right?  Of course there is some complexity in the definitions, but not much, and 
no more than is required for the out of the box SwiftUI solution.
See the example.swift file for a full worked example, that syncs it's focus field with a view model.


# Usage

First, ```import Focus```.

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
	@Focus private var focusedRow: myDataModel?
```
On the data items that you want to set focus, add a call to ``` .enableFocus``` 
e.g.
```
	.enableFocus(on: myDataItem, with: _focusedRow)
```
you can now set and get focus using the variable ```focusedRow```. 


# The End.

