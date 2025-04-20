-- Create the 'users' table for application users
CREATE TABLE users (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  username TEXT UNIQUE NOT NULL,
  password_hash TEXT NOT NULL, -- Store hashed passwords, NOT plain text
  created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- Create the 'departments' table
CREATE TABLE departments (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  name TEXT UNIQUE NOT NULL,
  created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- Create the 'products' table for inventory items
CREATE TABLE products (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  group_name TEXT,
  stock_code TEXT UNIQUE NOT NULL,
  unit TEXT, -- Ölçü Birimi
  material_name_1 TEXT,
  serial_no TEXT,
  material_name_2 TEXT,
  current_stock_quantity DECIMAL(10, 4) NOT NULL DEFAULT 0.0000, -- Mevcut Stok Miktarı (ondalıklı olabilir)
  created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- Create the 'transfers' table
CREATE TABLE transfers (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  transfer_date DATE NOT NULL,
  department_id UUID REFERENCES departments(id) ON DELETE SET NULL,
  description TEXT,
  created_by UUID REFERENCES users(id) ON DELETE SET NULL,
  created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- Create the 'transfer_items' table to link products to transfers
CREATE TABLE transfer_items (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  transfer_id UUID REFERENCES transfers(id) ON DELETE CASCADE,
  product_id UUID REFERENCES products(id) ON DELETE CASCADE,
  transferred_quantity DECIMAL(10, 4) NOT NULL, -- Transfer Edilecek Miktar
  created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- Create the 'purchases' table
CREATE TABLE purchases (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  purchase_date DATE NOT NULL,
  description TEXT,
  created_by UUID REFERENCES users(id) ON DELETE SET NULL,
  created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- Create the 'purchase_items' table to link products to purchases
CREATE TABLE purchase_items (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  purchase_id UUID REFERENCES purchases(id) ON DELETE CASCADE,
  product_id UUID REFERENCES products(id) ON DELETE CASCADE,
  purchased_quantity DECIMAL(10, 4) NOT NULL, -- Satın Alınan Miktar
  created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- Create the 'counts' table for inventory counts
CREATE TABLE counts (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  count_date DATE NOT NULL,
  name TEXT, -- Sayım Adı
  description TEXT,
  created_by UUID REFERENCES users(id) ON DELETE SET NULL,
  created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- Create the 'count_items' table to link products to counts
CREATE TABLE count_items (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  count_id UUID REFERENCES counts(id) ON DELETE CASCADE,
  product_id UUID REFERENCES products(id) ON DELETE CASCADE,
  counted_quantity DECIMAL(10, 4) NOT NULL, -- Sayılan Miktar
  -- We might also store the stock quantity *before* the count for auditing
  stock_quantity_before_count DECIMAL(10, 4),
  created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- Optional: Add RLS (Row Level Security) policies for security
-- This is crucial for production applications!
-- Example RLS policy for products (read access for authenticated users)
-- ALTER TABLE products ENABLE ROW LEVEL SECURITY;
-- CREATE POLICY "Authenticated users can view products" ON products
--   FOR SELECT USING (auth.role() = 'authenticated');

-- Add initial data for users (passwords should be hashed!)
-- IMPORTANT: Replace 'hashed_password_...' with actual bcrypt hashes
-- You will need a server-side process to handle user registration and password hashing.
-- For now, we'll use placeholders.
-- INSERT INTO users (username, password_hash) VALUES
-- ('AKARAL', 'hashed_password_for_AKARAL'),
-- ('BUNYAMIN', 'hashed_password_for_BUNYAMIN'),
-- ('IYILDIZHAN', 'hashed_password_for_IYILDIZHAN');

-- Add initial data for departments
-- INSERT INTO departments (name) VALUES
-- ('BAHÇE'),
-- ('BAKIM'),
-- ('SULAMA'),
-- ('YÖNETİM'),
-- ('MUHASEBE');

-- Add initial data for products (example data)
-- INSERT INTO products (group_name, stock_code, unit, material_name_1, serial_no, material_name_2, current_stock_quantity) VALUES
-- ('CLUB CARCARRY ALL', '500200010', 'ADET', '103974802 PEDAL KİTİ', '103974802', 'PEDAL KİTİ', 1.0000),
-- ('CLUB CARCARRY ALL', '500200011', 'ADET', '1016341 TRANSMISSION SHIFT LEV', '1016341', 'VİTES KOLU ŞANZIMAN TARAFI', 2.0000),
-- ('ILACLAR', '500200012', 'LT', 'BAHÇE İLACI', '102515401', 'BAHCE İLAC', 1.7360),
-- ('GUBRELER', '500200013', 'KG', 'GUBRE', '103833601', 'GUBRE', 2.7000),
-- ('HORTUMLAR', '500200014', 'MT', 'BUYUK HORTUM', '4747546', 'HORTUM', 1.8600);

-- You will need to implement logic in your application
-- to update product stock quantities based on transfers, purchases, and counts.
