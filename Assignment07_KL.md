**Name:** Kurt L  
**Date:** 08/27/2022  
**Course:** IT FDN 130 A  
***
# Assignment07. Functions

## Introduction
This document discusses user-defined functions, when they are used, and the different types. The first section provides a description of three common use cases for user-defined functions and the benefits they offer. The second goes into more detail on the two different types of user-defined functions and how each is used.

## When to Use User-Defined Functions
User-defined functions are flexible tools that can be used in many ways. Three main uses for user-defined functions are: 1) to create modular code for efficiency, 2) as a pre-defined result set of table data, and 3) to reference other tables in a check constraint. While these examples do not represent all uses for user-defined functions, they provide an overview of common ways in which these functions are often used.

In the first use case, a function enables one to write a set of SQL code that can then be used repeatedly by many users working with the database. This is a useful feature when working with complex calculations. A single function will act as a source of truth when calculating a key performance indicator (KPI) to ensure different users all leverage the same calculation. In addition, by accepting parameters, user-defined functions make it easy to extract variations of results sets based on a specific value (e.g., returning total orders for a region by adjusting a country ID parameter).

Secondly, functions offer an alternative to creating table views. Like a view, functions can return a pre-defined result set that can be used by many other database users. While the process is slightly more complex, it is an additional way to create a specific result set that can be shared among users. It also offers the added benefit of including parameters that users can adjust to alter the result set.

Finally, user-defined functions provide a way to reference a column from a different table in the database as part of a check constraint. While this cannot be done with a check constraint by default, using a function that includes the column allows users more flexibility when constructing these constraints.

## Types od User-Defined Functions
There are two types of user-defined functions: scalar functions and table-valued functions. As the names suggest, scalar functions return a specific value while table-valued functions return a result set. Scalar functions can be used by themselves in a SELECT statement to return the single value itself or with other clauses to calculate values for each row returned in a result set. Table-valued functions return a result set and are references like how other table objects are referenced in the FROM clause.

Diving deeper, table-valued functions can further be divided into two sub-types: in-line and multi-statement. In-line table-valued functions are the simpler of the two sub-types. They return a result set based on defined parameters used in a pre-built SELECT statement. Multi-statement table-valued functions are more complex and return a result set based on defined parameters and a table created within the function itself.

## Summary
As discussed in the sections above, user-defined functions are SQL tools that enable users to share calculations, create pre-defined result sets, and work with more complex constraints. The two primary flavors of user-defined functions are scalar functions and table-valued functions. Each type of function offers unique benefits that can be used in a variety of different situations. 

## References
“User-defined functions.” Microsoft, 29 June 2022, https://docs.microsoft.com/en-us/sql/relational-databases/user-defined-functions/user-defined-functions?view=sql-server-ver16 (external site).

Brown, Andy. “Simple (in-line) table-valued functions.” Wise Owl Training, Wise Owl Business Solutions Ltd., 08 February 2013, https://www.wiseowl.co.uk/blog/s347/in-line.htm (external site).

Drkusic, Emil. “Learn SQL: User-Defined Functions.” SQLShack, Quest Software Inc., 25 February 2020, https://www.sqlshack.com/learn-sql-user-defined-functions/ (external site).
