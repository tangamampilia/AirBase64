//////////////////////////////////////////////////////////////////////////////////////
//
//  Copyright 2013 http://tangamampilia.net/
//  
//  Licensed under the Apache License, Version 2.0 (the "License");
//  you may not use this file except in compliance with the License.
//  You may obtain a copy of the License at
//  
//    http://www.apache.org/licenses/LICENSE-2.0
//  
//  Unless required by applicable law or agreed to in writing, software
//  distributed under the License is distributed on an "AS IS" BASIS,
//  WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
//  See the License for the specific language governing permissions and
//  limitations under the License.
//  
//////////////////////////////////////////////////////////////////////////////////////

package net.tangamampilia {
	
	import flash.display.BitmapData;
	import flash.events.EventDispatcher;
	import flash.events.StatusEvent;
	import flash.external.ExtensionContext;
	import flash.geom.Rectangle;
	import flash.system.Capabilities;
	import flash.utils.ByteArray;
	
	
	public class AirBase64 {
		
		public static var DEBUG:Boolean;
		private static const EXTENSION_ID : String = "net.tangamampilia.AirBase64";
		private static var _instance : AirBase64;
		private var _context : ExtensionContext;
		private static const BASE64_CHARS:String = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/=";
		
		public function AirBase64() {
			
			if (!_instance) {
				_context = ExtensionContext.createExtensionContext(EXTENSION_ID, "");
				if (!_context) {
					throw Error("ERROR - Extension context is null. Please check if extension.xml is setup correctly.");
					return;
				}
				_instance = this;			
			} else {
				throw Error("This is a singleton, do not call the constructor directly.");
			}
			
		}
		
		
		/** Bitmap is supported on iOS and Air. I'm working on Android device. */
		public static function get isSupported() : Boolean {
			var supported:Array = ["iOS", "Android", "Macintosh", "Windows"];
			for (var i:int = 0; i<supported.length; i++) {
				if (Capabilities.manufacturer.indexOf(supported[i]) != -1) {
					return true;
				}
			}
			return false;
		}
		
		
		private static function get _isDesktopSimulator() : Boolean {
			var supported:Array = ["Macintosh", "Windows"];
			for (var i:int = 0; i<supported.length; i++) {
				if (Capabilities.manufacturer.indexOf(supported[i]) != -1) {
					return true;
				}
			}
			return false;
		}
		
		
		public static function getInstance() : AirBase64 {
			return _instance ? _instance : new AirBase64();
		}
		
		
		/** Encode a String */
		public static function encode(data:String) : String {
			
			if (!AirBase64.isSupported) return null;
			
			if(data == null){   
				throw new Error("data parameter can not be empty!");   
			}
			
			var bytes:ByteArray = new ByteArray();
			bytes.writeUTFBytes(data);
			
			return encodeByteArray(bytes);
			
		}
		
		
		/** Decode a String */
		public static function decode(data:String) : String {
			
			if (!AirBase64.isSupported) return null;
			
			if(data == null){   
				throw new Error("data parameter can not be empty!");   
			}
			
			var bytes:ByteArray = decodeByteArray(data);
			
			return bytes.readUTFBytes(bytes.length);
			
		}
		
		
		
		/** Encode a ByteArray */
		public static function encodeByteArray(data:ByteArray) : String {
			
			if (!AirBase64.isSupported) return null;
			
			if(data == null){   
				throw new Error("data parameter can not be empty!");   
			}
			
			data.compress();
			var base64:String;
			
			if (AirBase64._isDesktopSimulator) {
				base64 = AirBase64._airEncodeBase64(data);
			} else {
				var native:AirBase64 =  AirBase64.getInstance();
				base64 = native._context.call("AirBase64Encode", data) as String;
			}
			
			return base64;
		}
		
		
		
		/** Decode a ByteArray */
		public static function decodeByteArray(data:String) : ByteArray  {
			
			if (!AirBase64.isSupported) return null;
			
			if(data == null){   
				throw new Error("data parameter can not be empty!");   
			}
			
			var bytes:ByteArray;
			
			if (AirBase64._isDesktopSimulator) {
				bytes = AirBase64._airDecodeBase64(data);
			} else {
				var native:AirBase64 =  AirBase64.getInstance();
				bytes = native._context.call("AirBase64Decode", data) as ByteArray;
			}
			
			bytes.uncompress();
			return bytes;
		}
				
		
		
		/** Encode a BitmapData */
		public static function encodeBitmapData(data:BitmapData) : String {
			
			if (!AirBase64.isSupported) return null;
			
			if(data == null){   
				throw new Error("data parameter can not be empty!");   
			}
			
			var bytes:ByteArray = AirBase64._airEncodeBitmapData(data);
			var base64:String;
			
			if (AirBase64._isDesktopSimulator) {
				base64 = AirBase64._airEncodeBase64(bytes);
			} else {
				var native:AirBase64 =  AirBase64.getInstance();
				base64 = native._context.call("AirBase64Encode", bytes) as String;
			}
			
			return base64;
		}
		
		
		
		/** Decode a BitmapData. */
		public static function decodeBitmapData(data:String) : BitmapData  {
			
			if (!AirBase64.isSupported) return null;
			
			if(data == null){   
				throw new Error("data parameter can not be empty!");   
			}
			
			var bytes:ByteArray;
			if (AirBase64._isDesktopSimulator) {
				bytes =  AirBase64._airDecodeBase64(data);
			} else {
				var native:AirBase64 =  AirBase64.getInstance();
				bytes = native._context.call("AirBase64Decode", data) as ByteArray;
			}
			
			var bitmapData:BitmapData = AirBase64._airDecodeBitmapData(bytes);
			return bitmapData;
			
		}
		
		
		
		private static function _airEncodeBitmapData(data:BitmapData):ByteArray{   
			var bytes:ByteArray = data.getPixels(data.rect);   
			bytes.writeShort(data.width);   
			bytes.writeShort(data.height);   
			bytes.writeBoolean(data.transparent);   
			bytes.compress();   
			return bytes;   
		}   
		
		
		private static function _airEncodeBase64(data:ByteArray):String{   

			// Initialise output
			var output:String = "";
			
			// Create data and output buffers
			var dataBuffer:Array;
			var outputBuffer:Array = new Array(4);
			
			// Rewind ByteArray
			data.position = 0;
			
			// while there are still bytes to be processed
			while (data.bytesAvailable > 0) {
				// Create new data buffer and populate next 3 bytes from data
				dataBuffer = new Array();
				for (var i:uint = 0; i < 3 && data.bytesAvailable > 0; i++) {
					dataBuffer[i] = data.readUnsignedByte();
				}
				
				// Convert to data buffer Base64 character positions and 
				// store in output buffer
				outputBuffer[0] = (dataBuffer[0] & 0xfc) >> 2;
				outputBuffer[1] = ((dataBuffer[0] & 0x03) << 4) | ((dataBuffer[1]) >> 4);
				outputBuffer[2] = ((dataBuffer[1] & 0x0f) << 2) | ((dataBuffer[2]) >> 6);
				outputBuffer[3] = dataBuffer[2] & 0x3f;
				
				// If data buffer was short (i.e not 3 characters) then set
				// end character indexes in data buffer to index of '=' symbol.
				// This is necessary because Base64 data is always a multiple of
				// 4 bytes and is basses with '=' symbols.
				for (var j:uint = dataBuffer.length; j < 3; j++) {
					outputBuffer[j + 1] = 64;
				}
				
				// Loop through output buffer and add Base64 characters to 
				// encoded data string for each character.
				for (var k:uint = 0; k < outputBuffer.length; k++) {
					output += BASE64_CHARS.charAt(outputBuffer[k]);
				}
			}
			
			// Return encoded data
			return output;
		} 
		
		
		private static function _airDecodeBitmapData(bytes:ByteArray):BitmapData{   
			if(bytes == null){   
				throw new Error("Bytes parameter can not be empty!");   
			}   
			bytes.uncompress();   
			if(bytes.length <  6){   
				throw new Error("Bytes parameter is a invalid value");   
			}              
			bytes.position = bytes.length - 1;   
			var transparent:Boolean = bytes.readBoolean();   
			bytes.position = bytes.length - 3;   
			var height:int = bytes.readShort();   
			bytes.position = bytes.length - 5;   
			var width:int = bytes.readShort();   
			bytes.position = 0;   
			var datas:ByteArray = new ByteArray();             
			bytes.readBytes(datas,0,bytes.length - 5);   
			var bmp:BitmapData = new BitmapData(width,height,transparent,0);   
			bmp.setPixels(new Rectangle(0,0,width,height),datas);   
			return bmp;   
		}   
		
		
		private static function _airDecodeBase64(data:String):ByteArray{               
			// Initialise output ByteArray for decoded data
			var output:ByteArray = new ByteArray();
			
			// Create data and output buffers
			var dataBuffer:Array = new Array(4);
			var outputBuffer:Array = new Array(3);
			
			// While there are data bytes left to be processed
			for (var i:uint = 0; i < data.length; i += 4) {
				// Populate data buffer with position of Base64 characters for
				// next 4 bytes from encoded data
				for (var j:uint = 0; j < 4 && i + j < data.length; j++) {
					dataBuffer[j] = BASE64_CHARS.indexOf(data.charAt(i + j));
				}
				
				// Decode data buffer back into bytes
				outputBuffer[0] = (dataBuffer[0] << 2) + ((dataBuffer[1] & 0x30) >> 4);
				outputBuffer[1] = ((dataBuffer[1] & 0x0f) << 4) + ((dataBuffer[2] & 0x3c) >> 2);                
				outputBuffer[2] = ((dataBuffer[2] & 0x03) << 6) + dataBuffer[3];
				
				// Add all non-padded bytes in output buffer to decoded data
				for (var k:uint = 0; k < outputBuffer.length; k++) {
					if (dataBuffer[k+1] == 64) break;
					output.writeByte(outputBuffer[k]);
				}
			}
			
			// Rewind decoded data ByteArray
			output.position = 0;
			
			// Return decoded data
			return output;   
		}   	
	}
}