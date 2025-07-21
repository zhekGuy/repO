DROP TABLE itemcategory CASCADE CONSTRAINTS;
DROP TABLE menuItem CASCADE CONSTRAINTS;
DROP TABLE item CASCADE CONSTRAINTS;
DROP TABLE supplier CASCADE CONSTRAINTS;
DROP TABLE staffRole CASCADE CONSTRAINTS;
DROP TABLE staff CASCADE CONSTRAINTS;
DROP TABLE ingredients CASCADE CONSTRAINTS;
DROP TABLE customers CASCADE CONSTRAINTS;
DROP TABLE orders CASCADE CONSTRAINTS;
DROP TABLE feedback CASCADE CONSTRAINTS;
DROP TABLE itemIngredients CASCADE CONSTRAINTS;
DROP TABLE itemConfig CASCADE CONSTRAINTS;
DROP TABLE staffItem CASCADE CONSTRAINTS;
DROP TABLE orderDetails CASCADE CONSTRAINTS;

CREATE TABLE itemcategory (
    categoryID CHAR(3) PRIMARY KEY,
    categoryName VARCHAR(20) UNIQUE NOT NULL
);

CREATE TABLE menuItem (
    menuItemID CHAR(6) PRIMARY KEY,
    menuItemName VARCHAR(30) UNIQUE NOT NULL,
    MenuItemDescription VARCHAR(100) NOT NULL,
    MenuItemPrice NUMERIC (4,2) NOT NULL,
    categoryID CHAR(3),
    FOREIGN KEY (categoryID) REFERENCES itemcategory(categoryID)
);

CREATE TABLE item (
    itemID CHAR(4) PRIMARY KEY,
    itemName VARCHAR(30) UNIQUE NOT NULL
);

CREATE TABLE supplier (
    supplierID CHAR(4) PRIMARY KEY,
    supplierName VARCHAR(30) UNIQUE NOT NULL,
    supplierContact VARCHAR(20) NOT NULL
);

CREATE TABLE staffRole (
    roleID CHAR(4) PRIMARY KEY,
    roleName VARCHAR(20) UNIQUE NOT NULL
);

CREATE TABLE staff (
    staffID CHAR(4) PRIMARY KEY,
    staffName VARCHAR(30) UNIQUE NOT NULL,
    roleID CHAR(4),
    staffContact VARCHAR(20) UNIQUE NOT NULL,
    age INT NOT NULL,
    hireDate DATE DEFAULT CURRENT_DATE, -- ensures staff hire date is recorded
    CONSTRAINT chk_age CHECK (age >= 18), -- ensures staff is of legal age to attain employment
    FOREIGN KEY (roleID) REFERENCES staffRole(roleID)
);

CREATE TABLE ingredients (
    ingredientID CHAR(5) PRIMARY KEY,
    ingredientName VARCHAR(30) UNIQUE NOT NULL,
    quantity INT NOT NULL,
    reorderPoint INT NOT NULL,
    supplierID CHAR(4),
    FOREIGN KEY (supplierID) REFERENCES supplier(supplierID)
);

CREATE TABLE customers (
    customerID CHAR(4) PRIMARY KEY,
    customerName VARCHAR(30) NOT NULL,
    CustomerContact VARCHAR(20) UNIQUE NOT NULL
);

CREATE TABLE orders (
    orderID CHAR(5) PRIMARY KEY,
    customerID CHAR(4),
    orderType VARCHAR(20) NOT NULL,
    orderDate DATE DEFAULT CURRENT_DATE, -- ensures current date is entered if not entered
    staffID CHAR(4),  
    paymentStatus VARCHAR(20) NOT NULL,
    CONSTRAINT chk_order_type CHECK (orderType IN ('Dine In', 'Take Away')), -- Check parameters of order type 
    CONSTRAINT chk_cashier CHECK (staffID IN ('ST10', 'ST11')), -- checks staff role 
    CONSTRAINT chk_payment_status CHECK (paymentStatus IN ('Paid', 'Cancelled')), -- check parameters of payment status
    FOREIGN KEY (customerID) REFERENCES customers(customerID),
    FOREIGN KEY (staffID) REFERENCES staff(staffID)
);

CREATE TABLE feedback (
    feedbackID CHAR(5) PRIMARY KEY,
    orderID CHAR(5),
    content VARCHAR(180),
    rating NUMERIC(2,1) NOT NULL,
    CONSTRAINT chk_rating CHECK (rating BETWEEN 0 AND 5),
    FOREIGN KEY (orderID) REFERENCES orders(orderID)
);

CREATE TABLE itemIngredients (
    itemID CHAR(4),
    ingredientID CHAR(5),
    PRIMARY KEY (itemID, ingredientID),
    FOREIGN KEY (itemID) REFERENCES item(itemID),
    FOREIGN KEY (ingredientID) REFERENCES ingredients(ingredientID)
);

CREATE TABLE itemConfig (
    menuItemID CHAR(6),
    itemID CHAR(4),
    PRIMARY KEY (menuItemID, itemID),
    FOREIGN KEY (menuItemID) REFERENCES menuItem(menuItemID),
    FOREIGN KEY (itemID) REFERENCES item(itemID)
);

CREATE TABLE staffItem (
    staffID CHAR(4),
    itemID CHAR(4),
    CONSTRAINT chk_cook CHECK (staffID IN ('ST04', 'ST05', 'ST06', 'ST07', 'ST08', 'ST09')), -- checks staff role 
    PRIMARY KEY (staffID, itemID),
    FOREIGN KEY (staffID) REFERENCES staff(staffID),
    FOREIGN KEY (itemID) REFERENCES item(itemID)
);

CREATE TABLE orderDetails (
    orderID CHAR(5),
    menuItemID CHAR(6),
    quantity int NOT NULL,
    FOREIGN KEY (orderID) REFERENCES orders(orderID),
    FOREIGN KEY (menuItemID) REFERENCES menuitem(menuItemID)
);


-- categories (categoryID, categoryName)
INSERT INTO itemcategory VALUES ('CT1', 'Burgers & Sandiwches');
INSERT INTO itemcategory VALUES ('CT2', 'Sides');
INSERT INTO itemcategory VALUES ('CT3', 'Beverage');
INSERT INTO itemcategory VALUES ('CT4', 'Dessert');
INSERT INTO itemcategory VALUES ('CT5', 'Fried Chicken');
INSERT INTO itemcategory VALUES ('CT6', 'Wraps');
INSERT INTO itemcategory VALUES ('CT7', 'Specials');
INSERT INTO itemcategory VALUES ('CT8', 'Combo');

-- menu items (menuItemID, menuItemName, MenuItemDescription, MenuItemPrice, menuID, categoryID)
--Burgers & Sandiwches
INSERT INTO menuItem VALUES ('MI01', 'Chicken Burger', 'Juicy chicken patty with fresh toppings', 4.99, 'CT1');
INSERT INTO menuItem VALUES ('MI02', 'Cheeseburger', 'Classic cheeseburger with cheddar cheese', 5.49, 'CT1');
INSERT INTO menuItem VALUES ('MI03', 'Spicy Chicken Sandwich', 'Spicy chicken sandwich with zesty sauce', 6.49, 'CT1');
INSERT INTO menuItem VALUES ('MI04', 'Jumbo Chicken Burger', 'Extra-large chicken burger with double patty', 7.99, 'CT1');
INSERT INTO menuItem VALUES ('MI05', 'Jumbo Cheeseburger', 'Extra-large cheeseburger with double cheddar', 8.49, 'CT1');
INSERT INTO menuItem VALUES ('MI06', 'Crispy Fish Burger', 'Crispy fish patty with tartar sauce', 6.99, 'CT1');
INSERT INTO menuItem VALUES ('MI07', 'Egg Muffin', 'Freshly made egg muffin with cheese', 3.99, 'CT1');
INSERT INTO menuItem VALUES ('MI08', 'Burrito', 'Flavorful burrito with beans and cheese', 4.49, 'CT6');
INSERT INTO menuItem VALUES ('MI09', 'King-sized Sandwich', 'Large sandwich with premium fillings', 10.99, 'CT1');
--Sides
INSERT INTO menuItem VALUES ('MI10', 'French Fries', 'Golden crispy French fries', 2.99, 'CT2');
INSERT INTO menuItem VALUES ('MI11', 'Chicken Nuggets', 'Crispy chicken nuggets with dipping sauce', 3.99, 'CT2');
INSERT INTO menuItem VALUES ('MI12', 'Hash Browns', 'Golden brown hash browns', 1.99, 'CT2');
--Fried Chicken
INSERT INTO menuItem VALUES ('MI13', 'Fried Chicken', 'Crispy fried chicken with seasoning', 6.99, 'CT5');
INSERT INTO menuItem VALUES ('MI14', 'Spicy Fried Chicken', 'Spicy crispy fried chicken with chili seasoning', 7.49, 'CT5');
--Drinks 
INSERT INTO menuItem VALUES ('MI15', 'Soft Drink', 'Chilled carbonated beverage', 1.99, 'CT3');
INSERT INTO menuItem VALUES ('MI16', 'Orange Juice', 'Freshly squeezed orange juice', 2.49, 'CT3');
INSERT INTO menuItem VALUES ('MI17', 'Coffee', 'Freshly brewed coffee', 2.99, 'CT3');
--Dessert
INSERT INTO menuItem VALUES ('MI18', 'Sponge Cake', 'Light and fluffy sponge cake slice', 3.49, 'CT4');
INSERT INTO menuItem VALUES ('MI19', 'Ice Cream', 'Creamy vanilla ice cream scoop', 2.99, 'CT4');
INSERT INTO menuItem VALUES ('MI20', 'Glazed Donut', 'Sweet glazed donut with a soft texture', 1.99, 'CT4');

