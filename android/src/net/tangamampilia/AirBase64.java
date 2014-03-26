package net.tangamampilia;

import com.adobe.fre.FREContext;
import com.adobe.fre.FREExtension;

public class AirBase64 implements FREExtension {

	public static AirBase64Context context;
	
	public FREContext createContext(String extId)
	{
		context = new AirBase64Context();
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
