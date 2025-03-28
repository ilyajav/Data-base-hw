WITH RECURSIVE ManagerHierarchy AS (
    SELECT 
        e.EmployeeID,
        e.Name,
        e.ManagerID,
        e.DepartmentID,
        e.RoleID,
        r.RoleName
    FROM 
        Employees e
    JOIN 
        Roles r ON e.RoleID = r.RoleID
    WHERE 
        r.RoleName = 'Менеджер'

    UNION ALL

    SELECT 
        e.EmployeeID,
        e.Name,
        e.ManagerID,
        e.DepartmentID,
        e.RoleID,
        r.RoleName
    FROM 
        Employees e
    JOIN 
        Roles r ON e.RoleID = r.RoleID
    JOIN 
        ManagerHierarchy mh ON e.ManagerID = mh.EmployeeID
),
ManagerSubordinates AS (
    SELECT 
        mh.EmployeeID AS ManagerID,
        COUNT(DISTINCT e.EmployeeID) AS TotalSubordinates
    FROM 
        ManagerHierarchy mh
    LEFT JOIN 
        Employees e ON mh.EmployeeID = e.ManagerID
    GROUP BY 
        mh.EmployeeID
)

SELECT 
    mh.EmployeeID AS EmployeeID,
    mh.Name AS EmployeeName,
    mh.ManagerID AS ManagerID,
    d.DepartmentName AS DepartmentName,
    mh.RoleName AS RoleName,
    STRING_AGG(DISTINCT p.ProjectName, ', ') AS ProjectNames,
    STRING_AGG(DISTINCT t.TaskName, ', ') AS TaskNames,
    COALESCE(ms.TotalSubordinates, 0) AS TotalSubordinates
FROM 
    ManagerHierarchy mh
LEFT JOIN 
    Departments d ON mh.DepartmentID = d.DepartmentID
LEFT JOIN 
    Projects p ON mh.DepartmentID = p.DepartmentID
LEFT JOIN 
    Tasks t ON mh.EmployeeID = t.AssignedTo
LEFT JOIN 
    ManagerSubordinates ms ON mh.EmployeeID = ms.ManagerID
GROUP BY 
    mh.EmployeeID, mh.Name, mh.ManagerID, d.DepartmentName, mh.RoleName, ms.TotalSubordinates
HAVING 
    COALESCE(ms.TotalSubordinates, 0) > 0
ORDER BY 
    mh.Name ASC;