-- food items (itemID, itemName)
INSERT INTO item VALUES ('IT01', 'Chicken Burger');
INSERT INTO item VALUES ('IT02', 'Cheeseburger');
INSERT INTO item VALUES ('IT03', 'Spicy Chicken Sandwich');
INSERT INTO item VALUES ('IT04', 'Jumbo Chicken Burger');
INSERT INTO item VALUES ('IT05', 'Jumbo Cheeseburger');
INSERT INTO item VALUES ('IT06', 'Crispy Fish Burger');
INSERT INTO item VALUES ('IT07', 'Egg Muffin');
INSERT INTO item VALUES ('IT08', 'Burrito');
INSERT INTO item VALUES ('IT09', 'King-sized Sandiwch');
INSERT INTO item VALUES ('IT10', 'French Fries');
INSERT INTO item VALUES ('IT11', 'Chicken Nuggets');
INSERT INTO item VALUES ('IT12', 'Hash Browns');
INSERT INTO item VALUES ('IT13', 'Fried Chicken');
INSERT INTO item VALUES ('IT14', 'Spicy Fried Chicken');
INSERT INTO item VALUES ('IT15', 'Soft Drink');
INSERT INTO item VALUES ('IT16', 'Orange Juice');
INSERT INTO item VALUES ('IT17', 'Coffee');
INSERT INTO item VALUES ('IT18', 'Sponge Cake');
INSERT INTO item VALUES ('IT19', 'Ice Cream');
INSERT INTO item VALUES ('IT20', 'Glazed Donut');

-- suppliers (supplierID, supplierName, supplierContact)
INSERT INTO supplier VALUES ('SP01', 'Balkan Buns', '+60 12-987 6543');
INSERT INTO supplier VALUES ('SP02', 'Deli Meats', '+60 16-432 1986');
INSERT INTO supplier VALUES ('SP03', 'Le Grocer', '+60 11-5678 123');
INSERT INTO supplier VALUES ('SP04', 'Condiment King', '+60 19-345 6781');
INSERT INTO supplier VALUES ('SP05', 'Raw Goodies', '+60 17-890 1235');
INSERT INTO supplier VALUES ('SP06', 'Coffee Nut', '+60 13-2233 446');
INSERT INTO supplier VALUES ('SP07', 'Based Creams', '+60 10-1122 334');
INSERT INTO supplier VALUES ('SP08', 'Market Toledo', '+60 14-678 9012');

-- staffroles (roleID, roleName)
INSERT INTO staffRole VALUES ('SR01', 'General Manager');
INSERT INTO staffRole VALUES ('SR02', 'Assistant Manager');
INSERT INTO staffRole VALUES ('SR03', 'Expeditor');
INSERT INTO staffRole VALUES ('SR04', 'Cook');
INSERT INTO staffRole VALUES ('SR05', 'Beverage Handler');
INSERT INTO staffRole VALUES ('SR06', 'Cashier');
INSERT INTO staffRole VALUES ('SR07', 'Sanitation');
INSERT INTO staffRole VALUES ('SR08', 'Maintenance');


-- staff members (staffID, staffName, staffRole, stafontact, age, hireDate)
INSERT INTO staff VALUES ('ST01', 'Don Johnson', 'SR01', '+60 12-345 6789', 36, TO_DATE('2023-11-15', 'YYYY-MM-DD'));
INSERT INTO staff VALUES ('ST02', 'Gary Stu', 'SR02', '+60 19-876 5432', 24, TO_DATE('2023-12-01', 'YYYY-MM-DD'));
INSERT INTO staff VALUES ('ST03', 'Guy Fawkes', 'SR03', '+60 11-2233 4455', 34, TO_DATE('2023-12-05', 'YYYY-MM-DD'));
INSERT INTO staff VALUES ('ST04', 'Jane Doe', 'SR04', '+60 16-789 1234', 22, TO_DATE('2023-12-03', 'YYYY-MM-DD'));
INSERT INTO staff VALUES ('ST05', 'Joe Schmoe', 'SR04', '+60 17-654 3210', 27, TO_DATE('2023-11-20', 'YYYY-MM-DD'));
INSERT INTO staff VALUES ('ST06', 'Plain Jane', 'SR04', '+60 10-9988 7766', 30, TO_DATE('2023-12-07', 'YYYY-MM-DD'));
INSERT INTO staff VALUES ('ST07', 'Mary Sue', 'SR04', '+60 18-432 1987', 25, TO_DATE('2023-12-02', 'YYYY-MM-DD'));
INSERT INTO staff VALUES ('ST08', 'Clean Jean', 'SR04', '+60 13-567 8901', 26, TO_DATE('2023-11-28', 'YYYY-MM-DD'));
INSERT INTO staff VALUES ('ST09', 'Mars Carr', 'SR05', '+60 14-345 6782', 32, TO_DATE('2023-12-06', 'YYYY-MM-DD'));
INSERT INTO staff VALUES ('ST10', 'Jesus Hernandez', 'SR06', '+60 15-876 5439', 35, TO_DATE('2023-11-30', 'YYYY-MM-DD'));
INSERT INTO staff VALUES ('ST11', 'Gus White', 'SR06', '+60 12-965 4529', 35, TO_DATE('2023-05-22', 'YYYY-MM-DD'));
INSERT INTO staff VALUES ('ST12', 'Bob Marley', 'SR07', '+60 15-892 4354', 35, TO_DATE('2023-09-28', 'YYYY-MM-DD'));
INSERT INTO staff VALUES ('ST13', 'Bonnie Clyde', 'SR08', '+60 12-564 8984', 35, TO_DATE('2023-04-12', 'YYYY-MM-DD'));


-- ingredients (ingredientID, ingredientName, quantity, reorderPoint, supplierID)
INSERT INTO ingredients VALUES ('ING01', 'Bun', 189, 200, 'SP01');
INSERT INTO ingredients VALUES ('ING02', 'Burrito Wrap', 300, 150, 'SP01');
INSERT INTO ingredients VALUES ('ING03', 'Chicken Patty', 170, 200, 'SP02');
INSERT INTO ingredients VALUES ('ING04', 'Ground Beef', 450, 250, 'SP02');
INSERT INTO ingredients VALUES ('ING05', 'Fish Fillet', 350, 150, 'SP02');
INSERT INTO ingredients VALUES ('ING06', 'Lettuce', 600, 300, 'SP03');
INSERT INTO ingredients VALUES ('ING07', 'Tomato', 500, 200, 'SP03');
INSERT INTO ingredients VALUES ('ING08', 'Onions', 550, 250, 'SP03');
INSERT INTO ingredients VALUES ('ING09', 'Pickles', 400, 150, 'SP03');
INSERT INTO ingredients VALUES ('ING10', 'Cheese', 300, 100, 'SP03');
INSERT INTO ingredients VALUES ('ING11', 'Potato', 289, 300, 'SP03');
INSERT INTO ingredients VALUES ('ING12', 'Oranges', 600, 250, 'SP03');
INSERT INTO ingredients VALUES ('ING13', 'Ketchup', 500, 200, 'SP04');
INSERT INTO ingredients VALUES ('ING14', 'BBQ Sauce', 400, 150, 'SP04');
INSERT INTO ingredients VALUES ('ING15', 'Mustard', 350, 120, 'SP04');
INSERT INTO ingredients VALUES ('ING16', 'Chilli Sauce', 300, 100, 'SP04');
INSERT INTO ingredients VALUES ('ING17', 'Black Pepper', 250, 100, 'SP04');
INSERT INTO ingredients VALUES ('ING18', 'Chocolate Chips', 200, 100, 'SP04'); 
INSERT INTO ingredients VALUES ('ING19', 'Sugar', 450, 150, 'SP05');
INSERT INTO ingredients VALUES ('ING20', 'Eggs', 600, 300, 'SP05');
INSERT INTO ingredients VALUES ('ING21', 'Flour', 500, 200, 'SP05');
INSERT INTO ingredients VALUES ('ING22', 'Red Chilli Paste', 300, 100, 'SP05');
INSERT INTO ingredients VALUES ('ING23', 'Mint Leaves', 150, 80, 'SP06');
INSERT INTO ingredients VALUES ('ING24', 'Creamer', 350, 120, 'SP06');
INSERT INTO ingredients VALUES ('ING25', 'Syrup', 40, 60, 'SP06');
INSERT INTO ingredients VALUES ('ING26', 'Coffee Beans', 400, 200, 'SP06');
INSERT INTO ingredients VALUES ('ING27', 'Ice Cream Base', 300, 150, 'SP07');
INSERT INTO ingredients VALUES ('ING28', 'Vanilla Extract', 100, 50, 'SP07');

