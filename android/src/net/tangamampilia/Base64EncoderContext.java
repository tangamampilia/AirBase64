package net.tangamampilia;

import net.tangamampilia.functions.*;

import java.util.HashMap;
import java.util.Map;

import com.adobe.fre.FREContext;
import com.adobe.fre.FREFunction;

public class Base64EncoderContext extends FREContext {
	// Public API
	
		@Override
		public void dispose() { }

		@Override
		public Map<String, FREFunction> getFunctions()
		{
			Map<String, FREFunction> functionMap = new HashMap<String, FREFunction>();
			
			functionMap.put("Base64EncoderEncode", new Encode());
			functionMap.put("Base64EncoderDecode", new Decode());
			
			return functionMap;	
		}
		
}
