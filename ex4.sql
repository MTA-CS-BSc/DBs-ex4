-- Maya Raskin, 209372325

-- Q1
SELECT id, fname, lname
FROM Customer
WHERE fname LIKE '%t';

-- Q2
SELECT id, fname, lname
FROM Customer
WHERE id > (
	SELECT MAX(id)
	FROM Customer
	WHERE state='CA'
);

-- Q3
SELECT ct.id, fname, lname
FROM Customer ct
WHERE ct.id NOT IN (
	SELECT DISTINCT Customer.id
	FROM Sales_Order
	INNER JOIN Customer ON cust_id = Customer.id
	-- WHERE DATE_PART('year', order_date) != '1993'
	WHERE STRFTIME('%Y', order_date) != 1993
);

-- Q4
SELECT id, fname, lname
FROM Customer
WHERE id NOT IN (
	SELECT DISTINCT cust_id AS id
	FROM Sales_Order
);

-- Q5
SELECT DISTINCT Product.id, Product.name, Product.description
FROM Sales_Order_Items
NATURAL JOIN Sales_Order
INNER JOIN Product ON Product.id = prod_id
WHERE ship_date < order_date;

-- Q6
SELECT DISTINCT Product.id, Product.name, Product.description
FROM Sales_Order_Items
NATURAL JOIN Sales_Order
INNER JOIN Customer ON Customer.id = cust_id
INNER JOIN Product ON Product.id = prod_id
WHERE lname LIKE 'R%';

-- TODO
-- Q7
SELECT DISTINCT id, fname, lname
FROM Customer WHERE id NOT IN (
    SELECT DISTINCT cust_id AS id
    FROM Sales_Order_Items
    NATURAL JOIN Sales_Order
    INNER JOIN Product ON Product.id = prod_id
    WHERE Product.name LIKE '%shirt%'
) AND id IN (
    SELECT DISTINCT cust_id AS id
    FROM Sales_Order_Items
    NATURAL JOIN Sales_Order
    INNER JOIN Product ON Product.id = prod_id
    WHERE Product.name NOT LIKE '%shirt%'
);

-- Q8 - Does not exist

-- Q9
SELECT department.dept_id, dept_name, COUNT(*) AS workers_count, AVG(salary) AS dept_avg_salary
FROM employee
NATURAL JOIN department
GROUP BY department.dept_id;

-- Q10
SELECT emp_id, emp_fname, emp_lname, COUNT(*) AS sales_amount
FROM Sales_Order
INNER JOIN Employee ON emp_id = sales_rep
GROUP BY emp_id;

-- Q11
SELECT order_date AS latest_order_date
FROM Sales_Order
ORDER BY order_date DESC
LIMIT 1;

-- Q12
SELECT state AS state_with_most_customers
FROM Customer
GROUP BY state_with_most_customers
ORDER BY COUNT(*) DESC
LIMIT 1;

-- Q13
SELECT DISTINCT Customer.id, fname, lname, COUNT(*)
FROM Sales_Order
INNER JOIN Customer ON cust_id = Customer.id
GROUP BY Customer.id
HAVING Customer.id IN (
    SELECT DISTINCT cust_id AS id
    FROM Sales_Order
    INNER JOIN Customer ON cust_id = Customer.id
    WHERE sales_rep = 129
);

-- Q14.1
CREATE VIEW TotalPerOrder AS
    SELECT Sales_Order_Items.id, Sales_Order.cust_id, SUM(Product.unit_price * Sales_Order_Items.quantity) AS order_total
    FROM Sales_Order_Items
    INNER JOIN Sales_Order ON Sales_Order.id = Sales_Order_Items.id
    INNER JOIN Product ON prod_id = Product.id
    GROUP BY Sales_Order_Items.id, Sales_Order.cust_id;

-- Q14.2
SELECT SUM(order_total)
FROM TotalPerOrder
WHERE cust_id = 129;

-- TODO
-- Q15.1
CREATE VIEW EmployeeAge AS
    SELECT emp_id, dept_id, emp_fname, emp_lname, STRFTIME('%F', (DATE('now') - birth_date)) AS emp_age
    FROM Employee;

-- Q15.2
SELECT dept_id, dept_name, AVG(emp_age)
FROM EmployeeAge
NATURAL JOIN Department
GROUP BY dept_id;

-- Q16
CREATE TABLE supplier (
    id INTEGER NOT NULL,
    supplier_name VARCHAR(30) NOT NULL,
    address VARCHAR(30),
    city VARCHAR(20),
    country VARCHAR(20),
    phone VARCHAR(20),   
    PRIMARY KEY (id)
);

-- Q17
INSERT INTO supplier (id, supplier_name, address, city, country, phone) VALUES
(1, 'ABC Supplies', '123 Main Street', 'New York', 'USA', '+1-555-123-4567'),
(2, 'XYZ Company', '456 Oak Avenue', 'Los Angeles', 'USA', '+1-555-987-6543'),
(3, 'Global Imports', '789 Elm Road', 'London', 'UK', '+44-20-1234-5678'),
(4, 'Quality Products', '101 Pine Lane', 'Sydney', 'Australia', '+61-2-9876-5432'),
(5, 'Best Goods Co.', '555 Maple Drive', 'Toronto', 'Canada', '+1-416-555-1234');

SELECT * FROM Supplier;

-- Q18
SELECT '209372325' AS id, 'Maya' AS f_name, 'Raskin' AS l_name;