-- customers (customerID, customerName, customerContact)
INSERT INTO customers VALUES ('CT01', 'Ahmad Ali', '+60 12-345 6789');
INSERT INTO customers VALUES ('CT02', 'Siti Aminah', '+60 19-876 5432');
INSERT INTO customers VALUES ('CT03', 'Lim Kok Wing', '+60 11-223 3445');
INSERT INTO customers VALUES ('CT04', 'Tan Mei Lin', '+60 16-789 1234');
INSERT INTO customers VALUES ('CT05', 'Rajesh Kumar', '+60 10-998 8776');
INSERT INTO customers VALUES ('CT06', 'Nur Aisyah', '+60 17-654 3210');
INSERT INTO customers VALUES ('CT07', 'Chong Wei', '+60 18-432 1987');
INSERT INTO customers VALUES ('CT08', 'Zainal Abidin', '+60 13-567 8901');
INSERT INTO customers VALUES ('CT09', 'Sarah Tan', '+60 14-345 6782');
INSERT INTO customers VALUES ('CT10', 'Hamidah Ali', '+60 15-876 5439');
INSERT INTO customers VALUES ('CT11', 'Farah Nabilah', '+60 12-654 3321');
INSERT INTO customers VALUES ('CT12', 'Mohd Hafiz', '+60 19-332 4455');
INSERT INTO customers VALUES ('CT13', 'Wong Tze Hao', '+60 11-123 4567');
INSERT INTO customers VALUES ('CT14', 'Ravi Chandran', '+60 16-234 5678');
INSERT INTO customers VALUES ('CT15', 'Aina Syafiqah', '+60 10-998 3344');
INSERT INTO customers VALUES ('CT16', 'Tan Boon Keat', '+60 17-765 4321');
INSERT INTO customers VALUES ('CT17', 'Lim Ah Long', '+60 18-321 6543');
INSERT INTO customers VALUES ('CT18', 'Siti Nurhaliza', '+60 13-111 2223');
INSERT INTO customers VALUES ('CT19', 'Azman Idris', '+60 14-222 3334');
INSERT INTO customers VALUES ('CT20', 'Leong Kai Lun', '+60 15-333 4445');
INSERT INTO customers VALUES ('CT21', 'Sharifah Aisyah', '+60 12-444 5556');
INSERT INTO customers VALUES ('CT22', 'Gopal Krishnan', '+60 19-555 6667');
INSERT INTO customers VALUES ('CT23', 'Shahrul Nizam', '+60 11-666 7778');
INSERT INTO customers VALUES ('CT24', 'Chan Wei Jie', '+60 16-777 8889');
INSERT INTO customers VALUES ('CT25', 'Suriani Adibah', '+60 10-888 9990');
INSERT INTO customers VALUES ('CT26', 'Roslan Ahmad', '+60 17-999 1111');
INSERT INTO customers VALUES ('CT27', 'Tan Chee Wei', '+60 18-111 2222');
INSERT INTO customers VALUES ('CT28', 'Nur Iman', '+60 13-222 3333');
INSERT INTO customers VALUES ('CT29', 'John West', '+60 14-256 3329');
INSERT INTO customers VALUES ('CT30', 'Brad Gan', '+60 12-321 9675');
INSERT INTO customers VALUES ('CT31', 'Ali Zain', '+60 12-789 6543');
INSERT INTO customers VALUES ('CT32', 'Fatimah Musa', '+60 16-345 9876');
INSERT INTO customers VALUES ('CT33', 'Harith Azman', '+60 11-234 6789');
INSERT INTO customers VALUES ('CT34', 'Sophia Lee', '+60 13-567 4321');
INSERT INTO customers VALUES ('CT35', 'Aaron Tan', '+60 19-876 5412');
INSERT INTO customers VALUES ('CT36', 'Emily Wong', '+60 15-998 8776');
INSERT INTO customers VALUES ('CT37', 'Ryan Lim', '+60 18-432 5678');
INSERT INTO customers VALUES ('CT38', 'Nurul Huda', '+60 17-654 1234');
INSERT INTO customers VALUES ('CT39', 'Amirul Rahman', '+60 14-888 9990');
INSERT INTO customers VALUES ('CT40', 'Michelle Yong', '+60 19-222 3334');
INSERT INTO customers VALUES ('CT41', 'Jason Khoo', '+60 16-789 9876');
INSERT INTO customers VALUES ('CT42', 'Natasha Chin', '+60 11-432 1234');
INSERT INTO customers VALUES ('CT43', 'Syafiq Harun', '+60 10-567 8765');
INSERT INTO customers VALUES ('CT44', 'Linda Ong', '+60 12-987 6543');
INSERT INTO customers VALUES ('CT45', 'Farhan Ismail', '+60 13-444 3332');
INSERT INTO customers VALUES ('CT46', 'Debbie Lim', '+60 17-123 6547');
INSERT INTO customers VALUES ('CT47', 'Hafiz Yusof', '+60 14-654 9991');
INSERT INTO customers VALUES ('CT48', 'Brandon Chia', '+60 15-777 1122');
INSERT INTO customers VALUES ('CT49', 'Yvonne Tan', '+60 18-678 3452');
INSERT INTO customers VALUES ('CT50', 'Rizal Hanafi', '+60 19-987 2211');

