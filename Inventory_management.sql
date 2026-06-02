create database inventory_management;

use inventory_management; 

create  table Suppliers (
supplier_id int primary key,
supplier_name varchar(50),
contact_name varchar(50)
);

create table Products (
    product_id int primary key,
    product_name varchar(50),
    stock int,
    supplier_id int,
    foreign key  (supplier_id) REFERENCES Suppliers(supplier_id)
);

create table Purchases (
    purchase_id int primary key,
    product_id int,
    quantity int,
    purchase_date date,
    foreign key (product_id) REFERENCES Products(product_id)
);

DELIMITER //

CREATE PROCEDURE PopulateInventoryData()
BEGIN
    DECLARE i INT DEFAULT 1;
    DECLARE rand_supplier INT;
    DECLARE rand_product INT;

    -- 1. INSERT SUPPLIERS (50)
    WHILE i <= 50 DO
        INSERT INTO Suppliers (supplier_id, supplier_name, contact_name)
        VALUES (
            i,
            CONCAT('Supplier_', i),
            CONCAT('Contact_', i)
        );
        SET i = i + 1;
    END WHILE;

    -- RESET COUNTER
    SET i = 1;

    -- 2. INSERT PRODUCTS (500)
    WHILE i <= 500 DO
        SET rand_supplier = FLOOR(1 + (RAND() * 50));

        INSERT INTO Products (product_id, product_name, stock, supplier_id)
        VALUES (
            i,
            CONCAT('Product_', i),
            FLOOR(10 + (RAND() * 200)), -- stock 10–210
            rand_supplier
        );

        SET i = i + 1;
    END WHILE;

    -- RESET COUNTER
    SET i = 1;

    -- 3. INSERT PURCHASES (500)
    WHILE i <= 500 DO
        SET rand_product = FLOOR(1 + (RAND() * 500));

        INSERT INTO Purchases (purchase_id, product_id, quantity, purchase_date)
        VALUES (
            i,
            rand_product,
            FLOOR(1 + (RAND() * 50)), -- quantity 1–50
            DATE_SUB(CURDATE(), INTERVAL FLOOR(RAND() * 365) DAY)
        );

        SET i = i + 1;
    END WHILE;

END //

DELIMITER ;

CALL PopulateInventoryData();

DELIMITER //

CREATE PROCEDURE UpdateProductNames()
BEGIN

    UPDATE Products
    SET product_name = CASE FLOOR(1 + (RAND() * 20))

        WHEN 1 THEN 'Laptop'
        WHEN 2 THEN 'Keyboard'
        WHEN 3 THEN 'Mouse'
        WHEN 4 THEN 'Monitor'
        WHEN 5 THEN 'Printer'
        WHEN 6 THEN 'Router'
        WHEN 7 THEN 'USB Cable'
        WHEN 8 THEN 'Hard Disk'
        WHEN 9 THEN 'SSD'
        WHEN 10 THEN 'Webcam'
        WHEN 11 THEN 'Headphones'
        WHEN 12 THEN 'Speaker'
        WHEN 13 THEN 'Microphone'
        WHEN 14 THEN 'Graphics Card'
        WHEN 15 THEN 'RAM'
        WHEN 16 THEN 'Power Bank'
        WHEN 17 THEN 'Projector'
        WHEN 18 THEN 'Tablet'
        WHEN 19 THEN 'Smartphone'
        WHEN 20 THEN 'Scanner'

    END
    WHERE product_id > 0;

END //

DELIMITER ;


CALL UpdateProductNames();
drop procedure UpdateProductNames;


SELECT * FROM Suppliers;   -- 50
SELECT * FROM Products;    -- 500
SELECT * FROM Purchases;   -- 500

-- - WHERE stock > 10. 
select  product_name, stock 
from Products 
where stock > 10;

-- - JOIN → supplier with product details.
 select 
 s.supplier_name,
 s.contact_name,
 p.product_name,
 p.stock
 from Suppliers s
 join Products p
 on s.supplier_id = p.supplier_id;
 
 --  GROUP BY → stock per supplier.
 select 
 s.supplier_name,
 sum(p.stock) as total_stock
 from Suppliers s
 join Products p
on s.supplier_id = p.product_id
group by s.supplier_name;

