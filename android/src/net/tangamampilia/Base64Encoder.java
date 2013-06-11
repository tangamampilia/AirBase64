package net.tangamampilia;

import com.adobe.fre.FREContext;
import com.adobe.fre.FREExtension;

public class Base64Encoder implements FREExtension {

	public static Base64EncoderContext context;
	
	public FREContext createContext(String extId)
	{
		context = new Base64EncoderContext();
		return context;
	}
	
	public void initialize() { }

	public void dispose()
	{
		context = null;
	}
	
	public static void log(String message)
	{
		context.dispatchStatusEventAsync("LOGGING", message);
	}

}