-- orders (orderID, customerID, orderType, orderDate, staffID, paymentStatus)
INSERT INTO orders VALUES ('ODO01', 'CT01', 'Dine In', TO_DATE('2024-12-01', 'YYYY-MM-DD'), 'ST10', 'Paid');
INSERT INTO orders VALUES ('ODO02', 'CT18', 'Dine In', TO_DATE('2024-12-01', 'YYYY-MM-DD'), 'ST10', 'Paid');
INSERT INTO orders VALUES ('ODO03', 'CT14', 'Take Away', TO_DATE('2024-12-01', 'YYYY-MM-DD'), 'ST11', 'Cancelled');
INSERT INTO orders VALUES ('ODO04', 'CT12', 'Dine In', TO_DATE('2024-12-01', 'YYYY-MM-DD'), 'ST10', 'Paid');
INSERT INTO orders VALUES ('ODO05', 'CT27', 'Dine In', TO_DATE('2024-12-01', 'YYYY-MM-DD'), 'ST11', 'Paid');
INSERT INTO orders VALUES ('ODO06', 'CT10', 'Dine In', TO_DATE('2024-12-02', 'YYYY-MM-DD'), 'ST10', 'Paid');
INSERT INTO orders VALUES ('ODO07', 'CT14', 'Dine In', TO_DATE('2024-12-02', 'YYYY-MM-DD'), 'ST11', 'Paid');
INSERT INTO orders VALUES ('ODO08', 'CT01', 'Dine In', TO_DATE('2024-12-02', 'YYYY-MM-DD'), 'ST10', 'Paid');
INSERT INTO orders VALUES ('ODO09', 'CT30', 'Take Away', TO_DATE('2024-12-02', 'YYYY-MM-DD'), 'ST11', 'Cancelled');
INSERT INTO orders VALUES ('ODO10', 'CT11', 'Dine In', TO_DATE('2024-12-02', 'YYYY-MM-DD'), 'ST10', 'Paid');
INSERT INTO orders VALUES ('ODO11', 'CT22', 'Dine In', TO_DATE('2024-12-03', 'YYYY-MM-DD'), 'ST10', 'Paid');
INSERT INTO orders VALUES ('ODO12', 'CT02', 'Dine In', TO_DATE('2024-12-03', 'YYYY-MM-DD'), 'ST11', 'Paid');
INSERT INTO orders VALUES ('ODO13', 'CT24', 'Dine In', TO_DATE('2024-12-03', 'YYYY-MM-DD'), 'ST10', 'Paid');
INSERT INTO orders VALUES ('ODO14', 'CT08', 'Dine In', TO_DATE('2024-12-03', 'YYYY-MM-DD'), 'ST11', 'Paid');
INSERT INTO orders VALUES ('ODO15', 'CT13', 'Dine In', TO_DATE('2024-12-03', 'YYYY-MM-DD'), 'ST10', 'Paid');
INSERT INTO orders VALUES ('ODO16', 'CT16', 'Dine In', TO_DATE('2024-12-04', 'YYYY-MM-DD'), 'ST11', 'Paid');
INSERT INTO orders VALUES ('ODO17', 'CT23', 'Dine In', TO_DATE('2024-12-04', 'YYYY-MM-DD'), 'ST10', 'Paid');
INSERT INTO orders VALUES ('ODO18', 'CT30', 'Dine In', TO_DATE('2024-12-04', 'YYYY-MM-DD'), 'ST11', 'Paid');
INSERT INTO orders VALUES ('ODO19', 'CT03', 'Take Away', TO_DATE('2024-12-04', 'YYYY-MM-DD'), 'ST10', 'Paid');
INSERT INTO orders VALUES ('ODO20', 'CT05', 'Dine In', TO_DATE('2024-12-04', 'YYYY-MM-DD'), 'ST11', 'Paid');
INSERT INTO orders VALUES ('ODO21', 'CT01', 'Dine In', TO_DATE('2024-12-05', 'YYYY-MM-DD'), 'ST10', 'Paid');
INSERT INTO orders VALUES ('ODO22', 'CT27', 'Dine In', TO_DATE('2024-12-05', 'YYYY-MM-DD'), 'ST10', 'Paid');
INSERT INTO orders VALUES ('ODO23', 'CT19', 'Take Away', TO_DATE('2024-12-05', 'YYYY-MM-DD'), 'ST11', 'Paid');
INSERT INTO orders VALUES ('ODO24', 'CT07', 'Dine In', TO_DATE('2024-12-05', 'YYYY-MM-DD'), 'ST10', 'Paid');
INSERT INTO orders VALUES ('ODO25', 'CT04', 'Take Away', TO_DATE('2024-12-05', 'YYYY-MM-DD'), 'ST11', 'Cancelled');
INSERT INTO orders VALUES ('ODO26', 'CT27', 'Dine In', TO_DATE('2024-12-06', 'YYYY-MM-DD'), 'ST10', 'Paid');
INSERT INTO orders VALUES ('ODO27', 'CT10', 'Dine In', TO_DATE('2024-12-06', 'YYYY-MM-DD'), 'ST11', 'Paid');
INSERT INTO orders VALUES ('ODO28', 'CT10', 'Dine In', TO_DATE('2024-12-06', 'YYYY-MM-DD'), 'ST10', 'Paid');
INSERT INTO orders VALUES ('ODO29', 'CT30', 'Dine In', TO_DATE('2024-12-06', 'YYYY-MM-DD'), 'ST11', 'Paid');
INSERT INTO orders VALUES ('ODO30', 'CT05', 'Dine In', TO_DATE('2024-12-06', 'YYYY-MM-DD'), 'ST10', 'Paid');
INSERT INTO orders VALUES ('ODO31', 'CT18', 'Dine In', TO_DATE('2024-12-07', 'YYYY-MM-DD'), 'ST10', 'Paid');
INSERT INTO orders VALUES ('ODO32', 'CT15', 'Take Away', TO_DATE('2024-12-07', 'YYYY-MM-DD'), 'ST11', 'Cancelled');
INSERT INTO orders VALUES ('ODO33', 'CT04', 'Dine In', TO_DATE('2024-12-07', 'YYYY-MM-DD'), 'ST10', 'Paid');
INSERT INTO orders VALUES ('ODO34', 'CT09', 'Dine In', TO_DATE('2024-12-07', 'YYYY-MM-DD'), 'ST11', 'Paid');
INSERT INTO orders VALUES ('ODO35', 'CT29', 'Dine In', TO_DATE('2024-12-07', 'YYYY-MM-DD'), 'ST10', 'Paid');
INSERT INTO orders VALUES ('ODO36', 'CT14', 'Dine In', TO_DATE('2024-12-01', 'YYYY-MM-DD'), 'ST11', 'Paid');
INSERT INTO orders VALUES ('ODO37', 'CT30', 'Dine In', TO_DATE('2024-12-01', 'YYYY-MM-DD'), 'ST10', 'Paid');
INSERT INTO orders VALUES ('ODO38', 'CT22', 'Dine In', TO_DATE('2024-12-01', 'YYYY-MM-DD'), 'ST11', 'Paid');
INSERT INTO orders VALUES ('ODO39', 'CT06', 'Dine In', TO_DATE('2024-12-01', 'YYYY-MM-DD'), 'ST10', 'Paid');
INSERT INTO orders VALUES ('ODO40', 'CT20', 'Dine In', TO_DATE('2024-12-01', 'YYYY-MM-DD'), 'ST11', 'Paid');
INSERT INTO orders VALUES ('ODO41', 'CT01', 'Dine In', TO_DATE('2024-12-02', 'YYYY-MM-DD'), 'ST10', 'Paid');
INSERT INTO orders VALUES ('ODO42', 'CT18', 'Dine In', TO_DATE('2024-12-02', 'YYYY-MM-DD'), 'ST11', 'Paid');
INSERT INTO orders VALUES ('ODO43', 'CT04', 'Dine In', TO_DATE('2024-12-02', 'YYYY-MM-DD'), 'ST10', 'Paid');
INSERT INTO orders VALUES ('ODO44', 'CT05', 'Dine In', TO_DATE('2024-12-02', 'YYYY-MM-DD'), 'ST11', 'Paid');
INSERT INTO orders VALUES ('ODO45', 'CT08', 'Dine In', TO_DATE('2024-12-02', 'YYYY-MM-DD'), 'ST10', 'Paid');
INSERT INTO orders VALUES ('ODO46', 'CT15', 'Take Away', TO_DATE('2024-12-03', 'YYYY-MM-DD'), 'ST11', 'Cancelled');
INSERT INTO orders VALUES ('ODO47', 'CT02', 'Dine In', TO_DATE('2024-12-03', 'YYYY-MM-DD'), 'ST10', 'Paid');
INSERT INTO orders VALUES ('ODO48', 'CT16', 'Dine In', TO_DATE('2024-12-03', 'YYYY-MM-DD'), 'ST11', 'Paid');
INSERT INTO orders VALUES ('ODO49', 'CT21', 'Dine In', TO_DATE('2024-12-03', 'YYYY-MM-DD'), 'ST10', 'Paid');
INSERT INTO orders VALUES ('ODO50', 'CT29', 'Dine In', TO_DATE('2024-12-03', 'YYYY-MM-DD'), 'ST11', 'Paid');
INSERT INTO orders VALUES ('ODO51', 'CT24', 'Dine In', TO_DATE('2024-12-04', 'YYYY-MM-DD'), 'ST10', 'Paid');
INSERT INTO orders VALUES ('ODO52', 'CT07', 'Dine In', TO_DATE('2024-12-04', 'YYYY-MM-DD'), 'ST11', 'Paid');
INSERT INTO orders VALUES ('ODO53', 'CT01', 'Dine In', TO_DATE('2024-12-04', 'YYYY-MM-DD'), 'ST10', 'Paid');
INSERT INTO orders VALUES ('ODO54', 'CT30', 'Dine In', TO_DATE('2024-12-04', 'YYYY-MM-DD'), 'ST11', 'Paid');
INSERT INTO orders VALUES ('ODO55', 'CT10', 'Dine In', TO_DATE('2024-12-04', 'YYYY-MM-DD'), 'ST10', 'Paid');
INSERT INTO orders VALUES ('ODO56', 'CT05', 'Dine In', TO_DATE('2024-12-05', 'YYYY-MM-DD'), 'ST11', 'Paid');
INSERT INTO orders VALUES ('ODO57', 'CT15', 'Dine In', TO_DATE('2024-12-05', 'YYYY-MM-DD'), 'ST10', 'Paid');
INSERT INTO orders VALUES ('ODO58', 'CT13', 'Take Away', TO_DATE('2024-12-05', 'YYYY-MM-DD'), 'ST11', 'Paid');
INSERT INTO orders VALUES ('ODO59', 'CT17', 'Dine In', TO_DATE('2024-12-05', 'YYYY-MM-DD'), 'ST10', 'Paid');
INSERT INTO orders VALUES ('ODO60', 'CT02', 'Dine In', TO_DATE('2024-12-05', 'YYYY-MM-DD'), 'ST11', 'Paid');
INSERT INTO orders VALUES ('ODO61', 'CT27', 'Dine In', TO_DATE('2024-12-06', 'YYYY-MM-DD'), 'ST10', 'Paid');
INSERT INTO orders VALUES ('ODO62', 'CT05', 'Dine In', TO_DATE('2024-12-06', 'YYYY-MM-DD'), 'ST11', 'Paid');
INSERT INTO orders VALUES ('ODO63', 'CT01', 'Dine In', TO_DATE('2024-12-06', 'YYYY-MM-DD'), 'ST10', 'Paid');
INSERT INTO orders VALUES ('ODO64', 'CT10', 'Dine In', TO_DATE('2024-12-06', 'YYYY-MM-DD'), 'ST11', 'Paid');
INSERT INTO orders VALUES ('ODO65', 'CT24', 'Take Away', TO_DATE('2024-12-06', 'YYYY-MM-DD'), 'ST10', 'Paid');
INSERT INTO orders VALUES ('ODO66', 'CT08', 'Dine In', TO_DATE('2024-12-07', 'YYYY-MM-DD'), 'ST11', 'Paid');
INSERT INTO orders VALUES ('ODO67', 'CT17', 'Dine In', TO_DATE('2024-12-07', 'YYYY-MM-DD'), 'ST10', 'Paid');
INSERT INTO orders VALUES ('ODO68', 'CT23', 'Take Away', TO_DATE('2024-12-07', 'YYYY-MM-DD'), 'ST11', 'Paid');
INSERT INTO orders VALUES ('ODO69', 'CT22', 'Dine In', TO_DATE('2024-12-07', 'YYYY-MM-DD'), 'ST10', 'Paid');
INSERT INTO orders VALUES ('ODO70', 'CT20', 'Dine In', TO_DATE('2024-12-07', 'YYYY-MM-DD'), 'ST11', 'Paid');

