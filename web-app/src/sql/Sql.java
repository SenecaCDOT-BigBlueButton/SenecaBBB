package sql;

/**
 * For the parameters, please use DB column names
 * Example: setNickName(String bu_id, String bu_nick) 
 *          bu_id and bu_nick are both DB column names
 * <p>
 * SQL Method prefix Legend:<p>
 * 1. (get): simple query<p>
 * 2. (is): query that use SELECT 1 to check existence<p>
 * 3. (default): UPDATE statement that set targeted data back to default values<p>
 * 4. (set): normal UPDATE statement for single field (column)<p>
 * 5. (update): normal UPDATE statement for multiple fields (columns)<p>
 * 6. (create): INSERT INTO<p>
 * 7. (delete): DELETE<p>
 * @author Bo Li
 *
 */
public interface Sql {
    
    public String getErrLog();
    
    public String getSQL();
    
    /**
     * This MUST be called after an error is caught,
     * else no other SQL statements would run
     */
    public boolean resetFlag();
    
}
