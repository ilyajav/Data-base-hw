WITH RECURSIVE EmployeeHierarchy AS (

    SELECT 
        EmployeeID,
        Name,
        ManagerID,
        DepartmentID,
        RoleID
    FROM 
        Employees
    WHERE 
        EmployeeID = 1

    UNION ALL


    SELECT 
        e.EmployeeID,
        e.Name,
        e.ManagerID,
        e.DepartmentID,
        e.RoleID
    FROM 
        Employees e
    INNER JOIN 
        EmployeeHierarchy eh ON e.ManagerID = eh.EmployeeID
)

SELECT 
    eh.EmployeeID AS EmployeeID,
    eh.Name AS EmployeeName,
    eh.ManagerID AS ManagerID,
    d.DepartmentName AS DepartmentName,
    r.RoleName AS RoleName,
    STRING_AGG(DISTINCT p.ProjectName, ', ') AS ProjectNames,
    STRING_AGG(DISTINCT t.TaskName, ', ') AS TaskNames
FROM 
    EmployeeHierarchy eh
LEFT JOIN 
    Departments d ON eh.DepartmentID = d.DepartmentID
LEFT JOIN 
    Roles r ON eh.RoleID = r.RoleID
LEFT JOIN 
    Projects p ON eh.DepartmentID = p.DepartmentID
LEFT JOIN 
    Tasks t ON eh.EmployeeID = t.AssignedTo
GROUP BY 
    eh.EmployeeID, eh.Name, eh.ManagerID, d.DepartmentName, r.RoleName
ORDER BY 
    eh.Name ASC;