-- feedback (feedbackID, orderID, content, rating)
INSERT INTO feedback VALUES ('FB002', 'ODO02', 'Tasty and filling.', 4.8);
INSERT INTO feedback VALUES ('FB004', 'ODO04', 'Perfect meal for a quick lunch.', 4.9);
INSERT INTO feedback VALUES ('FB005', 'ODO05', 'Juicy and flavorful.', 5.0);
INSERT INTO feedback VALUES ('FB006', 'ODO06', 'Fresh and perfectly cooked.', 4.7);
INSERT INTO feedback VALUES ('FB008', 'ODO08', 'Satisfied with the quality.', 4.5);
INSERT INTO feedback VALUES ('FB011', 'ODO11', 'Fish burger was too greasy for my liking.', 2.5);
INSERT INTO feedback VALUES ('FB012', 'ODO12', 'Delicious and well-prepared.', 4.8);
INSERT INTO feedback VALUES ('FB013', 'ODO13', 'Wonderful meal experience.', 5.0);
INSERT INTO feedback VALUES ('FB014', 'ODO14', 'Loved the flavors.', 4.6);
INSERT INTO feedback VALUES ('FB016', 'ODO16', 'Good value for money.', 4.4);
INSERT INTO feedback VALUES ('FB018', 'ODO18', 'Great combination of ingredients.', 4.7);
INSERT INTO feedback VALUES ('FB022', 'ODO22', 'Very satisfying meal.', 4.6);
INSERT INTO feedback VALUES ('FB023', 'ODO23', 'The burger lacked flavor and was cold.', 2.8);
INSERT INTO feedback VALUES ('FB025', 'ODO25', 'Perfect for a family dinner.', 4.5);
INSERT INTO feedback VALUES ('FB026', 'ODO26', 'Loved the presentation and taste.', 4.8);
INSERT INTO feedback VALUES ('FB027', 'ODO27', 'Very happy with the meal.', 4.9);
INSERT INTO feedback VALUES ('FB029', 'ODO29', 'Quality and taste were excellent.', 4.7);
INSERT INTO feedback VALUES ('FB031', 'ODO31', 'Fresh and flavorful.', 4.5);
INSERT INTO feedback VALUES ('FB032', 'ODO32', 'The taste was spot on.', 4.6);
INSERT INTO feedback VALUES ('FB035', 'ODO35', 'Amazing quality food.', 5.0);
INSERT INTO feedback VALUES ('FB037', 'ODO37', 'Perfectly cooked and seasoned.', 4.8);
INSERT INTO feedback VALUES ('FB038', 'ODO38', 'Top-notch quality.', 4.9);
INSERT INTO feedback VALUES ('FB039', 'ODO39', 'Fantastic flavors!', 5.0);
INSERT INTO feedback VALUES ('FB040', 'ODO40', 'Absolutely worth it!', 4.6);
INSERT INTO feedback VALUES ('FB041', 'ODO41', 'Perfect meal for a quick bite.', 4.7);
INSERT INTO feedback VALUES ('FB042', 'ODO42', 'Amazing experience!', 4.8);
INSERT INTO feedback VALUES ('FB045', 'ODO45', 'Everything was great except the fish burger. Tasted strange.', 2.9);
INSERT INTO feedback VALUES ('FB047', 'ODO47', 'Great portion size and taste.', 4.6);
INSERT INTO feedback VALUES ('FB050', 'ODO50', 'One of the best meals I`ve had!', 5.0);
INSERT INTO feedback VALUES ('FB052', 'ODO52', 'Would definitely come back for more.', 4.7);
INSERT INTO feedback VALUES ('FB054', 'ODO54', 'Enjoyed the meal thoroughly.', 4.8);
INSERT INTO feedback VALUES ('FB055', 'ODO55', 'Delicious, will recommend.', 4.6);
INSERT INTO feedback VALUES ('FB058', 'ODO58', 'Absolutely loved it! Fresh and delicious.', 5.0);
INSERT INTO feedback VALUES ('FB061', 'ODO61', 'Will definitely FB0er again.', 4.8);
INSERT INTO feedback VALUES ('FB064', 'ODO64', 'Highly recommend this!', 4.9);
INSERT INTO feedback VALUES ('FB068', 'ODO68', 'Highly recommend this restaurant.', 4.9);
INSERT INTO feedback VALUES ('FB069', 'ODO69', 'Exceeded expectations.', 5.0);

-- item-ingredients (itemID, ingredientID)
INSERT INTO itemIngredients VALUES ('IT01', 'ING01'); 
INSERT INTO itemIngredients VALUES ('IT01', 'ING04'); 
INSERT INTO itemIngredients VALUES ('IT01', 'ING06'); 
INSERT INTO itemIngredients VALUES ('IT01', 'ING08'); 
INSERT INTO itemIngredients VALUES ('IT01', 'ING13'); 

INSERT INTO itemIngredients VALUES ('IT02', 'ING01');
INSERT INTO itemIngredients VALUES ('IT02', 'ING04'); 
INSERT INTO itemIngredients VALUES ('IT02', 'ING06'); 
INSERT INTO itemIngredients VALUES ('IT02', 'ING07'); 
INSERT INTO itemIngredients VALUES ('IT02', 'ING09'); 
INSERT INTO itemIngredients VALUES ('IT02', 'ING10'); 

INSERT INTO itemIngredients VALUES ('IT03', 'ING01'); 
INSERT INTO itemIngredients VALUES ('IT03', 'ING03');
INSERT INTO itemIngredients VALUES ('IT03', 'ING06');
INSERT INTO itemIngredients VALUES ('IT03', 'ING08'); 
INSERT INTO itemIngredients VALUES ('IT03', 'ING16'); 

INSERT INTO itemIngredients VALUES ('IT04', 'ING01'); 
INSERT INTO itemIngredients VALUES ('IT04', 'ING04'); 
INSERT INTO itemIngredients VALUES ('IT04', 'ING06'); 
INSERT INTO itemIngredients VALUES ('IT04', 'ING08'); 
INSERT INTO itemIngredients VALUES ('IT04', 'ING13'); 

INSERT INTO itemIngredients VALUES ('IT05', 'ING01'); 
INSERT INTO itemIngredients VALUES ('IT05', 'ING04'); 
INSERT INTO itemIngredients VALUES ('IT05', 'ING06'); 
INSERT INTO itemIngredients VALUES ('IT05', 'ING07'); 
INSERT INTO itemIngredients VALUES ('IT05', 'ING09'); 
INSERT INTO itemIngredients VALUES ('IT05', 'ING10'); 

INSERT INTO itemIngredients VALUES ('IT06', 'ING01'); 
INSERT INTO itemIngredients VALUES ('IT06', 'ING05'); 
INSERT INTO itemIngredients VALUES ('IT06', 'ING08'); 
INSERT INTO itemIngredients VALUES ('IT06', 'ING13'); 

INSERT INTO itemIngredients VALUES ('IT07', 'ING01'); 
INSERT INTO itemIngredients VALUES ('IT07', 'ING03'); 
INSERT INTO itemIngredients VALUES ('IT07', 'ING20'); 

INSERT INTO itemIngredients VALUES ('IT08', 'ING02'); 
INSERT INTO itemIngredients VALUES ('IT08', 'ING04'); 
INSERT INTO itemIngredients VALUES ('IT08', 'ING07'); 
INSERT INTO itemIngredients VALUES ('IT08', 'ING13'); 

INSERT INTO itemIngredients VALUES ('IT09', 'ING01'); 
INSERT INTO itemIngredients VALUES ('IT09', 'ING04'); 
INSERT INTO itemIngredients VALUES ('IT09', 'ING06'); 
INSERT INTO itemIngredients VALUES ('IT09', 'ING08'); 
INSERT INTO itemIngredients VALUES ('IT09', 'ING10'); 
INSERT INTO itemIngredients VALUES ('IT09', 'ING14');

INSERT INTO itemIngredients VALUES ('IT10', 'ING11'); 

INSERT INTO itemIngredients VALUES ('IT11', 'ING03'); 
INSERT INTO itemIngredients VALUES ('IT11', 'ING15'); 

INSERT INTO itemIngredients VALUES ('IT12', 'ING11');

INSERT INTO itemIngredients VALUES ('IT13', 'ING03');  
INSERT INTO itemIngredients VALUES ('IT13', 'ING20');  
INSERT INTO itemIngredients VALUES ('IT13', 'ING21');  

INSERT INTO itemIngredients VALUES ('IT14', 'ING03'); 
INSERT INTO itemIngredients VALUES ('IT14', 'ING20'); 
INSERT INTO itemIngredients VALUES ('IT14', 'ING21'); 
INSERT INTO itemIngredients VALUES ('IT14', 'ING22'); 

