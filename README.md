Base64Encoder
=============

ANE for Base64 Support (iOS, Android &amp; Destkop)

I created this ANE because decoding and encoding ByteArray or BitmapData to Base64 on mobile devices is very slow. It should work on iOS, Android and Desktop. I'm working on Blackberry version.


Installation
---------

The ANE binary (Base64Encoder.ane) is located in the *bin* folder. You should add it to your application project's Build Path and make sure to package it with your app (more information [here](http://help.adobe.com/en_US/air/build/WS597e5dadb9cc1e0253f7d2fc1311b491071-8000.html)).


Usage
---------

Just call the static methods

Encode / Decode ByteArray

    
    var myByteArray:ByteArray = new ByteArray();
    myByteArray.writeUTFBytes("I need some tacos!");
    
    var base64str:String = Base.encodeByteArray(myByteArray);
    trace (base64str);
    
    var myNewByteArray:ByteArray = Base.decodeByteArray(base64str);
    trace (myNewByteArray.readUTF());
    	
    
Encode / Decode BitmapData

    
    var myBitmapData:BitmapData = new BitmapData(100, 100);
    
    var base64str:String = Base.encodeBitmapData(myBitmapData);
    trace (base64str);
    
    var myNewBitmapData:ByteArray = Base.decodeBitmapData(base64str);
    	


Build script
---------

If you need to edit the extension source code and/or recompile it, you will find a shell.sh script to make it easy and you just need to edit the Flash Builder path.


Author
------

This ANE has been written by [Daniel Fernández](http://tangamampilia.net). It belongs to me and is distributed under the [Apache Licence, version 2.0](http://www.apache.org/licenses/LICENSE-2.0).
