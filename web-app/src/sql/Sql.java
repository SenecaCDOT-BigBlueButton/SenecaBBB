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
 * 4. (set): normal UPDATE statement, single column<p>
 * 5. (setMul): UPDATE statement, multi column<p>
 * 6. (update): UPDATE multiple tables using MySQL Stored Procedure (SP) or complex SQL statements
 *    if the method needs to be changed, edit would like be done in SQL script: bbb_db_init.sql<p>
 * 7. (create): INSERT INTO<p>
 * 8. (remove): DELETE<p>
 * @author Kelan (Bo) Li
 *
 */
public interface Sql {
    
    public String getErrLog();
    
    public String getSQL();
    
    /**
     * This MUST be called after an error is caught,
     * else no other SQL statements would run
     */
    public boolean resetErrorFlag();
    
}