INSERT INTO itemIngredients VALUES ('IT15', 'ING25'); 

INSERT INTO itemIngredients VALUES ('IT16', 'ING12'); 

INSERT INTO itemIngredients VALUES ('IT17', 'ING26'); 
INSERT INTO itemIngredients VALUES ('IT17', 'ING24'); 

INSERT INTO itemIngredients VALUES ('IT18', 'ING19'); 
INSERT INTO itemIngredients VALUES ('IT18', 'ING20'); 
INSERT INTO itemIngredients VALUES ('IT18', 'ING21'); 
INSERT INTO itemIngredients VALUES ('IT18', 'ING18'); 

INSERT INTO itemIngredients VALUES ('IT19', 'ING27'); 

INSERT INTO itemIngredients VALUES ('IT20', 'ING19'); 
INSERT INTO itemIngredients VALUES ('IT20', 'ING20');
INSERT INTO itemIngredients VALUES ('IT20', 'ING21');

-- item configurations (menuItemID, itemID)
INSERT INTO itemConfig VALUES ('MI01', 'IT01');
INSERT INTO itemConfig VALUES ('MI02', 'IT02');
INSERT INTO itemConfig VALUES ('MI03', 'IT03');
INSERT INTO itemConfig VALUES ('MI04', 'IT04');
INSERT INTO itemConfig VALUES ('MI05', 'IT05');
INSERT INTO itemConfig VALUES ('MI06', 'IT06');
INSERT INTO itemConfig VALUES ('MI07', 'IT07');
INSERT INTO itemConfig VALUES ('MI08', 'IT08');
INSERT INTO itemConfig VALUES ('MI09', 'IT09');
INSERT INTO itemConfig VALUES ('MI10', 'IT10');
INSERT INTO itemConfig VALUES ('MI11', 'IT11');
INSERT INTO itemConfig VALUES ('MI12', 'IT12');
INSERT INTO itemConfig VALUES ('MI13', 'IT13');
INSERT INTO itemConfig VALUES ('MI14', 'IT14');
INSERT INTO itemConfig VALUES ('MI15', 'IT15');
INSERT INTO itemConfig VALUES ('MI16', 'IT16');
INSERT INTO itemConfig VALUES ('MI17', 'IT17');
INSERT INTO itemConfig VALUES ('MI18', 'IT18');
INSERT INTO itemConfig VALUES ('MI19', 'IT19');
INSERT INTO itemConfig VALUES ('MI20', 'IT20');

-- staff-items (staffID, itemID)
INSERT INTO staffItem VALUES ('ST04', 'IT01');
INSERT INTO staffItem VALUES ('ST04', 'IT03');
INSERT INTO staffItem VALUES ('ST04', 'IT04');
INSERT INTO staffItem VALUES ('ST04', 'IT10');
INSERT INTO staffItem VALUES ('ST05', 'IT02');
INSERT INTO staffItem VALUES ('ST05', 'IT05');
INSERT INTO staffItem VALUES ('ST05', 'IT08');
INSERT INTO staffItem VALUES ('ST05', 'IT10');
INSERT INTO staffItem VALUES ('ST06', 'IT06');
INSERT INTO staffItem VALUES ('ST06', 'IT07');
INSERT INTO staffItem VALUES ('ST06', 'IT08');
INSERT INTO staffItem VALUES ('ST06', 'IT10');
INSERT INTO staffItem VALUES ('ST06', 'IT13');
INSERT INTO staffItem VALUES ('ST07', 'IT09');
INSERT INTO staffItem VALUES ('ST07', 'IT11');
INSERT INTO staffItem VALUES ('ST07', 'IT12');
INSERT INTO staffItem VALUES ('ST07', 'IT14');
INSERT INTO staffItem VALUES ('ST08', 'IT18');
INSERT INTO staffItem VALUES ('ST08', 'IT19');
INSERT INTO staffItem VALUES ('ST08', 'IT20');
INSERT INTO staffItem VALUES ('ST09', 'IT15');
INSERT INTO staffItem VALUES ('ST09', 'IT16');
INSERT INTO staffItem VALUES ('ST09', 'IT17');

-- order details (orderID, menuItemID)
INSERT INTO orderDetails VALUES ('ODO01', 'MI01', 1); 
INSERT INTO orderDetails VALUES ('ODO01', 'MI10', 1); 
INSERT INTO orderDetails VALUES ('ODO01', 'MI15', 1); 

INSERT INTO orderDetails VALUES ('ODO02', 'MI13', 1); 
INSERT INTO orderDetails VALUES ('ODO02', 'MI10', 1); 
INSERT INTO orderDetails VALUES ('ODO02', 'MI15', 1); 

INSERT INTO orderDetails VALUES ('ODO03', 'MI08', 2); 
INSERT INTO orderDetails VALUES ('ODO03', 'MI19', 1); 

INSERT INTO orderDetails VALUES ('ODO04', 'MI07', 1); 
INSERT INTO orderDetails VALUES ('ODO04', 'MI12', 1); 
INSERT INTO orderDetails VALUES ('ODO04', 'MI17', 1);

INSERT INTO orderDetails VALUES ('ODO05', 'MI01', 2); 
INSERT INTO orderDetails VALUES ('ODO05', 'MI10', 1); 
INSERT INTO orderDetails VALUES ('ODO05', 'MI15', 1); 

INSERT INTO orderDetails VALUES ('ODO06', 'MI14', 1);

INSERT INTO orderDetails VALUES ('ODO07', 'MI14', 1);
INSERT INTO orderDetails VALUES ('ODO07', 'MI11', 1);  
INSERT INTO orderDetails VALUES ('ODO07', 'MI16', 1); 

INSERT INTO orderDetails VALUES ('ODO08', 'MI07', 1); 
INSERT INTO orderDetails VALUES ('ODO08', 'MI12', 1); 
INSERT INTO orderDetails VALUES ('ODO08', 'MI17', 1);

INSERT INTO orderDetails VALUES ('ODO09', 'MI02', 2); 
INSERT INTO orderDetails VALUES ('ODO09', 'MI10', 2); 
INSERT INTO orderDetails VALUES ('ODO09', 'MI15', 1); 

INSERT INTO orderDetails VALUES ('ODO10', 'MI13', 1); 
INSERT INTO orderDetails VALUES ('ODO10', 'MI10', 1); 
INSERT INTO orderDetails VALUES ('ODO10', 'MI15', 1); 

INSERT INTO orderDetails VALUES ('ODO11', 'MI06', 2); 
INSERT INTO orderDetails VALUES ('ODO11', 'MI16', 1); 

INSERT INTO orderDetails VALUES ('ODO12', 'MI10', 3); 

INSERT INTO orderDetails VALUES ('ODO13', 'MI01', 1); 
INSERT INTO orderDetails VALUES ('ODO13', 'MI10', 1); 
INSERT INTO orderDetails VALUES ('ODO13', 'MI15', 1); 

INSERT INTO orderDetails VALUES ('ODO14', 'MI03', 1); 
INSERT INTO orderDetails VALUES ('ODO14', 'MI18', 1); 

INSERT INTO orderDetails VALUES ('ODO15', 'MI13', 1); 
INSERT INTO orderDetails VALUES ('ODO15', 'MI12', 1); 
INSERT INTO orderDetails VALUES ('ODO15', 'MI16', 1); 

INSERT INTO orderDetails VALUES ('ODO16', 'MI07', 1); 
INSERT INTO orderDetails VALUES ('ODO16', 'MI12', 1); 
INSERT INTO orderDetails VALUES ('ODO16', 'MI17', 1);

INSERT INTO orderDetails VALUES ('ODO17', 'MI14', 1);
INSERT INTO orderDetails VALUES ('ODO17', 'MI11', 1);  
INSERT INTO orderDetails VALUES ('ODO17', 'MI16', 1); 

INSERT INTO orderDetails VALUES ('ODO18', 'MI03', 1); 
INSERT INTO orderDetails VALUES ('ODO18', 'MI10', 2); 
INSERT INTO orderDetails VALUES ('ODO18', 'MI15', 1); 

INSERT INTO orderDetails VALUES ('ODO19', 'MI14', 1);
INSERT INTO orderDetails VALUES ('ODO19', 'MI10', 1);  
INSERT INTO orderDetails VALUES ('ODO19', 'MI15', 1); 

INSERT INTO orderDetails VALUES ('ODO20', 'MI01', 6); 
INSERT INTO orderDetails VALUES ('ODO20', 'MI02', 3); 
INSERT INTO orderDetails VALUES ('ODO20', 'MI03', 4); 
INSERT INTO orderDetails VALUES ('ODO20', 'MI14', 6); 
INSERT INTO orderDetails VALUES ('ODO20', 'MI11', 2); 
INSERT INTO orderDetails VALUES ('ODO20', 'MI17', 3); 
INSERT INTO orderDetails VALUES ('ODO20', 'MI18', 4); 
INSERT INTO orderDetails VALUES ('ODO20', 'MI19', 6); 
INSERT INTO orderDetails VALUES ('ODO20', 'MI20', 4); 

