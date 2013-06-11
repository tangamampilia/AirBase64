package net.tangamampilia.functions;


import java.nio.ByteBuffer;

import android.util.Base64;

import com.adobe.fre.FREContext;
import com.adobe.fre.FREFunction;
import com.adobe.fre.FREObject;
import com.adobe.fre.FREByteArray;

public class Decode implements FREFunction {

	@Override
	public FREByteArray call(FREContext context, FREObject[] args) {
		
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
		
		
		
		// TODO Auto-generated method stub
		return byteArray;
	}

}
