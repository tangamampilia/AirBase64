#!/bin/bash
  
SWFVERSION=23
 
NAME="AirBase64"
DESTINATION="../bin/"
INCLUDE_CLASSES="net.tangamampilia.$NAME"
BUILT="build/"
COMPILERSWC="/Applications/Adobe Flash Builder 4.7/sdks/4.6.0_AIR_3.7/bin"
COMPILERANE="/Applications/Adobe Flash Builder 4.7/eclipse/plugins/com.adobe.flash.compiler_4.7.0.349722/AIRSDK/bin"



echo "COPYING FILES"
cp ios/lib$NAME.a $BUILT
cp android/lib$NAME.jar $BUILT



echo "GENERATING SWC"
$"$COMPILERSWC/acompc" -source-path actionscript/src/ -include-classes $INCLUDE_CLASSES -swf-version=$SWFVERSION -output $BUILT$NAME.swc



cd $BUILT
echo "GENERATING LIBRARY from SWC"
unzip $NAME.swc



echo "GENERATING ANE"
$"$COMPILERANE/adt" -package -target ane $DESTINATION$NAME.ane extension.xml -swc $NAME.swc -platform iPhone-ARM library.swf  -platformoptions platform.xml lib$NAME.a -platform iPhone-x86 library.swf -platformoptions platform.xml lib$NAME.a -platform Android-ARM library.swf lib$NAME.jar -platform default library.swf



echo "CLEANING FILES"
[[ -f "catalog.xml" ]] && rm -f "catalog.xml"
[[ -f "library.swf" ]] && rm -f "library.swf"
[[ -f "$NAME.swc" ]] && rm -f "$NAME.swc"
[[ -f "lib$NAME.a" ]] && rm -f "lib$NAME.a"
[[ -f "lib$NAME.jar" ]] && rm -f "lib$NAME.jar"



echo "DONE AT "$(date +"%T")