INSERT INTO orderDetails VALUES ('ODO21', 'MI01', 1); 
INSERT INTO orderDetails VALUES ('ODO21', 'MI15', 1); 

INSERT INTO orderDetails VALUES ('ODO22', 'MI14', 2);
INSERT INTO orderDetails VALUES ('ODO22', 'MI11', 1);  
INSERT INTO orderDetails VALUES ('ODO22', 'MI16', 1); 

INSERT INTO orderDetails VALUES ('ODO23', 'MI06', 2); 

INSERT INTO orderDetails VALUES ('ODO24', 'MI07', 2); 
INSERT INTO orderDetails VALUES ('ODO24', 'MI12', 1); 
INSERT INTO orderDetails VALUES ('ODO24', 'MI17', 1); 

INSERT INTO orderDetails VALUES ('ODO25', 'MI18', 1); 

INSERT INTO orderDetails VALUES ('ODO26', 'MI01', 1); 
INSERT INTO orderDetails VALUES ('ODO26', 'MI10', 1); 
INSERT INTO orderDetails VALUES ('ODO26', 'MI15', 1); 
INSERT INTO orderDetails VALUES ('ODO27', 'MI13', 1);
INSERT INTO orderDetails VALUES ('ODO27', 'MI10', 1);  
INSERT INTO orderDetails VALUES ('ODO27', 'MI15', 1); 

INSERT INTO orderDetails VALUES ('ODO28', 'MI11', 2); 
INSERT INTO orderDetails VALUES ('ODO28', 'MI20', 1);

INSERT INTO orderDetails VALUES ('ODO29', 'MI01', 1); 
INSERT INTO orderDetails VALUES ('ODO29', 'MI10', 1); 
INSERT INTO orderDetails VALUES ('ODO29', 'MI15', 1); 

INSERT INTO orderDetails VALUES ('ODO30', 'MI02', 1); 
INSERT INTO orderDetails VALUES ('ODO30', 'MI10', 1); 
INSERT INTO orderDetails VALUES ('ODO30', 'MI15', 1); 

INSERT INTO orderDetails VALUES ('ODO31', 'MI03', 1); 
INSERT INTO orderDetails VALUES ('ODO31', 'MI10', 1); 
INSERT INTO orderDetails VALUES ('ODO31', 'MI15', 1); 
INSERT INTO orderDetails VALUES ('ODO32', 'MI14', 1); 
INSERT INTO orderDetails VALUES ('ODO32', 'MI10', 1); 
INSERT INTO orderDetails VALUES ('ODO32', 'MI16', 1); 

INSERT INTO orderDetails VALUES ('ODO33', 'MI05', 1); 
INSERT INTO orderDetails VALUES ('ODO33', 'MI10', 1); 
INSERT INTO orderDetails VALUES ('ODO33', 'MI15', 1); 

INSERT INTO orderDetails VALUES ('ODO34', 'MI13', 1); 
INSERT INTO orderDetails VALUES ('ODO34', 'MI10', 1); 
INSERT INTO orderDetails VALUES ('ODO34', 'MI15', 1); 

INSERT INTO orderDetails VALUES ('ODO35', 'MI02', 1); 
INSERT INTO orderDetails VALUES ('ODO35', 'MI10', 1); 
INSERT INTO orderDetails VALUES ('ODO35', 'MI15', 1); 

INSERT INTO orderDetails VALUES ('ODO36', 'MI07', 1); 
INSERT INTO orderDetails VALUES ('ODO36', 'MI12', 1); 
INSERT INTO orderDetails VALUES ('ODO36', 'MI17', 1);

INSERT INTO orderDetails VALUES ('ODO37', 'MI13', 1); 
INSERT INTO orderDetails VALUES ('ODO37', 'MI10', 1); 
INSERT INTO orderDetails VALUES ('ODO37', 'MI15', 1); 

INSERT INTO orderDetails VALUES ('ODO38', 'MI20', 2);

INSERT INTO orderDetails VALUES ('ODO39', 'MI19', 4);

INSERT INTO orderDetails VALUES ('ODO40', 'MI01', 1); 
INSERT INTO orderDetails VALUES ('ODO40', 'MI10', 1); 
INSERT INTO orderDetails VALUES ('ODO40', 'MI15', 1); 

INSERT INTO orderDetails VALUES ('ODO41', 'MI14', 1);
INSERT INTO orderDetails VALUES ('ODO41', 'MI16', 1); 
 
INSERT INTO orderDetails VALUES ('ODO42', 'MI07', 1); 
INSERT INTO orderDetails VALUES ('ODO42', 'MI12', 1); 
INSERT INTO orderDetails VALUES ('ODO42', 'MI17', 1);

INSERT INTO orderDetails VALUES ('ODO43', 'MI01', 1); 
INSERT INTO orderDetails VALUES ('ODO43', 'MI10', 1); 
INSERT INTO orderDetails VALUES ('ODO43', 'MI15', 1); 

INSERT INTO orderDetails VALUES ('ODO44', 'MI14', 1);
INSERT INTO orderDetails VALUES ('ODO44', 'MI11', 1);  
INSERT INTO orderDetails VALUES ('ODO44', 'MI16', 1); 

INSERT INTO orderDetails VALUES ('ODO45', 'MI04', 4); 
INSERT INTO orderDetails VALUES ('ODO45', 'MI05', 5); 
INSERT INTO orderDetails VALUES ('ODO45', 'MI06', 8); 
INSERT INTO orderDetails VALUES ('ODO45', 'MI10', 3); 
INSERT INTO orderDetails VALUES ('ODO45', 'MI15', 8);  
INSERT INTO orderDetails VALUES ('ODO45', 'MI16', 2); 
INSERT INTO orderDetails VALUES ('ODO45', 'MI20', 8); 

INSERT INTO orderDetails VALUES ('ODO46', 'MI01', 1); 
INSERT INTO orderDetails VALUES ('ODO46', 'MI10', 1); 
INSERT INTO orderDetails VALUES ('ODO46', 'MI15', 1); 

INSERT INTO orderDetails VALUES ('ODO47', 'MI02', 1); 
INSERT INTO orderDetails VALUES ('ODO47', 'MI10', 1); 
INSERT INTO orderDetails VALUES ('ODO47', 'MI15', 1); 

INSERT INTO orderDetails VALUES ('ODO48', 'MI13', 1);
INSERT INTO orderDetails VALUES ('ODO48', 'MI10', 1); 
INSERT INTO orderDetails VALUES ('ODO48', 'MI15', 1); 

INSERT INTO orderDetails VALUES ('ODO49', 'MI18', 3); 

INSERT INTO orderDetails VALUES ('ODO50', 'MI02', 1); 
INSERT INTO orderDetails VALUES ('ODO50', 'MI10', 1); 
INSERT INTO orderDetails VALUES ('ODO50', 'MI15', 1); 

INSERT INTO orderDetails VALUES ('ODO51', 'MI03', 1); 
INSERT INTO orderDetails VALUES ('ODO51', 'MI10', 1); 
INSERT INTO orderDetails VALUES ('ODO51', 'MI15', 1); 

INSERT INTO orderDetails VALUES ('ODO52', 'MI14', 2); 

INSERT INTO orderDetails VALUES ('ODO53', 'MI02', 1); 
INSERT INTO orderDetails VALUES ('ODO53', 'MI10', 1); 
INSERT INTO orderDetails VALUES ('ODO53', 'MI15', 1); 

INSERT INTO orderDetails VALUES ('ODO54', 'MI03', 1); 
INSERT INTO orderDetails VALUES ('ODO54', 'MI10', 1); 
INSERT INTO orderDetails VALUES ('ODO54', 'MI15', 1); 

INSERT INTO orderDetails VALUES ('ODO55', 'MI01', 1); 
INSERT INTO orderDetails VALUES ('ODO55', 'MI10', 1); 
INSERT INTO orderDetails VALUES ('ODO55', 'MI15', 1); 

INSERT INTO orderDetails VALUES ('ODO56', 'MI02', 1); 
INSERT INTO orderDetails VALUES ('ODO56', 'MI10', 1); 
INSERT INTO orderDetails VALUES ('ODO56', 'MI15', 1); 

INSERT INTO orderDetails VALUES ('ODO57', 'MI03', 1); 
INSERT INTO orderDetails VALUES ('ODO57', 'MI10', 1); 
INSERT INTO orderDetails VALUES ('ODO57', 'MI15', 1); 

INSERT INTO orderDetails VALUES ('ODO58', 'MI01', 1); 
INSERT INTO orderDetails VALUES ('ODO58', 'MI15', 1); 

INSERT INTO orderDetails VALUES ('ODO59', 'MI02', 1); 
INSERT INTO orderDetails VALUES ('ODO59', 'MI15', 1); 

