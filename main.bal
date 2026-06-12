import ballerina/log;
import ballerina/mcp;
import ballerina/sql;

listener mcp:Listener mcpListener = new (listenTo = 8083, http1Settings = {

}, httpVersion = "1.1");

@mcp:ServiceConfig {
    info: {
        name: "EmployeeData",
        version: "1.0.0"
    }
}
service mcp:Service /employeeData on mcpListener {

    # "Returns the authenticated employee name and the number of PTOs the employee has already taken"
    #
    # + name - Name of the employee
    # + return - UsedLeaves
    remote function getUsedLeaves(string name) returns UsedLeaves {
        log:printInfo("Executing getUsedLeaves for employee: " + name);
        record {|int used_pto_days;|}|sql:Error queryResult =
            oracledbClient->queryRow(`SELECT USED_PTO_DAYS FROM EMPLOYEE_PTO WHERE EMPLOYEE_NAME = ${name}`);
        if queryResult is sql:Error {
            log:printError("DB query failed in getUsedLeaves: " + queryResult.message());
            return {name: name, numberOfLeavesUsed: 0};
        }
        int usedPtoDays = queryResult.used_pto_days;
        log:printInfo("Successfully returning USED_PTO_DAYS=" + usedPtoDays.toString() + " for employee: " + name);
        return {name: name, numberOfLeavesUsed: usedPtoDays};
    }

    # "Returns the authenticated employee name and the number of years the employee has worked in the company so far"
    #
    # + name - Name of the employee
    # + return - EmploymentHistory
    remote function getEmployemntHistory(string name) returns EmploymentHistory {
        log:printInfo("Executing getEmployemntHistory for employee: " + name);
        record {|int years_worked;|}|sql:Error queryResult =
            oracledbClient->queryRow(`SELECT YEARS_WORKED FROM EMPLOYEE_PTO WHERE EMPLOYEE_NAME = ${name}`);
        if queryResult is sql:Error {
            log:printError("DB query failed in getEmployemntHistory: " + queryResult.message());
            return {name: name, lengthOfEmployment: 0};
        }
        int yearsWorked = queryResult.years_worked;
        log:printInfo("Successfully returning YEARS_WORKED=" + yearsWorked.toString() + " for employee: " + name);
        return {name: name, lengthOfEmployment: yearsWorked};
    }

}

