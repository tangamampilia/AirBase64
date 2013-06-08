#!/bin/bash
  
SWFVERSION=14
 
INCLUDE_CLASSES="net.tangamampilia.Base64Encoder"
NAME="Base64Encoder"
BUILT="build/"
DESTINATION="../bin/"

echo "COPYING FILES"
cp ios/lib$NAME.a $BUILT
sleep 1
 
echo "GENERATING SWC"
$"/Applications/Adobe Flash Builder 4.7/sdks/4.6.0/bin/acompc" -source-path actionscript/src/ -include-classes $INCLUDE_CLASSES -swf-version=$SWFVERSION -output $BUILT$NAME.swc
sleep 1
 
cd $BUILT
echo "GENERATING LIBRARY from SWC"
unzip $NAME.swc
sleep 1
 
echo "GENERATING ANE"
$"/Applications/Adobe Flash Builder 4.7/sdks/4.6.0/bin/adt" -package -target ane $DESTINATION$NAME.ane extension.xml -swc $NAME.swc -platform iPhone-ARM library.swf lib$NAME.a -platformoptions platform.xml -platform default library.swf
sleep 1

echo "CLEANING FILES"
[[ -f "catalog.xml" ]] && rm -f "catalog.xml"
[[ -f "library.swf" ]] && rm -f "library.swf"
[[ -f "$NAME.swc" ]] && rm -f "$NAME.swc"
[[ -f "lib$NAME.a" ]] && rm -f "lib$NAME.a"
sleep 1
 
echo "DONE!"