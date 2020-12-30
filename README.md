# Format-Menu

Menu framework for Powershell scripting

Displays a Simple Menu built from a JSON Object and returns the index the user selects

## .PARAMETERS

### InputJSON

The JSON object used to create the Menu.  The object should be built as follows.

#### Required Objects

- Header:  DataType String.  This is the Header that will be displayed at the top of the Menu.
- MenuItems: DataType Array of Strings. This array will be parsed as the options displayed in the Menu.  Numbering will be given in a top down order starting from 0.

#### Optional Objects

- LineWidth: DataType Int. This is the width of the Menu.  The default of 80 will be set if omitted.
- Colors: DataType Array of Objects.  This holds the Menu and Border color selections.
- BorderBackground: DataType Int.  This will be the Border Background Color.  The default of 0 will be set if omitted.
- BorderForeground: DataType Int.  This will be the Border Foreground Color.  The default of 6 will be set if omitted.
- MenuBackground: DataType Int.  This will be the Menu Background Color.  The default of 0 will be set if omitted.
- MenuForeground: DataType Int.  This will be the Menu Foreground Color.  The default of 10 will be set if omitted.

### Example JSON Object

{
    "Header": "Test Menu",
    "LineWidth": 80,
    "Colors": {
        "MenuBackground": 0,
        "MenuForeground": 10,
        "BorderBackground": 0,
        "BorderForeground": 6
    },
    "MenuItems": [
        "Option 1",
        "Option 2",
        "Option 3"
    ]
}

### Example use

```Powershell
$JSON = Get-Content .\Test\TestInput.json
Format-Menu -InputObject $JSON

╔════╤═════════════════════════════════════════════════════════════════════════╗
║    │Test Menu                                                                ║
╠════╪═════════════════════════════════════════════════════════════════════════╣
║  0 │ Option 1                                                                ║
║  1 │ Option 2                                                                ║
║  2 │ Option 3                                                                ║
╚════╧═════════════════════════════════════════════════════════════════════════╝
```