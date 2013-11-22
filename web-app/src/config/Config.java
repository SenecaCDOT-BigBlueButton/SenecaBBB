/**
 * 
 */
package config;

import java.io.FileInputStream;
import java.io.IOException;
import java.io.InputStream;
import java.util.Properties;

/**
 * @author ramone
 *
 */
@SuppressWarnings("all")
public class Config {
	private final String CONFILE_FILE = "config.properties";
	static Properties properties = new Properties();
	static{
		Config obj = new Config();
		obj.loadProperties();    
	}

	public void loadProperties(){
		try{
			properties.load(getClass().getResourceAsStream(CONFILE_FILE));
		}catch(IOException e){
			System.out.println(e.getMessage());
		}
	}

	static public String getProperty(String key){
		return properties.getProperty(key);
	}
}
