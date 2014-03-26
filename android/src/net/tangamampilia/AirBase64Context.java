package net.tangamampilia;

import net.tangamampilia.functions.*;

import java.util.HashMap;
import java.util.Map;

import com.adobe.fre.FREContext;
import com.adobe.fre.FREFunction;

public class AirBase64Context extends FREContext {
	// Public API
	
		@Override
		public void dispose() { }

		@Override
		public Map<String, FREFunction> getFunctions() {
			Map<String, FREFunction> functionMap = new HashMap<String, FREFunction>();
			
			functionMap.put("AirBase64Encode", new AirBase64Functions("Encode"));
			functionMap.put("AirBase64Decode", new AirBase64Functions("Decode"));
			
			return functionMap;	
		}
		
}
