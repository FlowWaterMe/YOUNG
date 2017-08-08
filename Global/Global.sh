INPUT=Global_Function.pkg
OUTPUT=Global_Function-lua.mm
tolua=tolua++
$tolua -o $OUTPUT $INPUT

$tolua -o Global_Variant1-lua.mm Global_Variant1.pkg
$tolua -o Global_Variant2-lua.mm Global_Variant2.pkg
$tolua -o Global_Variant3-lua.mm Global_Variant3.pkg
$tolua -o Global_Variant4-lua.mm Global_Variant4.pkg
$tolua -o Global_Variant5-lua.mm Global_Variant5.pkg
$tolua -o Global_Variant6-lua.mm Global_Variant6.pkg
