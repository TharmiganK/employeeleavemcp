import ballerinax/oracledb;
import ballerinax/oracledb.driver as _;
import ballerinax/oracledb.driver as _;
import ballerinax/oracledb.driver as _;

final oracledb:Client oracledbClient = check new (string `${dbHost}`, string `${dbuser}`, string `${dbPassword}`, string `${dbName}`, dbPort, {

});
