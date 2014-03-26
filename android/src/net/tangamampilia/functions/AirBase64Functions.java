package net.tangamampilia.functions;


import java.nio.ByteBuffer;

import net.tangamampilia.AirBase64Context;

import android.util.Base64;
import android.util.Log;

import com.adobe.fre.FREContext;
import com.adobe.fre.FREFunction;
import com.adobe.fre.FREObject;
import com.adobe.fre.FREByteArray;

public class AirBase64Functions implements FREFunction {

	String _method;
	AirBase64Context airBase64Context;
	
	public AirBase64Functions (String method) {
		super();
		_method = method;
	}
	
	@Override
	public FREObject call(FREContext context, FREObject[] args) {
		
		airBase64Context = (AirBase64Context)context;
		
		if (_method == "Encode") 		return Encode(context, args);
		else if (_method == "Decode") 	return Decode(context, args);
		else return null;
		
		// TODO Auto-generated method stub
	}
	
	public FREObject Encode(FREContext context, FREObject[] args) {

		FREObject base64 = null;
		
		try {
			FREByteArray ba = (FREByteArray) args[0];
						
			ba.acquire();
			ByteBuffer bb = ba.getBytes();
			byte[] bytes = new byte[(int) ba.getLength()];
			bb.get(bytes);
			
			String base64str = Base64.encodeToString(bytes, Base64.DEFAULT);
			
			base64 = FREObject.newObject(base64str);
			ba.release();
			
	     } catch (Exception e) {
	            Log.e("ANE", "An error occurred while reading the ByteArray", e);
	     }
	    		
		return base64;
		
	}
	
	public FREObject Decode(FREContext context, FREObject[] args) {
		
		FREByteArray byteArray = null;
		
		try {
						
			String base64str = args[0].getAsString();			
			byte[] bytes = Base64.decode(base64str, Base64.DEFAULT);

			byteArray =  FREByteArray.newByteArray();
			byteArray.setProperty("length", FREObject.newObject(bytes.length));
			byteArray.acquire();
			
			ByteBuffer byteBuffer = byteArray.getBytes();
			byteBuffer.put(bytes);
			
			byteArray.release();
									
		} catch (Exception e) {
			e.printStackTrace();
			return null;
		}
		
		return byteArray;
	}

}
