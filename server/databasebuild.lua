MySQL.insert.await([[
    CREATE TABLE IF NOT EXISTS xcore_carheisttablet_offers (
        `id` INT AUTO_INCREMENT PRIMARY KEY,
        `name` VARCHAR(255),
        `price` INT,
        `vehicle_model` VARCHAR(255),
        `vehicle_img` VARCHAR(255),
        `spawn_position` VARCHAR(255),
        `category` VARCHAR(255),
        `dispatchinfo` VARCHAR(255),
        `locator` VARCHAR(255)
    );
]], {})