INSERT INTO orderDetails VALUES ('ODO60', 'MI03', 1); 
INSERT INTO orderDetails VALUES ('ODO60', 'MI10', 1); 
INSERT INTO orderDetails VALUES ('ODO60', 'MI15', 1); 

INSERT INTO orderDetails VALUES ('ODO61', 'MI13', 1); 
INSERT INTO orderDetails VALUES ('ODO61', 'MI10', 1); 
INSERT INTO orderDetails VALUES ('ODO61', 'MI15', 1); 

INSERT INTO orderDetails VALUES ('ODO62', 'MI02', 1); 
INSERT INTO orderDetails VALUES ('ODO62', 'MI10', 1); 
INSERT INTO orderDetails VALUES ('ODO62', 'MI15', 1); 

INSERT INTO orderDetails VALUES ('ODO63', 'MI03', 1); 
INSERT INTO orderDetails VALUES ('ODO63', 'MI10', 1); 
INSERT INTO orderDetails VALUES ('ODO63', 'MI15', 1); 

INSERT INTO orderDetails VALUES ('ODO64', 'MI01', 1); 
INSERT INTO orderDetails VALUES ('ODO64', 'MI10', 1); 
INSERT INTO orderDetails VALUES ('ODO64', 'MI15', 1); 

INSERT INTO orderDetails VALUES ('ODO65', 'MI02', 1); 
INSERT INTO orderDetails VALUES ('ODO65', 'MI10', 1); 
INSERT INTO orderDetails VALUES ('ODO65', 'MI15', 1); 

INSERT INTO orderDetails VALUES ('ODO66', 'MI03', 2);  

INSERT INTO orderDetails VALUES ('ODO67', 'MI01', 1); 
INSERT INTO orderDetails VALUES ('ODO67', 'MI10', 1); 
INSERT INTO orderDetails VALUES ('ODO67', 'MI15', 1); 

INSERT INTO orderDetails VALUES ('ODO68', 'MI01', 4); 
INSERT INTO orderDetails VALUES ('ODO68', 'MI02', 3); 
INSERT INTO orderDetails VALUES ('ODO68', 'MI10', 5); 
INSERT INTO orderDetails VALUES ('ODO68', 'MI15', 6); 
INSERT INTO orderDetails VALUES ('ODO68', 'MI13', 4); 
INSERT INTO orderDetails VALUES ('ODO68', 'MI12', 6); 
INSERT INTO orderDetails VALUES ('ODO68', 'MI16', 2); 

INSERT INTO orderDetails VALUES ('ODO69', 'MI03', 1); 
INSERT INTO orderDetails VALUES ('ODO69', 'MI10', 1); 
INSERT INTO orderDetails VALUES ('ODO69', 'MI15', 1); 

INSERT INTO orderDetails VALUES ('ODO70', 'MI01', 1); 
INSERT INTO orderDetails VALUES ('ODO70', 'MI10', 1); 
INSERT INTO orderDetails VALUES ('ODO70', 'MI15', 1);


-- Identifies ingredients not used in the making of any food items. 
-- This query allows the business owner to manage their inventory efficiently by: 
--      i. implementing unused ingredients into existing or new food items, or 
--      ii. avoid ordering surplus ingredients from suppliers. 

SELECT ing.ingredientID, ing.ingredientName, i.itemname
FROM ingredients ing
LEFT JOIN itemingredients ii 
ON ing.ingredientID = ii.ingredientID
LEFT JOIN item i 
ON ii.itemID = i.itemID
WHERE ii.itemID IS NULL;


-- Determines performance of each cashier staff based on total orders taken and total revenue generated. 
-- This query allows the business owner to evaluate cashier staff performance. 

SELECT o.staffID, s.staffName, COUNT(od.orderID) AS totalOrders, SUM(od.quantity * mi.MenuItemPrice) AS totalRevenue
FROM orders o
JOIN orderDetails od 
ON o.orderID = od.orderID
JOIN menuItem mi 
ON od.menuItemID = mi.menuItemID
JOIN staff s 
ON o.staffID = s.staffID
GROUP BY o.staffID, s.staffName
ORDER BY totalRevenue DESC;


-- Analyze french fries sales over the course of a week to identify the amount of orders, total quantity and the total revenue received each day. 
-- This query allows the business to gain insight on which days french fries are sold the most and made the most revenue on and which days have the lowest sales to offer discounts on that specific day. 

SELECT o.orderDate AS "Order Date", COUNT(od.orderid) AS "Amount of Orders", SUM(od.quantity) AS "Total Quantity of French Fries", 
SUM(od.quantity * mi.menuItemPrice) AS "Total Revenue"
FROM menuItem mi
JOIN orderDetails od 
ON mi.menuItemID = od.menuItemID
JOIN orders o 
ON od.orderID = o.orderID
WHERE mi.menuItemName LIKE 'French Fries' 
AND o.orderDate BETWEEN TO_DATE('2024-12-01', 'YYYY-MM-DD') AND TO_DATE('2024-12-07', 'YYYY-MM-DD')
GROUP BY o.orderDate
ORDER BY "Total Quantity of French Fries" DESC;


-- A query for finding unpopular combos of food and beverage for the purpose of gathering feedback on underperforming menu items.
select od.orderID, m.categoryID , m.menuItemName, f.rating, f.Content
from orderDetails od
left join menuItem m 
on od.menuItemID=m.menuItemID
left join feedback f 
on od.orderID=f.orderID
where f.rating < 3 
and m.categoryID = 'CT3' 
or m.categoryID like 'CT1' 
and f.rating < 3


-- Determines suppliers of ingredients for the top 5 highest selling menu items, as well as the ingredients they provide. 
-- This query allows restaurant management to determine high-priority suppliers so as to avoid any disruption to restaurant operations.

SELECT su.supplierID, su.supplierName, ing.ingredientID, ing.ingredientName
FROM supplier su
JOIN ingredients ing
ON su.supplierID = ing.supplierID
WHERE ing.ingredientID IN (
    SELECT ingredientID
    FROM itemingredients
    WHERE itemID IN (
        SELECT itemID
        FROM itemconfig
        WHERE menuitemID IN (
            SELECT od.menuitemID
            FROM orderdetails od
            JOIN orders o 
            ON od.orderID = o.orderID
            WHERE o.paymentStatus = 'Paid'
            GROUP BY od.menuitemID
            ORDER BY SUM(od.quantity) DESC
            FETCH FIRST 5 ROWS ONLY
        )
    )
)
ORDER BY ing.ingredientID DESC;


-- Identifies top 10 most frequent combinations of menu items ordered by customers; 
-- the query also filters out cancelled orders in order to avoid inaccurate interpretation of information. 
-- This allows the business owner to make informed decisions regarding creating combo items that will cater to customers more. 

WITH orderCombinations AS (
    SELECT LISTAGG(od.menuItemID || ': ' || mi.menuItemName, ', ') WITHIN GROUP (ORDER BY od.menuItemID) AS combination
    FROM orderDetails od
    INNER JOIN menuItem mi 
    ON od.menuItemID = mi.menuItemID
    INNER JOIN orders o
    ON od.orderID = o.orderID
    WHERE paymentStatus = 'Paid'
    GROUP BY od.orderID
),
combinationFrequency AS (
    SELECT combination, COUNT(*) AS frequency
    FROM orderCombinations
    GROUP BY combination
)
SELECT combination, frequency
FROM combinationFrequency
ORDER BY frequency DESC
FETCH FIRST 10 ROWS ONLY

-- Based on information provided by the above query, the restaurant owner can now confidently select choices for combo items.

-- INSERT INTO menuitem VALUES ('MI21', 'Chicken Burger Set', 'Chicken burger paired with fries and soft drink', 13.00, 'CT8');
-- INSERT INTO menuItem VALUES ('MI22', 'Spicy Chicken Sandwich Set', 'Spicy chicken sandwich paired with fries and soft drink', 14.00, 'CT8');
-- INSERT INTO menuitem VALUES ('MI23', 'Cheeseburger Set', 'Cheeseburger paired with fries and soft drink', 14.00, 'CT8');
-- INSERT INTO menuItem VALUES ('MI24', 'Fried Chicken Set', 'Fried chicken paired with fries and soft drink', 15.00, 'CT8');

-- INSERT INTO itemConfig VALUES ('MI21', 'IT01');
-- INSERT INTO itemConfig VALUES ('MI21', 'IT10');
-- INSERT INTO itemConfig VALUES ('MI21', 'IT15');
-- INSERT INTO itemConfig VALUES ('MI22', 'IT03');
-- INSERT INTO itemConfig VALUES ('MI22', 'IT10');
-- INSERT INTO itemConfig VALUES ('MI22', 'IT15');
-- INSERT INTO itemConfig VALUES ('MI23', 'IT02');
-- INSERT INTO itemConfig VALUES ('MI23', 'IT10');
-- INSERT INTO itemConfig VALUES ('MI23', 'IT15');
-- INSERT INTO itemConfig VALUES ('MI24', 'IT13');
-- INSERT INTO itemConfig VALUES ('MI24', 'IT10');
-- INSERT INTO itemConfig VALUES ('MI24', 'IT15');